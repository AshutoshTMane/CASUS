from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg2://postgres:password@localhost:5432/casus"

# Create the engine
engine = create_engine(DATABASE_URL)

# Create a session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Test the connection
try:
    # Try to connect to the database by creating a session
    session = SessionLocal()
    # Use text() to make the SQL query explicit
    result = session.execute(text("SELECT 1"))
    print("Connection successful:", result.fetchall())  # Use fetchall to fetch the result
    session.close()
except Exception as e:
    print("Error connecting to the database:", e)