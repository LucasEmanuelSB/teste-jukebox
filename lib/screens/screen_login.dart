import 'dart:convert';

import 'package:app/bloc_user.dart';
import 'package:app/dio/repository/user_repository.dart';
import 'package:app/models/user.dart';
import 'package:app/objects/text_field_custom.dart';
import 'package:app/screens/screen_list_users.dart';
import 'package:app/screens/screen_registration.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:app/constants.dart' as constants;

class ScreenLogin extends StatefulWidget {
  ScreenLogin({Key key}) : super(key: key);
  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  bool _validateEmail = true;
  bool _validatePassword = true;

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerHash = TextEditingController();

  User user = new User();
  BlocUser blocUser = new BlocUser();
  BlocListUsers blocListUsers = new BlocListUsers();

  _loginButton() async {
    setState(() {
      _controllerEmail.text.isNotEmpty &&
              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(_controllerEmail.text) ==
                  true
          ? _validateEmail = true
          : _validateEmail = false;
      _controllerPassword.text.isNotEmpty
          ? _validatePassword = true
          : _validatePassword = false;
    });

    if (_validateEmail && _validatePassword) {
      Dio dio = new Dio();
      UserRepository userRepository = new UserRepository(dio);
      List<User> listUsers = await userRepository.findAllUsers();
      blocListUsers.sendListUser(listUsers);
      user = listUsers
          .firstWhere((element) => element.email == _controllerEmail.text);

      if (user != null) {
        var bytes = utf8.encode(_controllerPassword.text); // data being hashed
        var digest = md5.convert(bytes);
        if (digest.toString() == user.password) {
          blocUser.sendUser(user);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScreenListUsers(
                        blocUser: blocUser,
                        blocListUsers: blocListUsers,
                      )));
        } else {
          print("Senha incorreta");
        }
      } else {
        print("Usuário nulo");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerHash.text = constants.hash;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    blocListUsers.dispose();
    blocUser.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: TextTheme(
        bodyText2: TextStyle(fontSize: 13.5, color: Colors.black54),
      )),
      child: Scaffold(
        //appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: Icon(MdiIcons.codeBrackets),
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Trocar Hash"),
                content: new TextField(
                  controller: _controllerHash,
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Confirmar"),
                    onPressed: () {
                      constants.hash = _controllerHash.text;
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.bold,
                          fontSize: 58,
                          height: 1,
                          color: Colors.indigo),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: TextFieldCustom(
                          labelText: "E-mail",
                          icon: MdiIcons.email,
                          color: Colors.indigo,
                          autoCorrect: true,
                          autoFocus: false,
                          keybordType: TextInputType.emailAddress,
                          controller: _controllerEmail,
                          validate: _validateEmail,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: TextFieldCustom(
                          labelText: "Senha",
                          icon: MdiIcons.lock,
                          color: Colors.indigo,
                          obscureText: true,
                          controller: _controllerPassword,
                          validate: _validatePassword,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                          onPrimary: Colors.white,
                        ),
                        child: Text(
                          "Efetuar login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        onPressed: () => _loginButton(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                          onPrimary: Colors.white,
                        ),
                        child: Text(
                          "Mudar senha",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("Mudar senha"),
                              content: Container(
                                width: 140,
                                height: 120,
                                child: Column(
                                  children: [
                                    new TextField(
                                      decoration: InputDecoration(
                                          hintText: "Informe o email"),
                                      controller: _controllerEmail,
                                    ),
                                    new TextField(
                                      decoration: InputDecoration(
                                          hintText: "Digite a senha nova"),
                                      controller: _controllerPassword,
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("Confirmar"),
                                  onPressed: () async {
                                    Dio dio = new Dio();
                                    UserRepository userRepository =
                                        new UserRepository(dio);
                                    List<User> listUsers =
                                        await userRepository.findAllUsers();
                                    user = listUsers.firstWhere((element) =>
                                        element.email == _controllerEmail.text);
                                    if (user != null) {
                                      var bytes = utf8.encode(
                                          _controllerPassword
                                              .text); // data being hashed
                                      var digest = md5.convert(bytes);
                                      if (digest.toString() == user.password) {
                                        Dio dio = new Dio();
                                        UserRepository userRepository =
                                            new UserRepository(dio);
                                        userRepository.updateUser(user);
                                      }
                                    }

                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("Cancelar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                          onPrimary: Colors.white,
                        ),
                        child: Text(
                          "Cadastrar usuário",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ScreenRegistration(blocUser: blocUser,blocListUsers: blocListUsers,))),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                          onPrimary: Colors.white,
                        ),
                        child: Text(
                          "Listar usuários",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenListUsers(
                                      blocUser: blocUser,
                                      blocListUsers: blocListUsers,
                                    ))),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
