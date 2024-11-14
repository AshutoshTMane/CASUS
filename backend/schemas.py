from pydantic import BaseModel

# Base schema for user-related data, containing common fields
class UserBase(BaseModel):
    id: int
    email: str
    password: str

    class Config:
        from_attributes = True  # Enables data parsing directly from ORM objects

# Schema for user creation, used for registration
class UserCreate(BaseModel):
    email: str
    password: str

    class Config:
        from_attributes = True  

# Schema for user response, omits sensitive information like password
class UserResponse(BaseModel):
    id: int
    email: str

    class Config:
        from_attributes = True  

# Schema for login request, used for user authentication
class LoginRequest(BaseModel):
    email: str
    password: str

    class Config:
        from_attributes = True 

