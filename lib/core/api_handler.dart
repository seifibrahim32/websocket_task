import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'errors/errors_handler.dart';
import 'errors/failure.dart';

class ApiHandler {
  static Future<Either<Failure, T>> apiCaller<T>(
      Future<T> Function() apiCall,
      ) async {
    for (int retryCount = 1; retryCount <= 120; retryCount++) {
      try {
        return Right(await apiCall());
      } catch (error) {
        if (retryCount == 120) {
          debugPrint("Error occurred: ${error.toString()}");
          return Left(ErrorHandler.handle(error).failure);
        } else {
          // Log or handle the error if needed before retrying
          debugPrint('Error occurred ${error.toString()}, retrying... Retry count: $retryCount');
        }
      }
    }
    throw Exception("Unexpected control flow reached end of function");
  }
}
