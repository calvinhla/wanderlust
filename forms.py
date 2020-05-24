from flask_wtf import FlaskForm
from flask_wtf.file import FileAllowed, FileField
from wtforms import StringField, PasswordField, SelectField, BooleanField, MultipleFileField, TextAreaField
from wtforms.fields.html5 import EmailField
from wtforms.validators import InputRequired, Length, EqualTo, Regexp
from wtforms_validators import AlphaNumeric


class RegistrationForm(FlaskForm):

    first_name = StringField('First Name*', validators=[InputRequired(), Length(max=50)])

    last_name = StringField('Last Name*', validators=[InputRequired(), Length(max=50)])
    
    email = EmailField('Email', validators=[InputRequired()])

    username = StringField('Username*', validators=[InputRequired(), Length(max=30)])

    password = PasswordField('Password*', validators=[InputRequired(), Length(min=6)])

    image = FileField('Profile Picture', validators=[FileAllowed(['jpg', 'png'], 'Images only')])

    location = SelectField('Country', validate_choice=False, coerce=int)

    terms = BooleanField('I acknowledge that all images uploaded to Wanderlust will be publicly available')

class LoginForm(FlaskForm):

    username = StringField('Username', validators=[InputRequired()])

    password = PasswordField('Password', validators=[InputRequired()])

class EditUserForm(RegistrationForm):

    password = None
    
    terms = None

    bio = TextAreaField('Description', validators=[Length(max=100)])

class EditPasswordForm(FlaskForm):

    current_password = PasswordField('Current', validators=[InputRequired(), Length(min=0)])

    new_password = PasswordField('New', validators=[InputRequired(), EqualTo('confirm', message="Passwords must match"), Length(min=6)])

    confirm = PasswordField('Re-type new')

class CreateAlbumForm(FlaskForm):

    title = StringField('Album Name', validators=[InputRequired(), Regexp(regex='^[a-zA-Z0-9 ]*$', message="Album can only contain alphanumeric characters and spaces"), Length(max=50)])

    country = SelectField('Country', validators=[InputRequired()], coerce=int)

class UploadPhotoForm(FlaskForm):

    image = MultipleFileField('Profile Picture', validators=[InputRequired()])