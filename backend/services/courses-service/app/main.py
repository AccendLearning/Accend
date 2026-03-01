from fastapi import FastAPI
from app.routers.courses import router as courses_router

app = FastAPI(title="courses-service")

@app.get("/health")
def health():
    return {"ok": True, "service": "courses-service"}

app.include_router(courses_router)