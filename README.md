

# 🌍 Trip Sync

An innovative application designed to suggest travel destinations for groups of friends from various regions, helping them plan trips effortlessly.

---

## ✨ Features

- **Personalized Suggestions**: Leveraging SerpAPI to recommend destinations tailored to group preferences and user query.
- **Cross-Platform App**: Built with Flutter for a seamless experience on iOS and Android.
- **Interactive Backend**: Powered by Django for robust and scalable backend support.

---
Welcoming Screen
<div style="display: flex; justify-content: space-around; align-items: center;">
  <img src="https://github.com/user-attachments/assets/b05676bc-9fcc-4cdc-91b9-8da3709265c9" alt="Simulator Screenshot" width="200">
  <img src="https://github.com/user-attachments/assets/50c657fa-aaa5-4660-b99f-e897e5aa9d62" alt="Image 2" width="200">
  <img src="https://github.com/user-attachments/assets/b1139ade-973e-4e71-8af7-9538a0ff8090" alt="Image 3" width="200">
  <img src="https://github.com/user-attachments/assets/aaf579f3-410a-4485-8314-0441dad22d4d" alt="Image 4" width="200">
</div>

Login Screen
<div style="display: flex; justify-content: center; align-items: center; gap: 10px;">
    <img src="https://github.com/user-attachments/assets/5a8167f2-ca04-445a-afef-852426ec517e" alt="Login Screen 1" width="200">
    <img src="https://github.com/user-attachments/assets/47c63a4b-9c9c-4089-9065-ef3ea962a768" alt="Login Screen 2" width="200">
    <img src="https://github.com/user-attachments/assets/7f83705f-2432-4256-9cac-ca12a2dfeffa" alt="Login Screen 3" width="200">
</div>

Home Screen
If you are a new user then it would be:

But after create some calendar:
<div style="display: flex; justify-content: center; align-items: center; gap: 10px;">
    <img src="https://github.com/user-attachments/assets/09e2d144-bf4e-486d-a8f3-0cca0df3109c" alt="Home Screen New User" width="200">
    <img src="https://github.com/user-attachments/assets/53237bae-1a37-44e4-a52d-2f947f5be04d" alt="Home Screen with Calendars" width="200">
</div>

Search Screen
<div style="display: flex; justify-content: center; align-items: center; gap: 10px; flex-wrap: wrap;">
    <img src="https://github.com/user-attachments/assets/1bfc2264-d54e-46d4-b1fd-448f1be531ab" alt="Search Screen 1" width="150">
    <img src="https://github.com/user-attachments/assets/73678a42-b85e-4d2d-ace7-7195533d0081" alt="Search Screen 2" width="150">
    <img src="https://github.com/user-attachments/assets/455e175e-16a1-431b-92ee-86fd2da5e479" alt="Search Screen 3" width="150">
    <img src="https://github.com/user-attachments/assets/5bbce336-e9d0-4973-93ea-0d96930febdc" alt="Search Screen 4" width="150">
    <img src="https://github.com/user-attachments/assets/8e4bfd38-466e-4af6-9690-9f40cbb4162d" alt="Search Screen 5" width="150">
</div>


Today Page
![image](https://github.com/user-attachments/assets/4909759c-8781-4127-9240-46cecef60656)


Calendar Page
![image](https://github.com/user-attachments/assets/934e4a26-ad0d-42e6-95a2-7a401b80ffc7)
![image](https://github.com/user-attachments/assets/d689208f-0738-4f4e-9b34-70ff0b972968)
![image](https://github.com/user-attachments/assets/d63e537b-d6ef-442e-ad2e-28d133bb2df1)
![image](https://github.com/user-attachments/assets/59a06243-c158-431c-b97e-2c2d12a496b5)
![image](https://github.com/user-attachments/assets/d8e50427-7ccf-468b-9a68-2cd933df74d6)
![image](https://github.com/user-attachments/assets/dd328c90-3228-4162-82e7-5dd4f6e1e73f)

Community Page
Able to like a post
![image](https://github.com/user-attachments/assets/0b10c063-6351-4ec4-95b5-81871220cc50)
If already add friend
![image](https://github.com/user-attachments/assets/7e041b15-02a8-47e7-9fe7-4d719dfc3dc5)
If my own post
![image](https://github.com/user-attachments/assets/3c0bfe26-ab36-481e-b7a6-38c311c75253)

Friend Page
![image](https://github.com/user-attachments/assets/a763de24-4b7c-411d-99c2-c2d4d36d26e2)
![image](https://github.com/user-attachments/assets/0c52206e-4a26-46a2-a490-2422101a9956)

Profile Page
![image](https://github.com/user-attachments/assets/fd6b740c-444d-4615-9596-ae248c6999b4)
View Avatar
![image](https://github.com/user-attachments/assets/5ca23ab0-0ace-4f4c-b7a8-83610dea3407)
Change name
![image](https://github.com/user-attachments/assets/867ec0cf-467c-4f1d-b713-7d7231a70c57)
Change Avatar
![image](https://github.com/user-attachments/assets/93d9db40-eb1c-49c1-bdfc-c7668b2f055a)


## 🚀 Getting Started

Follow these steps to set up and run the application locally:

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Open the iOS Simulator:
   ```bash
   open -a Simulator
   ```
4. Run the Flutter app:
   ```bash
   flutter run
   ```

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Remove the existing database if it exists:
   ```bash
   rm db.sqlite3
   ```
3. Apply database migrations:
   ```bash
   python3 manage.py makemigrations
   python3 manage.py migrate
   ```
4. Load predefined activities into the database:
   ```bash
   python3 manage.py load_activities
   ```
5. Start the development server:
   ```bash
   python3 manage.py runserver
   ```

---

### Loading backend API JSON files

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Type and enter this to run apiEventData:
   ```bash
   python3 apiEventData.py
   ```
3. Then go to link indcated in terminal:
4. Same goes for apiHotelsData.

---

## 🛠️ Technologies Used

- **Frontend**: Flutter
- **Backend**: Django
- **API Integration**: SerpAPI, GeocodingAPI

---

## 🎉 Ready to Plan Your Next Adventure?

Start the app and let **Travel Buddy Finder** recommend the perfect destination for you and your friends!

---
