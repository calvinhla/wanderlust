from flask import Flask, render_template, session, redirect, g, request, flash, jsonify, url_for
from models import db, connect_db, User, Album, Photo, Country
from forms import RegistrationForm, LoginForm, EditUserForm, EditPasswordForm, CreateAlbumForm, UploadPhotoForm
from werkzeug.utils import secure_filename
from functools import wraps
from dotenv import load_dotenv
from aws import add_profile_picture, delete_folder, add_photos, s3_delete_image, s3_delete_album
from utilities import PhotoManager, AlbumManager
import base64
import os

load_dotenv()
app = Flask(__name__)
app.debug = True
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'password1')
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('SQLALCHEMY_DATABASE_URI', 'postgres:///wanderlust')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = False

connect_db(app)
countries = Country.query.all()
country_choices = [(country.id, country.nicename) for country in countries]
country_albums = {value.iso: len(value.albums) for value in countries}
countries = {value.id: {"nicename":value.nicename, "iso":value.iso} for value in countries}
CURR_USER_ID = 'current_user'

def login_required(f):
    """Keep code DRY - redirect users to login page if they are not logged in"""
    @wraps(f)
    def wrapper(*args, **kwargs):
        if g.user is None:
            return redirect('/login')
        return f(*args, **kwargs)
    return wrapper

def logout_required(f):
    """Keep code DRY - some pages need to redirect to the user's page if the user is already logged in"""
    @wraps(f)
    def wrapper(*args, **kwargs):
        if g.user:
            return redirect(f'/users/{g.user.username}')
        return f(*args, **kwargs)
    return wrapper

def current_user_required(f):
    """Keep code DRY - users should not be able to modify other user's albums/ settings"""
    @wraps(f)
    def wrapper(*args, **kwargs):
        if g.user.username == kwargs['username']:
            return f(*args, **kwargs)
        else:
            flash(f'You do have permissions to do that!', 'danger')
            return redirect(f'/users/{g.user.username}')
    return wrapper

def do_login(user):
    session[CURR_USER_ID] = user.id

def do_logout():
    if CURR_USER_ID in session:
        del session[CURR_USER_ID]


@app.before_request
def add_user_to_g():

    if CURR_USER_ID in session:
        g.user = User.get_id(session[CURR_USER_ID])

    else:
        g.user = None

@app.route('/')
@logout_required
def index():
    #If user is logged on redirect to /users
    return render_template('index.html')

@app.route('/login', methods=["GET", "POST"])
@logout_required
def login_user():

    form = LoginForm()
    if g.user:
        redirect('/user')

    if form.validate_on_submit():
        username = form.username.data
        password = form.password.data
        user = User.authenticate(username,password)
        if user:
            do_login(user)
            return redirect(f'/users/{user.username}')
        else:
            form.username.errors.append('Invalid username or password')
    return render_template('form.html', form=form)

@app.route('/logout')
@login_required
def logout_user():
    do_logout()
    return redirect('/')

@app.route('/signup', methods=["GET", "POST"])
@logout_required
def signup_user():
    form = RegistrationForm()
    form.location.choices = country_choices
    if form.validate_on_submit():

        if form.terms.data:
            #terms were accepted.    
            user = User.register(first_name = form.first_name.data,
                last_name = form.last_name.data,
                username = form.username.data,
                password = form.password.data,
                email=form.email.data
            )

            if user:
                #User was successfully created (username exist in database)
                image = form.image.data
                if image:
                    #If image was specified update user's profile picture
                    url = add_profile_picture(form.username.data, image)
                    user.image = url
                location = form.location.data
                user.location = location
                db.session.add(user)
                db.session.commit()
                do_login(user)
                return redirect(f'/users/{user.username}')

            else:
                form['username'].errors.append('Username already exists')

        else:
            form['terms'].errors.append('Please accept the terms to register')

    return render_template('form.html', form=form)

##### USERS ROUTE ####

@app.route('/users')
@login_required
def search_users():
    """ Return a list of users based on search query"""
    user_search = request.args.get('user')
    users = User.search_username(user_search)
    
    # If user serach returns an empty array flash a message stating no users were found and show all users.
    return render_template('user/users_search.html', users=users)


@app.route('/users/<string:username>')
@login_required
def show_user(username):
    user = User.get_username(username)
    if user:
        return render_template('user/user_profile.html', user=user)
    else:
        flash(f'User not found: {username}', 'danger')
        return redirect(f'/users')

