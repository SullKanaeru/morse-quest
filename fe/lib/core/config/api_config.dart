class ApiConfig {
  // Development (Local): 'http://10.0.2.2:8080/api'
  // Production (IP VPS): 'http://76.13.17.86:8080/api'
  // Production (Domain): 'https://api.zulhanarif.my.id/api'
  static const String baseUrl = 'http://76.13.17.86:8080/api';

  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String gameWords = '$baseUrl/game/words';
  static const String score = '$baseUrl/game/score';
  static const String profile = '$baseUrl/user/profile';
  static const String buyHint = '$baseUrl/user/buy-hint';
  static const String useHint = '$baseUrl/game/use-hint';
  static const String uploadAvatar = '$baseUrl/user/avatar';
}
