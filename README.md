# An API for Skill-Resource DB with AI Based Vetting

This project is a **FastAPI-based web service** that provides roadmap resources for different roles. It fetches skills and learning materials from a **PostgreSQL database** and uses the **Google Gemini API** to vet resource reliability.

## Features
- **Retrieve roadmap** for a given role, including associated skills and resources.
- **Vetting endpoint** to check if a learning resource is reliable using Google Gemini API.

## Setup Instructions
### Prerequisites
- Python 3.8+
- PostgreSQL Database
- Google Gemini API Key
- Railway (or any deployment platform)

### Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/prabhuanantht/Skill-Resource-DB-API.git
   cd Skill-Resource-DB-API
   ```

2. Create a virtual environment:
   ```sh
   python -m venv venv
   source venv/bin/activate  # On Windows, use 'venv\Scripts\activate'
   ```

3. Install dependencies:
   ```sh
   pip install -r requirements.txt
   ```

4. Create a `.env` file and add the following:
   ```ini
   DATABASE_URL=postgresql://username:password@host:port/dbname
   GEMINI_API_KEY=your-gemini-api-key
   ```
## Database Setup

### Option 1: Setup with Local PostgreSQL  
1. Start PostgreSQL and create a database:
   ```sql
   CREATE DATABASE roadmap_api;
   ```

2. Connect to the database:
   ```sh
   psql -U your_username -d roadmap_api
   ```

3. Run the SQL schema setup from the repo:
   ```sh
   psql -U your_username -d roadmap_api -f db_setup.sql
   ```

---

### Option 2: Setup with Supabase  

1. **Sign Up & Create a Project**  
   - Go to [Supabase](https://supabase.com) and sign up.  
   - Create a new project and choose **PostgreSQL** as the database.

2. **Get Database Connection String**  
   - Navigate to **Project Settings** → **Database**.  
   - Copy the `Connection URI`, which looks like this:  
     ```
     postgresql://postgres:<password>@db.<unique_id>.supabase.co:5432/postgres
     ```

3. **Run the Schema Migration**  
   - In Supabase, go to the **SQL Editor**.  
   - Click **New Query**, then open `db_setup.sql` from the repo and paste the contents.  
   - Click **RUN** to execute the schema.

4. **Update `.env` File**  
   ```ini
   DATABASE_URL=postgresql://postgres:<password>@db.<unique_id>.supabase.co:5432/postgres
   ```
### Running the API
```sh
uvicorn main:app --host 0.0.0.0 --port 8080
```

## API Endpoints
### 1. Home Route
- **Endpoint:** `GET /`
- **Response:**
  ```json
  { "message": "Hello from Railway!" }
  ```

### 2. Get Roadmap for a Role
- **Endpoint:** `GET /api/roadmap?role=<role_name>`
- **Response:**
  ```json
  {
    "role": "Data Scientist",
    "skills": [
        "Machine Learning",
        "Data Visualization",
        "SQL & Databases",
        "Deep Learning",
        "Statistics"
    ],
    "resources": [
        {
        "skill": "Machine Learning",
        "title": "Intro to ML by Andrew Ng",
        "url": "https://www.coursera.org/ml-course",
        "type": "course",
        "vetted": true
        }
    ]
  }
  ```

### 3. Vet a Learning Resource
- **Endpoint:** `POST /api/vet`
- **Request Body:**
  ```json
  { "url": "https://coursera.org/ml" }
  ```
- **Response:**
  ```json
  { "url": "https://coursera.org/ml", "vetted": "✅" }
  ```

## Deployment
This API is deployed on **Railway**. You can modify the `PORT` and host it on any cloud platform.

## Technologies Used
- **FastAPI** (Web Framework)
- **PostgreSQL** (Database)
- **Google Gemini API** (AI-based Vetting)
- **Uvicorn** (ASGI Server)