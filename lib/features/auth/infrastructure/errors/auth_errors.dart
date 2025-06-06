class ConnectionTimeout implements Exception {}

class InvalidToken implements Exception {}

class WrongCredentials implements Exception {}

class CustomError implements Exception {
  final String message;
  final int errorCode;
  final bool loggedRequired;

  CustomError(this.message, this.errorCode, [this.loggedRequired = false]);
}
