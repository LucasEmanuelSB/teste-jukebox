import 'dart:convert';

import 'package:app/dio/repository/i_user_repository.dart';
import 'package:app/models/user.dart';
import 'package:dio/dio.dart';
import 'package:app/constants.dart' as constants;

class UserRepository implements IUserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  @override
  Future<List<User>> findAllUsers() async {
    try {
      String url = constants.path + constants.hash + constants.users;
      final response = await _dio.get<List>(url);
      return response.data.map((e) => User.fromMap(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<User> findUser(int id) async {
    try {
      String url = constants.path +
          constants.hash +
          constants.users +
          "/" +
          id.toString();
      final response = await _dio.get(url);
      return response.data.map((e) => User.fromMap(e));
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  addUser(User user) async {
    try {
      String url = constants.path + constants.hash + constants.users;
      final response = await _dio.post<List>(url, data: user.toJson());
      print(response.statusCode);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  updateUser(User user) async {
    try {
      String url = constants.path +
          constants.hash +
          constants.users +
          "/" +
          user.id.toString();
      final response = await _dio.put(url, data: user.toJson());
      print(response.statusCode);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  deleteUser(String id) async {
    try {
      String url = constants.path +
          constants.hash +
          constants.users +
          "/" +
          id.toString();
      final response = await _dio.delete(url);
      return response.data.map((e) => User.fromMap(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
