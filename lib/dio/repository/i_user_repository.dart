import 'package:app/models/user.dart';

abstract class IUserRepository {
  Future<List<User>> findAllUsers();
  Future<User> findUser(int id);
  addUser(User user);
  updateUser(User user);
  deleteUser(String id);
}
