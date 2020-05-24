import boto3
import magic
import os
import urllib
from dotenv import load_dotenv

load_dotenv()
bucket_name = 'wanderlust.pictures'
s3 = boto3.resource('s3', 
    aws_secret_access_key=os.environ.get('AWS_SECRET'),
    aws_access_key_id=os.environ.get('AWS_ACCESS_KEY')
)

bucket = s3.Bucket('wanderlust.pictures')

def add_profile_picture(username, file):
    mime = magic.from_buffer(file.read(2048), mime=True)
    file.seek(0)
    bucket.put_object(Key=f'{username}/profile_picture', Body=file, ACL='public-read', ContentType=mime)
    file.close()
    return f'https://s3-us-west-1.amazonaws.com/{bucket_name}/{username}/profile_picture'

def delete_folder(username):
    return bucket.objects.filter(Prefix=f'{username}/').delete()

def add_photos(username, iso, title, files):
    """takes in an array of files and returns an array of URLs for the images"""
    names = []
    url_title = title.replace(" ", "+")
    for file in files:
        mime = magic.from_buffer(file.read(2048), mime=True)
        filename = file.filename
        filename = filename.replace(" ", "+")
        file.seek(0)
        bucket.put_object(Key=f'{username}/{iso}/{title}/{filename}', Body=file, ACL='public-read', ContentType=mime)
        file.close()
        filename = urllib.parse.quote(filename)
        url = f'https://s3-us-west-1.amazonaws.com/wanderlust.pictures/{username}/{iso}/{url_title}/{filename}'
        names.append(url)
    return names