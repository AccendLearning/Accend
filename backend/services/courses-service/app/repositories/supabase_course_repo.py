from uuid import UUID
from app.clients.supabase import get_supabase
from app.schemas.course_schema import CourseCreate, CourseOut


class SupabaseCourseRepo:
    def list_courses(self, user_id: UUID) -> list[CourseOut]:
        sb = get_supabase()
        res = (
            sb.table("courses")
            .select("id,user_id,title,created_at")
            .eq("user_id", str(user_id))
            .order("created_at", desc=True)
            .execute()
        )
        return [CourseOut.model_validate(row) for row in (res.data or [])]

    def create_course(self, user_id: UUID, data: CourseCreate) -> CourseOut:
        sb = get_supabase()
        payload = {"user_id": str(user_id), "title": data.title}
        res = sb.table("courses").insert(payload).select("id,user_id,title,created_at").execute()
        row = (res.data or [None])[0]
        if not row:
            raise RuntimeError("Failed to create course")
        return CourseOut.model_validate(row)