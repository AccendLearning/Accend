from pydantic import BaseModel, Field


class UsernameAvailableResponse(BaseModel):
    available: bool


class ProfileInitRequest(BaseModel):
    username: str = Field(min_length=3)
    full_name: str | None = None
    native_language: str | None = None


class ProfileInitResponse(BaseModel):
    ok: bool


class ProfileOnboardingUpdate(BaseModel):
    learning_goal: str | None = None
    feedback_tone: str | None = None
    accent: str | None = None
    daily_pace: str | None = None
    skill_assess: str | None = None
    mark_complete: bool = False