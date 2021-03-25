
import 'package:app/dio/repository/i_user_repository.dart';
import 'package:get/get.dart';

class DioController extends GetxController with StateMixin { 

  final IUserRepository _dioRepository;

  DioController(this._dioRepository);

  @override
  void onInit() {
    super.onInit();
    findUsers();
  }

  Future<void> findUsers() async {
    change([], status: RxStatus.loading());
    try {
      final data = await _dioRepository.findAllUsers();
      change(data, status: RxStatus.success());
    } catch (e) {
      print(e);
      change([], status: RxStatus.error('Erro ao buscar usuários'));
    }
  }

}