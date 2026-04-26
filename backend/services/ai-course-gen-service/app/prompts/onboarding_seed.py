"""
onboarding_seed.py

Onboarding seed prompts — hardcoded course-generation instructions per learning goal.

Maps profile learning_goal values (from the mobile app) to concise seed prompts passed to
generate_course_from_prompt. Optional focus_areas tailor emphasis without exposing
raw templates to the client.
"""

from __future__ import annotations

# Keys must match learning_goal.dart backendValue strings.
ONBOARDING_GOAL_PROMPTS: dict[str, str] = {
    "travel": "Travel English for visiting the United States",
    "career": "Professional English for work and career growth",
    "culture": "Social and cultural English for making connections",
    "brain_training": "English pronunciation and speaking practice for mental training",
}

ALLOWED_LEARNING_GOALS = frozenset(ONBOARDING_GOAL_PROMPTS.keys())


def normalize_focus_areas(raw: list[str] | None) -> list[str]:
    """Trim, lowercase, drop empties; preserve order."""
    if not raw:
        return []
    out: list[str] = []
    for s in raw:
        t = (s or "").strip().lower().replace(" ", "_")
        if t:
            out.append(t)
    return out


def build_onboarding_seed_prompt(
    learning_goal: str,
    focus_areas: list[str] | None = None,
) -> str:
    """
    Combine the template for learning_goal with optional focus-area instructions.

    Raises:
        ValueError: if learning_goal is not one of the four known keys.
    """
    key = (learning_goal or "").strip().lower()
    if key not in ONBOARDING_GOAL_PROMPTS:
        raise ValueError(
            f"Invalid learning_goal: {learning_goal!r}. "
            f"Expected one of: {', '.join(sorted(ALLOWED_LEARNING_GOALS))}"
        )

    base = ONBOARDING_GOAL_PROMPTS[key]
    areas = normalize_focus_areas(focus_areas)
    if not areas:
        return base

    pretty = ", ".join(a.replace("_", " ") for a in areas)
    suffix = f" with extra focus on {pretty}"
    return base + suffix