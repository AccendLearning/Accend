// Simple data model for the user's onboarding answers
class OnboardingData {
  String? learningGoal;
  String? feedbackTone;
  String? accent;
  String? dailyPace;
  String? skillAssess;
  String? focusAreas;

  OnboardingData({
    this.learningGoal,
    this.feedbackTone,
    this.accent,
    this.dailyPace,
    this.skillAssess,
    this.focusAreas,
  });

  // Converts this model into the field names expected by the backend API
  Map<String, dynamic> toJson() => {
    'learning_goal': learningGoal,
    'feedback_tone': feedbackTone,
    'accent': accent,
    'daily_pace': dailyPace,
    'skill_assess': skillAssess,
    'focus_areas': focusAreas,
  };
}
