# Accend Backend

Microservices and local orchestration for Accend. All services are written in **Python (FastAPI)** and run together via Docker Compose.

## Architecture

```
Flutter App
  → API Gateway  (JWT verification, request orchestration)
  → Internal Services  (domain logic)
  → Supabase  (PostgreSQL + auth)
```

The mobile app calls only `api-gateway`. All other services are internal and not exposed to clients.

## Services

| Service | Responsibility |
|---------|---------------|
| `api-gateway` | Public BFF entrypoint. JWT validation, request orchestration. |
| `user-profile-service` | Profile and onboarding data. |
| `courses-service` | Course and lesson CRUD, curriculum persistence. |
| `ai-course-gen-service` | AI-generated courses and session items. |
| `pronunciation-feedback` | Azure-based pronunciation scoring + Gemini AI coaching tips. |
| `progress-service` | Daily goals, streaks, minutes practiced, phoneme accuracy history. |
| `follow-service` | Social graph: follow/unfollow, block, reputation votes. |
| `group-service` | Private/public lobby lifecycle, turn state, voice token brokering. |

## Request and Auth Flow

1. Client sends `Authorization: Bearer <JWT>` to the gateway.
2. Gateway verifies JWT against Supabase JWKS.
3. Gateway attaches `X-User-Id` header and forwards to the target internal service.
4. Internal services trust `X-User-Id` — they do not re-verify JWTs.

## Data Ownership

Each service owns its domain tables. Even though services share a Supabase project, only the owning service writes to its tables. Cross-domain reads go through service APIs, not direct table access.

## Feature Flows

### Onboarding and Profile
Gateway routes profile initialization and onboarding patches to `user-profile-service`. Downstream services consume normalized profile fields (daily pace, goals, accent preference) from their own copies or via profile API calls.

### Course Generation
Three supported generation paths, all orchestrated by the gateway:
- **Custom prompt**: user-supplied topic or scenario.
- **Onboarding seed**: triggered on onboarding completion, based on selected goal.
- **Weak-phoneme**: generated from the user's phoneme accuracy history in `progress-service`.

`ai-course-gen-service` handles generation; `courses-service` owns persistence.

### Solo Pronunciation Pipeline
1. Gateway proxies WAV audio + reference text to `pronunciation-feedback`.
2. Service returns summary accuracy + word-level and phoneme-level breakdown.
3. Gateway exposes a separate AI feedback call (Gemini) that takes scoring results and returns coaching tips.
4. Progress updates (phoneme batch merge, daily minutes, streak) flow through `progress-service`.

### Group Session Pipeline
`group-service` owns lobby lifecycle (private/public), session item sets, and turn state. Gateway exposes turn scoring and vote actions. Voice token issuance is brokered via gateway to keep auth consistent. End-of-session cleanup cascades through dedicated endpoints.

### Social and Account Safety
`follow-service` handles follow/unfollow, block/unblock, blocked ID lists, and reputation votes. Gateway fans out account deletion to all services before deleting the Supabase auth record.

---

## Local Development

### 1. Configure environment

```bash
cd backend
cp .env.example .env
```

Fill `.env` with your secrets. Required variables:

```
# Supabase
SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=
SUPABASE_JWKS_URL=
SUPABASE_JWT_ISSUER=

# Speech and AI
AZURE_SPEECH_KEY=
AZURE_SPEECH_REGION=
GEMINI_API_KEY=

# Local dev only
ALLOW_ANON_PRONUNCIATION_ASSESS=true   # skips auth on pronunciation endpoint for testing
```

Never commit `.env`.

### 2. Start the stack

```bash
docker compose up --build
```

- Gateway: `http://localhost:8080`
- Individual services (for debugging): ports `8081`–`8087`

### 3. Smoke test

```bash
curl http://localhost:8080/health
```

### 4. Minimal end-to-end sanity check

1. Confirm gateway health.
2. Call one profile or course endpoint with a valid JWT.
3. Run pronunciation assess call with short WAV audio.
4. Verify logs for gateway -> downstream service handoff.

---

## Pronunciation Endpoint Reference

Use the gateway endpoint, not the internal service directly.

**Assess pronunciation:**

```bash
curl -X POST "http://localhost:8080/pronunciation/assess" \
  -F "audio=@path/to/audio.wav" \
  -F "reference_text=Hello world"
```

- Audio must be WAV, ≤ 10 seconds.
- Auth is enforced unless `ALLOW_ANON_PRONUNCIATION_ASSESS=true` is set for local testing.
- Response includes summary, word-level scores, phoneme-level scores, and a `feedback_session_id`.

**Request AI coaching tips:**

```bash
curl -X POST "http://localhost:8080/pronunciation/ai-feedback" \
  -H "Content-Type: application/json" \
  -d '{
    "feedback_session_id": "<id from assess response>",
    "summary": {"accuracy": 78, "fluency": 70, "completeness": 84, "pronScore": 77},
    "words": []
  }'
```

---

## Implementation Pattern

All services follow the same internal layering:

```
routers → services → repositories → clients
```

- `routers`: HTTP boundary, request/response mapping.
- `services`: domain and business logic.
- `repositories`: persistence (Supabase tables).
- `clients`: external systems (Azure, Gemini, other internal services).

## Backend Layout

```text
backend/
├── docker-compose.yml
├── .env.example
└── services/
    ├── api-gateway/
    ├── ai-course-gen-service/
    ├── courses-service/
    ├── follow-service/
    ├── group-service/
    ├── progress-service/
    ├── pronunciation-feedback/
    └── user-profile-service/
```
