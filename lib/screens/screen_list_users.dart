import 'package:app/bloc_user.dart';
import 'package:app/dio/repository/user_repository.dart';
import 'package:app/models/user.dart';
import 'package:app/screens/screen_login.dart';
import 'package:app/screens/screen_registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:app/constants.dart' as constants;

class ScreenListUsers extends StatefulWidget {
  final BlocUser blocUser;
  final BlocListUsers blocListUsers;
  ScreenListUsers({this.blocUser, this.blocListUsers});

  @override
  _ScreenListUsersState createState() => _ScreenListUsersState();
}

class _ScreenListUsersState extends State<ScreenListUsers> {
  TextEditingController _controllerHash = TextEditingController();

  _deleteUser(User user) {
    Dio dio = new Dio();
    UserRepository userRepository = new UserRepository(dio);
    userRepository.deleteUser(user.id);
  }

  Future<List<User>> _listUsers() {
    Dio dio = new Dio();
    UserRepository userRepository = new UserRepository(dio);
    Future<List<User>> listUsers;
    listUsers = userRepository.findAllUsers();
    return listUsers;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerHash.text = constants.hash;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.indigo, accentColor: Colors.indigoAccent),
      home: StreamBuilder<User>(
          stream: widget.blocUser.output,
          builder: (context, snpshotUser) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ScreenLogin())),
                ),
                title: Text(
                  "Lista de usuários",
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("Sessão finalizada"),
                              content:
                                  Text("Usuário: " + snpshotUser.data.email),
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
                        //Navigator.of(this.context).pop();
                      })
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
              body: FutureBuilder<List<User>>(
                future: _listUsers(),
                builder: (context, snpashot) {
                  switch (snpashot.connectionState) {
                    case ConnectionState.none:
                      return Text("None");
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.active:
                      return Text("Active");
                    case ConnectionState.done:
                      if (snpashot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                List<User> listUsers = snpashot.data;
                                User user = listUsers[index];
                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    child: Container(
                                      height: 72,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: ListTile(
                                          dense: true,
                                          leading: Icon(
                                            MdiIcons.accountCircle,
                                            size: 28,
                                            color: Colors.indigo,
                                          ),
                                          title: Text(user.name),
                                          subtitle: Text(user.email +
                                              "\n" +
                                              user.birthdate),
                                          isThreeLine: false,
                                          visualDensity: VisualDensity.compact,
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  widget.blocUser
                                                      .sendUser(user);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ScreenRegistration(
                                                                  blocListUsers:
                                                                      widget
                                                                          .blocListUsers,
                                                                  blocUser: widget
                                                                      .blocUser)));
                                                },
                                              ),
                                              IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    setState(() {
                                                      _deleteUser(user);
                                                    });
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  ),
                              itemCount: snpashot.data.length),
                        );
                      } else {
                        return Center(
                          child: Text("Nenhum dado a ser exibido!"),
                        );
                      }
                      break;
                  }
                },
              ),
            );
          }),
    );
  }
}
