# routers/users.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .models import User  # Make sure User is imported correctly from models
from .dependencies import get_db

# Define a router
router = APIRouter()

# Route to create a new user
@router.post("/users/")
def create_user(name: str, email: str, db: Session = Depends(get_db)):
    db_user = User(name=name, email=email)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

# Route to get a user by ID
@router.get("/users/{user_id}")
def get_user(user_id: int, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.id == user_id).first()
    if db_user:
        return db_user
    raise HTTPException(status_code=404, detail="User not found")
