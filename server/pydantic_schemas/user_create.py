from pydantic import BaseModel
# schemas
class CreateUser(BaseModel):
    name:str
    email:str
    password:str