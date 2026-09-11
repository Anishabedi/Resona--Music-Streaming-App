from fastapi import FastAPI
from routes import auth , song
from models.base import Base
from database import engine


app = FastAPI()
app.include_router(auth.router,prefix='/auth')
app.include_router(song.router,prefix='/song')

Base.metadata.create_all(engine)




















# class Test(BaseModel):
#     name:str
#     age:int
# @app.post('/')
# def test(t:Test):                        # agr class bnayenge  or t extend krega basemodel to vo request body ki trh lega nhi to query parameter ki trh lega
#     print(t)
#     return 'ok'




#     from fastapi import FastAPI, Request
#
#     app = FastAPI()
#
#     @app.post('/')
#     async def test(request: Request):
#         print((await request.body()).decode())
#         return 'ok'