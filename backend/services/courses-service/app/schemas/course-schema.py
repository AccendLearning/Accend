from pydantic import BaseModel, Field
from datetime import datetime
from uuid import UUID


class CourseCreate(BaseModel):
    title: str = Field(min_length=1, max_length=200)


class CourseOut(BaseModel):
    id: UUID
    user_id: UUID
    title: str
    created_at: datetime