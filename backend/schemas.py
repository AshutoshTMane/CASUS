from pydantic import BaseModel

"""
This module defines Pydantic schemas for user-related data in a FastAPI application.  
These schemas enforce data validation and structure for user operations, including  
registration, authentication, and responses.  

Schemas included:  
- UserBase: Defines common fields for user data.  
- UserCreate: Used for user registration, excluding the user ID.  
- UserResponse: Returns user data without sensitive information like passwords.  
- LoginRequest: Defines the expected format for login credentials.  
"""

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

