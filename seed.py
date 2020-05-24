from sqlalchemy import create_engine
from models import db, connect_db, User, Album, Photo, Country
from app import app

engine = create_engine('postgres:///wanderlust')
# Photo.__table__.drop(engine)
# db.session.commit()
# Album.__table__.drop(engine)
# User.__table__.drop(engine)
# db.session.commit()

db.create_all()

User.query.delete()
Album.query.delete()
Photo.query.delete()

db.session.commit()

# a = Album(user_id=4, country_id=3, title='Test')
# b = Album(user_id=4, country_id=5, title='Another Test'