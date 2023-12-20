import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:movie_mobile/model/user.dart';
import 'package:movie_mobile/model/user_response.dart';

class UserProvider {
  static final dio = Dio(BaseOptions(
    baseUrl: "https://reqres.in",
    receiveTimeout: const Duration(seconds: 60),
  ));

  static Future<UserResponse?> getUser(int page) async {
    try {
      final response = await dio.get('/api/users?page=$page');
      log("getUser: $response");

      UserResponse userResponse = UserResponse.fromJson(response.data);

      return userResponse;
    } catch (e) {
      log("error: $e");

      return null;
    }
  }

  static Future<User?> createUser(
      {String? id, String? name, String? job}) async {
    try {
      final data = {
        "name": name,
        "job": job,
      };

      Response response;

      if (id != null) {
        response = await dio.put('/api/users/$id', data: data);
      } else {
        response = await dio.post('/api/users', data: data);
      }

      log("createUser: $response");

      User user = User.fromJson(response.data);

      return user;
    } catch (e) {
      log("error: $e");

      return null;
    }
  }

  static Future<bool> deleteUser({String? id}) async {
    try {
      final response = await dio.delete('/api/users/$id');

      log("deleteUser: $response");

      return response.statusCode == 200;
    } catch (e) {
      log("error: $e");

      return false;
    }
  }
}
