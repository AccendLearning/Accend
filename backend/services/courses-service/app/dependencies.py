from app.repositories.supabase_course_repo import SupabaseCourseRepo
from app.services.course_service import CourseService


def get_course_service() -> CourseService:
    return CourseService(repo=SupabaseCourseRepo())