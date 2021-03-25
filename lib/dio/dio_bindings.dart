
import 'package:app/dio/dio_controller.dart';
import 'package:app/dio/repository/i_user_repository.dart';
import 'package:app/dio/repository/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class DioBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(Dio());
    Get.put<IUserRepository>(UserRepository(Get.find()));
    Get.put(DioController(Get.find()));
  }
}