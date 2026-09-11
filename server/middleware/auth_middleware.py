from fastapi import HTTPException, Header
import jwt
from dotenv import load_dotenv
import os

load_dotenv()
PASSWORD_KEY = os.getenv("PASSWORD_KEY")
def auth_middleware(x_auth_token = Header()):
    try:
        # get the use token from header
        if not x_auth_token:
            raise HTTPException(401,'No auth token, access denied!')
        # decode token
        verified_token = jwt.decode(x_auth_token, PASSWORD_KEY,['HS256'])

        if not verified_token:
            raise HTTPException(401,'Token verified failed,authorization denied!')

        # get id from token
        uid = verified_token.get('id')
        return {'uid' : uid, 'token': x_auth_token}
        # postgres database get the user info
    except jwt.PyJWTError:
        raise HTTPException(401, 'Token is not valid,authorization failed.')