@app.route('/users/<string:username>/edit', methods=["GET", "POST"])
@login_required
@current_user_required
def edit_user(username):

    form = EditUserForm(obj=g.user)
    form.location.choices = country_choices
    if form.validate_on_submit():
        first_name = form.first_name.data
        last_name = form.last_name.data
        email = form.email.data
        image = form.image.data
        username = form.username.data
        location = form.location.data
        bio = form.bio.data 
        if type(image) is str:
            user = g.user.edit_user(first_name, last_name, username, location, bio)
        else:
            url = add_profile_picture(username, image)
            user = g.user.edit_user(first_name, last_name, username, location, bio, url)
        
        if user:
            db.session.add(user)
            db.session.commit()
            return redirect(url_for('show_user', username=username))
        else:
            form.username.errors.append('Username has already been taken')
            return render_template('form.html', form=form)

    return render_template('form.html', form=form)

@app.route('/users/<string:username>/edit/password', methods=["GET", "POST"])
@login_required
@current_user_required
def edit_password(username):

    form = EditPasswordForm()
    if form.validate_on_submit():
        current_password = form.current_password.data
        new_password = form.new_password.data
        confirm = form.confirm.data
        user = User.authenticate(g.user.username, current_password)
        if user:
            user.update_password(new_password)
            return redirect(url_for('show_user', username=username))
        else:
            form.current_password.errors.append('Invalid password')

    return render_template('form.html', form=form)


@app.route('/users/<string:username>/delete', methods=["POST"])
@login_required
@current_user_required
def delete_user(username):

    logout_user()
    user_country_albums = AlbumManager.list_countries(g.user.id)
    for country in user_country_albums:
        country_albums[country.iso] -= len(country.albums)
    db.session.delete(g.user)
    delete_folder(username)
    db.session.commit()
    return redirect('/')


##### ALBUM ROUTES #####

@app.route('/users/<string:username>/albums')
@login_required
def user_albums(username):
    user = User.get_username(username)
    user_countries = AlbumManager.list_countries(user.id)
    return render_template('user/user_countries.html', countries=user_countries, username=username)

@app.route('/users/<string:username>/albums/new', methods=["GET", "POST"])
@login_required
@current_user_required
def create_new_album(username):

    form = CreateAlbumForm()
    form.country.choices=country_choices
    if form.validate_on_submit():
        title = form.title.data
        country_id = form.country.data
        album = Album.add_album(g.user.id, country_id, title)
        if album:
            country_albums[album.country.iso] +=1
            return redirect(f'/users/{username}/albums/{countries[country_id]["iso"]}/{album.title}')
        else:
            form.title.errors.append('Album title already exists')
            return render_template('form.html', form=form)
    return render_template('form.html', form=form)

@app.route('/users/<string:username>/albums/<string:iso>')
@login_required
def show_album(username, iso):

    user = User.get_username(username)
    albums = AlbumManager.get_country_albums(user.id, iso)
    return render_template('user/user_albums.html', albums=albums, username=username)

@app.route('/users/<string:username>/albums/<string:iso>/<string:album_title>')
@login_required
def show_album_photos(username, iso, album_title):
    user = User.get_username(username)
    album = AlbumManager.get_album(user.id, album_title)
    return render_template('user/user_photos.html',username=username, album=album, iso=iso)

@app.route('/users/<string:username>/albums/<string:iso>/<string:album_title>/delete', methods=["POST"])
@login_required
@current_user_required
def delete_user_album(username, iso, album_title):
    album = AlbumManager.get_album(g.user.id, album_title)
    country_albums[album.country.iso] -= 1 
    s3_delete_album(username, iso, album.title)
    db.session.delete(album)
    db.session.commit()
    return redirect(url_for('show_album', username=username, iso=iso))

@app.route('/albums')
def get_album_api():
    user = request.args.get('username')
    if user:
        user = User.get_username(user)
        user_country_albums = AlbumManager.list_countries(user.id)
        album_count = {country.iso: len(country.albums) for country in user_country_albums}
        return jsonify(album_count)
    else:
        return jsonify(country_albums)

####### PHOTOS ########
@app.route('/users/<string:username>/albums/<string:iso>/<string:album_title>/upload', methods=["GET", "POST"])
@login_required
def upload_photos(username, iso, album_title):
    form = UploadPhotoForm()
    album = AlbumManager.get_album(g.user.id, album_title)
    if form.validate_on_submit():
        for file in form.image.data:
            if 'image' not in file.mimetype:
                form.image.errors.append('Images only!')
                return render_template('form.html', form=form)

        filenames = add_photos(username, iso, album.title, form.image.data) # returns an array of urls linking to the uploaded images

        for name in filenames:
            db.session.add(Photo(user_id=g.user.id, album_id=album.id, image=name))
            db.session.commit()
        return redirect(url_for('show_album_photos', username=username, iso=iso, album_title=album_title))
                
    return render_template('form.html', form=form)

@app.route('/photos/delete', methods=["DELETE"])
@login_required
def delete_photo():
    photo_id = request.args.get('imageId')
    photo = PhotoManager.get_photo(photo_id)
    s3_delete_image(g.user.username, photo.album.country.iso, photo.album.title, photo.image)
    db.session.delete(photo)
    db.session.commit()
    return jsonify({'message':'Success'})