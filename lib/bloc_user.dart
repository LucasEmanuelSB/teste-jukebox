
import 'package:app/models/user.dart';
import 'package:rxdart/rxdart.dart';

class BlocListUsers {
  final BehaviorSubject<List<User>> _controller =
      BehaviorSubject<List<User>>();
  Sink<List<User>> get input => _controller.sink;
  Stream<List<User>> get output => _controller.stream;

  void sendListUser(List<User> listUsers) async {
    input.add(listUsers);
  }
  void dispose() => _controller?.close();
}

class BlocUser {
  final BehaviorSubject<User> _controller =
      BehaviorSubject<User>();
  Sink<User> get input => _controller.sink;
  Stream<User> get output => _controller.stream;

  void sendUser(User user) async {
    input.add(user);
  }
  void dispose() => _controller?.close();
}

