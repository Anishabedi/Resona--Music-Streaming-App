from fastapi import APIRouter, File, UploadFile, Form, Depends
from sqlalchemy.orm import Session
from database import get_db
import cloudinary
import cloudinary.uploader
from middleware.auth_middleware import auth_middleware
from models.song import Song
from pydantic_schemas.favourite_song import FavouriteSong
from sqlalchemy.orm import joinedload
from models.favourite import Favourite
from sqlalchemy import or_
import uuid

router = APIRouter()


cloudinary.config(
  cloud_name = "nhvsn3ja",
  api_key = "533172935384926",
  api_secret = "FSFLZoo_AHCSuM4f-itI6Dl0FNU",              # env mei dalna hai
)


@router.post('/upload', status_code = 201)
def upload_song(song: UploadFile = File(...),
                thumbnail:UploadFile = File(...),
                artist: str = Form(...),
                song_name:str = Form(...),
                hex_code:str = Form(...),
                db: Session= Depends(get_db),
                auth_dict=Depends(auth_middleware)
                ):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type='auto', folder='songs/{song_id}')
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder='songs/{song_id}')


    new_song = Song(
        id=song_id,
        song_name= song_name,
        artist=artist,
        hex_code=hex_code,
        song_url=song_res['url'],
        thumbnail_url = thumbnail_res['url'],
    )

    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song

@router.get('/list')
def list_songs(db: Session=Depends(get_db), auth_details=Depends(auth_middleware)):
     songs = db.query(Song).all()  # present all rows present in the table
     return songs

@router.post('/favourite')
def favourite_song(song: FavouriteSong, db: Session=Depends(get_db),auth_details=Depends(auth_middleware)):
    # check if song fav if fav then unfav if unfav then fav

    user_id = auth_details['uid']

    fav_song = db.query(Favourite).filter(Favourite.song_id == song.song_id,Favourite.user_id== user_id ).first()

    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message': False}
    else:
        new_fav = Favourite(id=str(uuid.uuid4()),song_id=song.song_id, user_id=user_id)
        db.add(new_fav)
        db.commit()
        return {'message': True}
    pass

@router.get('/list/favourites')
def list_fav_songs(db: Session=Depends(get_db), auth_details=Depends(auth_middleware)):
    user_id = auth_details['uid']
    fav_songs = db.query(Favourite).filter(Favourite.user_id== user_id ).options(
        joinedload(Favourite.song)
    ).all()


    return fav_songs

@router.get('/search')
def search_songs(name: str = '', db: Session = Depends(get_db), auth_details = Depends(auth_middleware)):
    songs = db.query(Song).filter(
        or_(
            Song.song_name.ilike(f'%{name}%'),
            Song.artist.ilike(f'%{name}%')
        )
    ).limit(25).all()
    return songs












