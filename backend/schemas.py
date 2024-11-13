from pydantic import BaseModel

class UserBase(BaseModel):
    id: int
    email: str
    password: str

    class Config:
        from_attributes = True  # updated from orm_mode

class UserCreate(BaseModel):
    email: str
    password: str

    class Config:
        from_attributes = True  # updated from orm_mode

class UserResponse(BaseModel):
    id: int
    email: str

    class Config:
        from_attributes = True  # updated from orm_mode

class LoginRequest(BaseModel):
    email: str
    password: str

    class Config:
        from_attributes = True  # updated from orm_mode

