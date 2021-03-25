import 'package:app/bloc_user.dart';
import 'package:app/dio/repository/user_repository.dart';
import 'package:app/models/user.dart';
import 'package:app/objects/text_field_custom.dart';
import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:app/constants.dart' as constants;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ScreenRegistration extends StatefulWidget {
  final BlocUser blocUser;
  final BlocListUsers blocListUsers;
  ScreenRegistration({this.blocUser, this.blocListUsers});

  @override
  _ScreenRegistrationState createState() => _ScreenRegistrationState();
}

class _ScreenRegistrationState extends State<ScreenRegistration> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerBirthDate = TextEditingController();
  TextEditingController _controllerHash = TextEditingController();
  DateTime _dateTime;
  int year, month, day;
  bool _validateName = true;
  bool _validateEmail = true;
  bool _validatePassword = true;
  bool _validateBirthDate = true;
  bool _isUpdateUserEnable = false;
  bool _isConfirmUserEnable = true;

  User _verifyData() {
    setState(() {
      _controllerName.text.isNotEmpty
          ? _validateName = true
          : _validateName = false;
      _controllerBirthDate.text.isNotEmpty
          ? _validateBirthDate = true
          : _validateBirthDate = false;
      _controllerEmail.text.isNotEmpty &&
              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(_controllerEmail.text) ==
                  true
          ? _validateEmail = true
          : _validateEmail = false;
      _isUpdateUserEnable == false
          ? _controllerPassword.text.isNotEmpty
              ? _validatePassword = true
              : _validatePassword = false
          : null;
    });
    if (_validateEmail) {
      if (_validateName && _validateBirthDate && _validatePassword) {
        User user = new User();
        user.name = _controllerName.text;
        user.birthdate = _controllerBirthDate.text;
        user.email = _controllerEmail.text;
        var bytes = utf8.encode(_controllerPassword.text); // data being hashed
        var digest = md5.convert(bytes);
        //print("Digest as bytes: ${digest.bytes}");
        //print("Digest as hex string: $digest");
        print("Digest as hex string: ${digest.toString()}");
        user.password = digest.toString();
        return user;
      }
    }

    return null;
  }

  _changeDataButton(String id) {
    Dio dio = new Dio();
    UserRepository userRepository = new UserRepository(dio);
    User user = _verifyData();
    user.id = id;
    userRepository.updateUser(user);
  }

  _confirmButton() {
    Dio dio = new Dio();
    UserRepository userRepository = new UserRepository(dio);
    userRepository.addUser(_verifyData());
    Navigator.pop(
      context,
    );
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerHash.text = constants.hash;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: TextTheme(
        bodyText2: TextStyle(fontSize: 12, color: Colors.white),
      )),
      child: StreamBuilder<User>(
          stream: widget.blocUser.output,
          builder: (context, snpshotUser) {
            if (snpshotUser.hasData) {
              _isUpdateUserEnable = true;
              _isConfirmUserEnable = false;
              _controllerName.text = snpshotUser.data.name;
              _controllerBirthDate.text = snpshotUser.data.birthdate;
              _controllerEmail.text = snpshotUser.data.email;
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.indigo,
                actions: [
                  snpshotUser.data != null
                      ? IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text("Sessão finalizada"),
                                  content: Text(
                                      "Usuário: " + snpshotUser.data.email),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text("Fechar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          })
                      : Container()
                ],
              ),
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
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: Text(
                            "Cadastro",
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
                                  labelText: "Nome Completo",
                                  icon: MdiIcons.account,
                                  color: Colors.indigo,
                                  autoCorrect: false,
                                  autoFocus: true,
                                  keybordType: TextInputType.text,
                                  controller: _controllerName,
                                  validate: _validateName,
                                )),
                            Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: TextFieldCustom(
                                  labelText: "Data de nascimento",
                                  icon: Icons.calendar_today,
                                  color: Colors.indigo,
                                  obscureText: false,
                                  controller: _controllerBirthDate,
                                  validate: _validateBirthDate,
                                  readOnly: true,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: _dateTime == null
                                                ? DateTime.now()
                                                : _dateTime,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2022))
                                        .then((date) {
                                      setState(() {
                                        _dateTime = date;
                                        year = _dateTime.year;
                                        month = _dateTime.month;
                                        day = _dateTime.day;
                                        _controllerBirthDate.text =
                                            day.toString() +
                                                "/" +
                                                month.toString() +
                                                "/" +
                                                year.toString();
                                      });
                                    });
                                  }),
                            ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo,
                                      onPrimary: Colors.white,
                                    ),
                                    child: Text(
                                      "Confirmar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    onPressed: _isConfirmUserEnable == true
                                        ? () => _confirmButton()
                                        : null),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo,
                                      onPrimary: Colors.white,
                                    ),
                                    child: Text(
                                      "Alterar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    onPressed: _isUpdateUserEnable == true
                                        ? () async {
                                            _changeDataButton(
                                                snpshotUser.data.id);
                                            Navigator.pop(
                                              context,
                                            );
                                            Dio dio = new Dio();
                                            UserRepository userRepository =
                                                new UserRepository(dio);
                                            List<User> listUsers =
                                                await userRepository
                                                    .findAllUsers();
                                            widget.blocListUsers
                                                .sendListUser(listUsers);
                                          }
                                        : null)
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
