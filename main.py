from fastapi import FastAPI, HTTPException
import psycopg2
import os
from dotenv import load_dotenv
import uvicorn
from pydantic import BaseModel
from google.generativeai import configure, GenerativeModel

load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL")
configure(api_key=os.getenv("GEMINI_API_KEY"))
gemini_model = GenerativeModel("gemini-1.5-pro")

app = FastAPI()


conn = psycopg2.connect(DATABASE_URL)
cur = conn.cursor()

@app.get("/")
def home():
    return {"message": "Hello from Railway!"}

@app.get("/api/roadmap")
def get_roadmap(role: str):
    cur.execute("SELECT id FROM roles WHERE name = %s", (role,))
    role_id = cur.fetchone()
    if not role_id:
        return {"error": "Role not found"}
    
    role_id = role_id[0]

    cur.execute("SELECT name FROM skills WHERE role_id = %s", (role_id,))
    skills = [row[0] for row in cur.fetchall()]

    cur.execute("""
        SELECT s.name AS skill, r.title, r.url, r.type, r.vetted
        FROM skills s
        JOIN resources r ON s.id = r.skill_id
        WHERE s.role_id = %s
    """, (role_id,))
    
    resources = [
        {"skill": skill, "title": title, "url": url, "type": type_, "vetted": vetted}
        for skill, title, url, type_, vetted in cur.fetchall()
    ]

    return {
        "role": role,
        "skills": skills,
        "resources": resources
    }

class VettingRequest(BaseModel):
    url: str

@app.post("/api/vet")
def vet_resource(request: VettingRequest):
    prompt = f"Is {request.url} a reliable learning resource? Check if it's from Coursera, edX, MIT, etc. Answer only with 'yes' or 'no'."
    
    try:
        response = gemini_model.generate_content(prompt)
        result = response.text.strip().lower()
        vetted = "✅" if result and "yes" in result else "❌"

        return {"url": request.url, "vetted": vetted}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    uvicorn.run(app, host="0.0.0.0", port=port)