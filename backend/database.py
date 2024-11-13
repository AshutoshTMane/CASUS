# database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:password@localhost:5432/casus"

# Synchronous engine and session (optional: use only for synchronous needs)
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base for model classes
Base = declarative_base()

# For async databases, consider using `databases` library
# async_database = databases.Database(DATABASE_URL)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
