from fastapi import FastAPI, Depends, HTTPException, Request, File, UploadFile
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware
from database import engine, SessionLocal, Base, get_db
from schemas import LoginRequest
from models import User
import logging
from google.cloud import vision
from google.cloud.vision_v1 import types
import io
import os
import requests
from dotenv import load_dotenv

# Create FastAPI app instance
app = FastAPI()

# Allow all origins for development (adjust in production)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (use specific domains in production)
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods (GET, POST, etc.)
    allow_headers=["*"],  # Allow all headers
)

load_dotenv()

credential_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = credential_path
vision_client = vision.ImageAnnotatorClient()

GOOGLE_MAPS_API_KEY = os.getenv("GOOGLE_MAPS_API_KEY")

# Create tables
Base.metadata.create_all(bind=engine)

# Simple logging configuration
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Default root endpoint, you can see this in the FastAPI port 8000
@app.get("/")
def read_root():
    return {"message": "Hello, World"}

# Note these endpoints will need to be moved and refactored later in development
# Register endpoint for user registration
@app.post("/register")
async def register(request: Request, db: Session = Depends(get_db)):
    try:
        # Retrieve JSON data from the incoming HTTP request body
        data = await request.json()

        # Print the received data to FastAPI console
        print(f"Received data: {data}")

        # Extract email and password from the received data
        email = data.get('email')
        password = data.get('password')
        
        # Validate the email and password fields
        if not email or not password:
            raise HTTPException(status_code=400, detail="Invalid email or password")
        
        # Check if email already exists
        existing_user = db.query(User).filter(User.email == email).first()
        if existing_user:
            raise HTTPException(status_code=400, detail="Email already registered")
        
        # Create a new user
        new_user = User(email=email, password=password)  # Password should be hashed in real-world apps
        db.add(new_user)
        db.commit()  # Commit to save the new user to the database
        db.refresh(new_user)  # Refresh the object to get the updated fields (e.g., id)

        # Return success message
        return {"message": f"User with email {email} successfully registered!"}

    except Exception as e:
        # Log unexpected errors and return a 500 error
        print(f"Error in register endpoint: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")
    

# Define the login endpoint for user authentication
@app.post("/login")
def login(data: LoginRequest, db: Session = Depends(get_db)):
    # Log the login attempt for the provided email
    logger.info("Login attempt with email: %s", data.email)
    
    try:
        # Check if a user with the given email exists in the database
        user = db.query(User).filter(User.email == data.email).first()
        if not user:
            logger.warning("Login failed: No user found with email %s", data.email)
            raise HTTPException(status_code=401, detail="Invalid email or password")

        # Validate the provided password (should be hashed in production)
        if user.password != data.password:
            logger.warning("Login failed: Incorrect password for email %s", data.email)
            raise HTTPException(status_code=401, detail="Invalid email or password")

        # Login successful; return success message and user ID
        logger.info("Login successful for email: %s", data.email)
        return {"message": "Login successful", "user_id": user.id}

    except HTTPException as http_exc:
        raise http_exc  # Re-raise specific HTTP errors

    except Exception as e:
        # Log unexpected errors and respond with a 500 HTTP error
        logger.error("Unexpected error during login for email %s: %s", data.email, str(e))
        raise HTTPException(status_code=500, detail="Internal server error")
    

def get_wikipedia_summary(title):
    try:
        url = f"https://en.wikipedia.org/api/rest_v1/page/summary/{title}"
        res = requests.get(url)
        if res.status_code == 200:
            return res.json().get("extract", "No summary found.")
        return "No summary available."
    except:
        return "Description unavailable."

#Uses Google Maps Geocoding API to provide address given coordinates
def get_address_from_latlng(lat, lng):
    try:
        geocode_url = (
            f"https://maps.googleapis.com/maps/api/geocode/json?latlng={lat},{lng}&key={GOOGLE_MAPS_API_KEY}"
        )
        response = requests.get(geocode_url).json()
        if response["status"] == "OK" and response["results"]:
            return response["results"][0]["formatted_address"]
        return "Address not found"
    except Exception as e:
        return f"Error retrieving address: {str(e)}"


#Provides brief summary of landmark
def get_wikipedia_summary(title):
    try:
        url = f"https://en.wikipedia.org/api/rest_v1/page/summary/{title}"
        res = requests.get(url)
        if res.status_code == 200:
            return res.json().get("extract", "No summary found.")
        return "No summary available."
    except:
        return "Description unavailable."


# Main endpoint
@app.post("/identify_landmark")
async def identify_landmark(file: UploadFile = File(...)):
    try:
        file_contents = await file.read()
        image = vision.Image(content=file_contents)
        response = vision_client.landmark_detection(image=image)
        landmarks = response.landmark_annotations

        if response.error.message:
            raise HTTPException(status_code=500, detail=f"Vision API error: {response.error.message}")

        result_list = []

        for landmark in landmarks:
            name = landmark.description
            lat_lng = landmark.locations[0].lat_lng
            latitude = lat_lng.latitude
            longitude = lat_lng.longitude
            address = get_address_from_latlng(latitude, longitude)
            summary = get_wikipedia_summary(name)

            result_list.append({
                "name": name,
                "description": summary,
                "location": {
                    "address": address
                }
            })

        if not result_list:
            return {"message": "No recognizable landmarks found."}

        return {"landmarks": result_list}

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error processing image: {str(e)}")