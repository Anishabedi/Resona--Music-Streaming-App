from fastapi import Depends, HTTPException
import uuid
import bcrypt
from models.user import User
from pydantic_schemas.user_create import CreateUser
from fastapi import APIRouter
from sqlalchemy.orm import Session
from database import get_db
from pydantic_schemas.user_login import LoginUser
import jwt
from dotenv import load_dotenv
import os
from sqlalchemy.orm import joinedload
from middleware.auth_middleware import auth_middleware

router = APIRouter()

@router.post('/signup',status_code=201)
def signup_user(user:CreateUser,db: Session = Depends(get_db)):
    # extract the data thats coming from request
    print(user.name)
    print(user.email)

    # check if the user already exists in db
    user_db= db.query(User).filter(User.email==user.email).first()

    if user_db:
        raise HTTPException(400,'User with the same email already exists!')

    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt() )
    # add the user to the db
    user_db = User(id=str(uuid.uuid4()),name= user.name.strip(), email=user.email.strip(), password=hashed_pw)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db


@router.post('/login')
def login_user(user:LoginUser ,db: Session = Depends(get_db)):
    print("Email received:", user.email)
    print("Email length:", len(user.email))
    # check if the user with same email exists if not then signup
    user_db= db.query(User).filter(User.email==user.email.strip()).first()
    print("User found:", user_db)
    all_users = db.query(User).all()
    for u in all_users:
        print("DB Email:", repr(u.email))

    if not user_db:
        raise HTTPException(400,'User does\'t exist')

    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)

    if not is_match:
        raise HTTPException(400,'Incorrect Password!')

    load_dotenv()
    PASSWORD_KEY = os.getenv("PASSWORD_KEY")
    token = jwt.encode({'id': user_db.id}, PASSWORD_KEY)                  # password key ko env mei dalna hai

    return {'token': token, 'user': user_db}

@router.get('/')
def current_user_data(db: Session=Depends(get_db), user_dict = Depends(auth_middleware) ):
    user = db.query(User).filter(User.id == user_dict['uid']).options(joinedload(User.favourites)).first()

    if not user:
        raise HTTPException(404,'User not found!')

    return user




    # check if pass is same return user data else error
