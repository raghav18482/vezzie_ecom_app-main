// ignore_for_file: prefer_typing_uninitialized_variables

class AppExceptions implements Exception {
  final _messgae;
  final _prefix;

  AppExceptions([this._messgae, this._prefix]);

  @override
  String toString() {
    return '$_prefix$_messgae';
  } 
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
      : super(message, "Error During communication");
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? message]) : super(message, "Invalid request");
}

class UnauthorizedExceptions extends AppExceptions {
  UnauthorizedExceptions([String? message])
      : super(message, "Unauthorized request");
}

class InvalidInputException extends AppExceptions {
  InvalidInputException([String? message])
      : super(message, "Invalid Input request");
}
