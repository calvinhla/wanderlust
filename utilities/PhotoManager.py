import sys
sys.path.append('..')
from models import Photo

def all_album_photos(album_id):
    return Photo.query.filter_by(album_id=album_id).all()
