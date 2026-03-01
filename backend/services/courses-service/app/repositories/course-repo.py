from typing import Protocol
from uuid import UUID
from app.schemas.course_schema import CourseCreate, CourseOut


class CourseRepo(Protocol):
    def list_courses(self, user_id: UUID) -> list[CourseOut]: ...
    def create_course(self, user_id: UUID, data: CourseCreate) -> CourseOut: ...