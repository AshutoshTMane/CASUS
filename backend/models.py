# models.py
from sqlalchemy import Column, Integer, String
from database import Base # Import the Base class to inherit for model creation

# Define the User model class, representing a table in the database
class User(Base):
    __tablename__ = "users" # Set the table name in the database

    id = Column(Integer, primary_key=True, index=True) # id: Unique identifier for each user, serves as the primary key
    email = Column(String, unique=True, index=True) # email: Stores the user's email, must be unique for each user
    password = Column(String, index=True)  # password: Stores the user's password, index for faster lookup
