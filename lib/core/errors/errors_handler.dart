import 'package:dio/dio.dart';
import 'package:raise_right_task/core/errors/failure.dart';

class ErrorHandler implements Exception {
  late Failure _failure;

  Failure _handleError(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Failure(
              statusCode, "Connection Timeout reached");
        case DioExceptionType.sendTimeout:
          return Failure(
              statusCode, "Send timeout reached");
        case DioExceptionType.receiveTimeout:
          return Failure(
              statusCode, "Receival timeout reached");
        case DioExceptionType.badResponse:
          switch (statusCode) {
            case 400:
              return Failure(statusCode, "Bad request");
            case 401:
              return Failure(statusCode, "Unauthorized access");
            case 403:
              return Failure(
                  statusCode,  "Forbidden");
            case 404:
              return Failure(statusCode,  "Not found");
            case 409:
              return Failure(statusCode, "Conflict error found");
            case 500:
              return Failure(statusCode, "Internal server found");
          }
        case DioExceptionType.cancel:
          return Failure(statusCode, "Request cancelled");
        case DioExceptionType.badCertificate:
          return Failure(statusCode, "Bad certificate");
        case DioExceptionType.connectionError:
          return Failure(statusCode, "Connection error");
        case DioExceptionType.unknown:
          return Failure(statusCode, "Unknown error");
      }
    }
    return Failure(00, "Come back again!");
  }

  Failure get failure => _failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // api error so its an error from response of the API or from api itself
      _failure = _handleError(error);
    } else {
      // default error
      _failure = Failure(00,  "Come back again!");
    }
  }
}