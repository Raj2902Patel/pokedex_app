import 'package:dio/dio.dart';

class HTTPService {
  HTTPService();

  final _dio = Dio();

  Future<Response?> get(String path) async {
    try {
      Response res = await _dio.get(path);
      return res;
    } catch (error) {
      print("Error is ${error.toString()}");
    }
    return null;
  }
}
