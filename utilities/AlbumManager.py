import sys
sys.path.append('..')
from models import Album, Country, User

def list_countries(user_id):
    return Country.query.join(Album, Album.country_id==Country.id).join(User, Album.user_id==user_id).all()
    
def get_country_albums(user_id, iso):
    country = Country.query.filter(Country.iso==iso.upper()).first_or_404()
    return Album.query.filter_by(user_id=user_id, country_id=country.id).all()

def get_album(user_id, title):
    return Album.query.filter(Album.title==title, Album.user_id==user_id).first_or_404()
    