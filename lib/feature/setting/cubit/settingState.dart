class SettingsState {
  final List<String> userList;
  final bool backgroundMusic;
  final String language;
  final int numberOfQuestions;
  final String currentUser;

  SettingsState({
    required this.userList,
    required this.backgroundMusic,
    required this.language,
    required this.numberOfQuestions,
    required this.currentUser
  });

  SettingsState copyWith({
    List<String>? userList,
    bool? backgroundMusic,
    String? language,
    int? numberOfQuestions,
    String? currentUser
  }) {
    return SettingsState(
      userList: userList ?? this.userList,
      backgroundMusic: backgroundMusic ?? this.backgroundMusic,
      language: language ?? this.language,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      currentUser: currentUser ?? this.currentUser
    );
  }
}
