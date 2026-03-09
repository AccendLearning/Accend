class OnboardingUserInfoController {
  String? lobbyCodeErr;

  void validate({
    required String lobbyCode,
  }) {
    final code = lobbyCode.trim();

    lobbyCodeErr = code.isEmpty ? 'Required' : null;

    // Most likely need checks for length of code, as well as making sure it is all numbers
    // for now it is just making sure it isn't empty
    if (code.isEmpty) {
      lobbyCodeErr = 'Required';
    } else {
      lobbyCodeErr = null;
    }
  }

  bool get isValid => lobbyCodeErr == null;
}