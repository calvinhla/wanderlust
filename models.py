from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from sqlalchemy.exc import IntegrityError, InvalidRequestError
import datetime

db = SQLAlchemy()
bcrypt = Bcrypt()

def connect_db(app):
    db.app = app
    db.init_app(app)

class User(db.Model):

    __tablename__ = 'users'

    id = db.Column(db.Integer,
        primary_key=True)

    first_name = db.Column(db.String(50))

    last_name = db.Column(db.String(50))

    username = db.Column(db.String(30), unique=True)

    email = db.Column(db.Text, unique=True, nullable = False)

    password = db.Column(db.Text)

    image = db.Column(db.Text, default='/static/images/default-pic.png')

    location = db.Column(db.Integer)

    bio = db.Column(db.String(100), nullable=True)

    albums = db.relationship('Album', backref='user', cascade="all, delete-orphan")

    @classmethod
    def get_id(cls, id):
        return cls.query.get(id)

    @classmethod
    def get_username(cls, username):
        return cls.query.filter_by(username=username.lower()).first_or_404()

    @classmethod
    def search_username(cls, username):
        return cls.query.filter(cls.username.ilike(f'%{username}%')).all()

    @classmethod
    def register(cls, first_name, last_name, username, password, email, location=None):
        try:
            hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
            
            user = cls(first_name = first_name,
                last_name = last_name,
                username = username.lower(),
                password = hashed_password,
                email= email.lower()
            )
            db.session.add(user)
            db.session.commit()
            return user
        
        except IntegrityError:
            return None


    @classmethod
    def authenticate(cls, username, password):
        user = cls.query.filter_by(username=username.lower()).first()
        if user:
            is_auth = bcrypt.check_password_hash(user.password, password)
            if is_auth:
                return user
                
        else:
            return False

    
    def edit_user(self, first_name, last_name, username, location, bio=None, image=None):
        user = User.query.filter(User.username==username).first()
        if user and self.username != username:
            return False
        else:
            self.first_name = first_name
            self.last_name = last_name
            self.username = username
            self.location = location
            self.bio = bio
            if image:
                self.image = image
            return self

    def update_password(self, new_password):

        hashed_password = bcrypt.generate_password_hash(new_password).decode('utf-8')
            
        self.password = hashed_password
        db.session.add(self)
        db.session.commit()
        return True


    def __repr__(self):
        return f'<{self.id}. {self.first_name} {self.last_name} ({self.username})>'

class Country(db.Model):

    __tablename__ = 'countries'

    id = db.Column(db.Integer, primary_key=True)

    iso = db.Column(db.String(2), unique=True)

    name = db.Column(db.String(80))

    nicename = db.Column(db.String(80))

    albums = db.relationship('Album', backref='country')

class Album(db.Model):

    __tablename__ = 'albums'

    id = db.Column(db.Integer, primary_key=True, unique=True)

    user_id = db.Column(db.Integer, db.ForeignKey('users.id', ondelete="CASCADE"))

    country_id = db.Column(db.Integer, db.ForeignKey('countries.id'))

    title = db.Column(db.String(50), nullable=False)

    created_on = db.Column(db.DateTime, default=datetime.datetime.utcnow)

    @classmethod
    def add_album(cls, user_id, country_id, title):
        db.session.remove()
        album = cls.query.filter(cls.user_id==user_id, cls.country_id==country_id, cls.title==title).first()
        if album:
            return None
        else:
            album = cls(user_id=user_id, country_id=country_id, title=title)
            db.session.add(album)
            db.session.commit()
            return album

class Photo(db.Model):

    __tablename__ = 'photos'

    id = db.Column(db.Integer, primary_key=True)

    user_id = db.Column(db.Integer, db.ForeignKey('users.id', ondelete="CASCADE"))

    album_id = db.Column(db.Integer, db.ForeignKey('albums.id', ondelete="CASCADE"))

    image = db.Column(db.Text)

    upload_on = db.Column(db.DateTime, default=datetime.datetime.utcnow)

    album = db.relationship('Album', backref='photos')