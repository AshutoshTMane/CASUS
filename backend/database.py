# database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Database connection URL for PostgreSQL database using psycopg2 driver
DATABASE_URL = "postgresql+psycopg2://postgres:password@localhost:5432/casus"

# Create a synchronous SQLAlchemy engine for connecting to the database
# This engine is bound to the PostgreSQL database specified in DATABASE_URL
engine = create_engine(DATABASE_URL)

# Configure sessionmaker to create individual database sessions for each request
# autocommit=False: disables automatic commit; the session must explicitly commit
# autoflush=False: disables automatic flushing to improve performance
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Declare a base class for SQLAlchemy models
# All model classes will inherit from this Base to define tables and columns
Base = declarative_base()

# Dependency to provide a new database session for each request
# Sessions are created using SessionLocal and closed automatically at the end
def get_db():
    db = SessionLocal()
    try:
        yield db  # Yield the session to the request handler
    finally:
        db.close()  # Ensure the session is closed after the request is complete
