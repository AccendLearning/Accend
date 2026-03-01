from fastapi import APIRouter, Depends, Header, HTTPException
from uuid import UUID

from app.dependencies import get_course_service
from app.schemas.course_schema import CourseCreate, CourseOut
from app.services.course_service import CourseService

router = APIRouter(prefix="/courses", tags=["courses"])


def _get_user_id(x_user_id: str | None) -> UUID:
    if not x_user_id:
        raise HTTPException(status_code=401, detail="Missing X-User-Id")
    try:
        return UUID(x_user_id)
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid X-User-Id")


@router.get("", response_model=list[CourseOut])
def list_courses(
    x_user_id: str | None = Header(default=None, alias="X-User-Id"),
    svc: CourseService = Depends(get_course_service),
):
    user_id = _get_user_id(x_user_id)
    return svc.list_courses(user_id)


@router.post("", response_model=CourseOut)
def create_course(
    body: CourseCreate,
    x_user_id: str | None = Header(default=None, alias="X-User-Id"),
    svc: CourseService = Depends(get_course_service),
):
    user_id = _get_user_id(x_user_id)
    return svc.create_course(user_id, body)