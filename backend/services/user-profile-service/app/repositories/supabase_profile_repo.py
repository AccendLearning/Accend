import httpx
from app.clients.supabase import supabase
from app.repositories.profile_repo import ProfileRepo
from app.utils.errors import conflict


class SupabaseProfileRepo(ProfileRepo):

    async def username_exists(self, username: str) -> bool:
        params = {
            "select": "id",
            "username": f"eq.{username}",
            "limit": "1",
        }

        rows = await supabase.get("profiles", params=params)
        return len(rows) > 0

    async def init_profile(
        self,
        user_id: str,
        username: str,
        full_name: str | None,
        native_language: str | None,
    ) -> None:

        if await self.username_exists(username):
            conflict("Username already taken")

        payload = {
            "id": user_id,
            "username": username,
            "onboarding_complete": False,
        }

        if full_name is not None:
            payload["full_name"] = full_name

        if native_language is not None:
            payload["native_language"] = native_language

        await supabase.post("profiles", json=payload)

    async def update_onboarding(
        self,
        user_id: str,
        learning_goal: str | None = None,
        feedback_tone: str | None = None,
        accent: str | None = None,
        daily_pace: str | None = None,
        skill_assess: str | None = None,
        mark_complete: bool = False,
    ) -> None:
        payload: dict[str, object] = {}

        if learning_goal is not None:
            payload["learning_goal"] = learning_goal
        if feedback_tone is not None:
            payload["feedback_tone"] = feedback_tone
        if accent is not None:
            payload["accent"] = accent
        if daily_pace is not None:
            payload["daily_pace"] = daily_pace
        if skill_assess is not None:
            payload["skill_assess"] = skill_assess
        if mark_complete:
            payload["onboarding_complete"] = True

        if not payload:
            return

        await supabase.patch(
            "profiles",
            json=payload,
            params={"id": f"eq.{user_id}"},
        )