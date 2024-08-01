import 'package:flutter/cupertino.dart';

import '../../entities/user.dart';
import '../../list_views/ios/user_list.dart';

class DisplayClientsPageIOS extends StatelessWidget{
  final List<User> users;

  DisplayClientsPageIOS(this.users);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("List of clients"),
      ),
      child: BodyStateful(users),
    );
  }
}

class BodyStateful extends StatefulWidget{
  final List<User> users;

  BodyStateful(this.users);

  @override
  _BodyState createState() => _BodyState(users);
}

class _BodyState extends State<BodyStateful> {
  final List<User> users;

  _BodyState(this.users);

  @override
  Widget build(BuildContext context) {
    return UserListIOS(users);
  }
}