import httpx
from app.config import settings


class SupabaseClient:
    def __init__(self) -> None:
        self.base_url = settings.SUPABASE_URL.rstrip("/") + "/rest/v1"
        self.headers = {
            "apikey": settings.SUPABASE_SERVICE_ROLE_KEY,
            "Authorization": f"Bearer {settings.SUPABASE_SERVICE_ROLE_KEY}",
            "Content-Type": "application/json",
        }

    async def get(self, table: str, params: dict) -> list[dict]:
        url = f"{self.base_url}/{table}"

        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.get(url, headers=self.headers, params=params)

        if resp.status_code >= 400:
            raise httpx.HTTPStatusError(
                f"Supabase GET error {resp.status_code}",
                request=resp.request,
                response=resp,
            )

        return resp.json()

    async def post(self, table: str, json: dict) -> None:
        url = f"{self.base_url}/{table}"

        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.post(url, headers=self.headers, json=json)

        if resp.status_code >= 400:
            raise httpx.HTTPStatusError(
                f"Supabase POST error {resp.status_code}",
                request=resp.request,
                response=resp,
            )

    async def patch(self, table: str, json: dict, params: dict) -> None:
        """
        Minimal helper for partial updates via Supabase REST (PostgREST).
        Example:
          await supabase.patch(
              "profiles",
              json={"learning_goal": "fluency"},
              params={"id": "eq.<user_id>"},
          )
        """
        url = f"{self.base_url}/{table}"

        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.patch(
                url,
                headers=self.headers,
                params=params,
                json=json,
            )

        if resp.status_code >= 400:
            raise httpx.HTTPStatusError(
                f"Supabase PATCH error {resp.status_code}",
                request=resp.request,
                response=resp,
            )


supabase = SupabaseClient()