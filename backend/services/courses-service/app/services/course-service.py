from uuid import UUID
from app.repositories.course_repo import CourseRepo
from app.schemas.course_schema import CourseCreate, CourseOut


class CourseService:
    def __init__(self, repo: CourseRepo):
        self.repo = repo

    def list_courses(self, user_id: UUID) -> list[CourseOut]:
        return self.repo.list_courses(user_id)

    def create_course(self, user_id: UUID, data: CourseCreate) -> CourseOut:
        return self.repo.create_course(user_id, data)