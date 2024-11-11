## Github Commands

Here I'm just going to go over the important commands that we will most likely use for efficient development.

TLDR: THINK/DESIGN TWICE, MERGE ONCE
I think a generally good idea is to: Create a branch when you want to start working, implement/push whatever feature you want, and then merge your current feature into a top-level (a few levels above main) development branch when you are satisfied with your work. I personally believe it's best to merge on the github website itself; it's less efficient, but I think we should prioritize safety and clean code, since that will make this development process a lot faster. Generally you can delete your work branch after merging, but you can also leave it if you think you may want to reference it in the future. These extra branches can be cleaned up later on if we need to clone the repo at any point. If you want to test something you're especially unsure about, it's ok to just make a "dummy branch" with the expectation to delete it later for example.

1. git branch  
   Lists all the branches (including local branches) in our repo. It marks which one you are currently on. PLEASE check this before working so we can safely work without making errors in our main branch.

2. git checkout [name]  
   Switches to an existing branch in our repo. If you want to "create and switch" you can type `git checkout -b [name]`, without the brackets of course. Be really careful with this; if you try to switch while you have active un-committed changes, you will have to commit to a branch without wanting to, or entirely lose your current work if we can't risk pushing to that branch.

3. git commit -m "Message"  
   Commits your staged changes to the local repository with a descriptive message. It saves the changes locally, but doesn't push them to the remote repository.

4. git push  
   Pushes your local commits to the remote repository, updating the branch you're working on. Ensure you're pushing to the correct branch to avoid mistakes.

5. git pull  
   Fetches and merges the latest changes from the remote repository into your current branch. Always use this to keep your local branch up-to-date with the remote version.

6. git fetch  
   Downloads changes from the remote repository but doesn't merge them into your local branch. Use this to review remote updates before manually merging them.

## Flutter Setup

1. Download Flutter SDK: Visit the Flutter SDK installation page and download the SDK for your operating system (Windows, macOS, or Linux). Since we are mainly windows: https://docs.flutter.dev/get-started/install/windows/desktop

2. Extract the SDK:  
   Windows: Extract the zip file and move the flutter folder to a convenient location (e.g., C:\flutter).

3. Add Flutter to Your Path:  
    First of all, open up the flutter folder from above and copy the file path for the bin folder (after opening it).  
    a. Update the system environment variables. Search "system variables" in your computers search bar, and it should take you to a place with a button called "Environment Variables".  
    b. Then under System Variables, find "Path"; double click or press the Edit button after selecting. Then, press New and copy the new file to the Path.  
   (OPTIONAL): You can go to your VSCode terminal and type `flutter doctor` to see if it's installed properly.

4. Install the Flutter extension in VSCode

5. Create Flutter app (SKIP: not required for us since it's on the Github)  
   a. Go to the directory you want (frontend in our case) and type `flutter create app_name`

6. Run the Flutter app  
   a. Go to the app directory, most likely CASUS/frontend/flutter_app, and type `flutter run`.  
   NOTE: This does NOT start the testing environment. The section to do so is near the bottom.

## FastAPI/Python Setup

1. Start python environment (SKIP: Should be done and in GitHub already)  
   a. Create the python environment by typing `python3 -m venv venv` in terminal in the correct directory (most likely backend)  
   b. You should be able to run with a line like `venv\Scripts\activate` but I've had problems with this in the past. This new line should make it work without issue: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` and `.\venv\Scripts\Activate.ps1`.

2. Install FastAPI and Uvicorn using: `pip install fastapi uvicorn`

3. Download FastAPI CORS:  
   a. This isn't crucial for FastAPI, but to connect our frontend Flutter process with the FastAPI app, we will require CORS to handle incoming requests. Install using `pip install fastapi-cors`

4. Run the FastAPI app with Uvicorn using `uvicorn main:app --reload`. This means you're running the app = FastAPI() from main.py.

5. Beyond that, you can run `pip install requirements.txt` to get all the python libraries used.

## PostgreSQL Setup

1. Install PostgreSQL from their website https://www.postgresql.org/download/

2. Use the setup wizard to install their application. I believe you can click through and not need to actually update any of the fields. You can reasonably set your password to anything, but I just called it `password`. I believe it asks for the port as well, but just leave it as 5432.

3. Open pgAdmin, which was installed along with the database system. You can now input your password and start to create databases. I made my first one and called it `casus`.

## Testing Environment Setup

1. Download Android Studio from https://developer.android.com/studio  
   Go through whatever setup wizard they have.

2. Open the Android Studio and click where it says "Tools" or "More". You are mainly looking for something that's called like Android Virtual Device Manage.

3. Create a device that will act as your virtual emulator for an Android phone. You can also connect your real phone (I explain how later), but this allows us to test many different Android devices. You can choose any type of device and OS version, for example I chose a Galaxy Pixel 7 with Vanilla Ice Cream (Version 15).

4. Start the device using the play button. Similarly, I believe connecting your real phone via cable to your computer should be equivalent to this, if you want to use your actual phone. To check if your device is active once you start it, type `flutter devices` and it should be obvious if your device is visible. For the emulators, it will most likely say something like "emulator-5554"

5. Run your Flutter app on your test device by typing `flutter run -d device-name`. For example: `flutter run -d emulator-5554`
