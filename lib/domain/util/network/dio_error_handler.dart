import 'package:dio/dio.dart';


String handleDioError(DioError error) {
  String errorDescription = "";

  switch (error.type) {
    case DioErrorType.cancel:
      errorDescription = "Request to API server was cancelled";
      break;
    case DioErrorType.connectTimeout:
      errorDescription = "Connection timeout with API server";
      break;
    case DioErrorType.other:
      errorDescription = "Internet Connection Problem.";
      break;
    case DioErrorType.receiveTimeout:
      errorDescription = "Receive timeout in connection with API server";
      break;
    case DioErrorType.response:
      {
        errorDescription = "Received invalid status code: ${error.response?.statusCode}";
        break;
      }

    case DioErrorType.sendTimeout:
      errorDescription = "Send timeout in connection with API server";
      break;
  }

  return errorDescription;
}
