import 'package:flutter/cupertino.dart';

import '../../entities/user.dart';

class UserListIOS extends StatelessWidget {
  final List<User> userList;

  UserListIOS(this.userList);

  @override
  Widget build(BuildContext context) {
    return userList.isEmpty ? header() : fullBody(userList);
    return CupertinoFormSection.insetGrouped(
        header: CupertinoFormRow(
            child: Padding(
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Row(
            children: [
              Container(
                //color: Colors.white,
                width: 30,
                height: 30,
                alignment: Alignment.bottomLeft,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    'ID'),
              ),
              Container(
                //color: Colors.white,
                width: 120,
                height: 30,
                alignment: Alignment.bottomCenter,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    'First Name'),
              ),
              Container(
                //color: Colors.white,
                width: 90,
                height: 30,
                alignment: Alignment.bottomCenter,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    'Last Name'),
              ),
              Container(
                //color: Colors.white,
                width: 90,
                height: 30,
                alignment: Alignment.bottomRight,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    'Address'),
              ),
            ],
          ),
        )),
        children: [
          ...List.generate(userList.length,
              (index) => buildCupertinoFormRow(userList[index]))
        ]);
  }

  Widget header(){
    return CupertinoFormRow(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Row(
            children: [
              Container(
                //color: Colors.white,
                width: 30,
                height: 30,
                alignment: Alignment.bottomLeft,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    'ID'),
              ),
              Container(
                //color: Colors.white,
                width: 120,
                height: 30,
                alignment: Alignment.bottomCenter,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    'First Name'),
              ),
              Container(
                //color: Colors.white,
                width: 90,
                height: 30,
                alignment: Alignment.bottomCenter,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    'Last Name'),
              ),
              Container(
                //color: Colors.white,
                width: 90,
                height: 30,
                alignment: Alignment.bottomRight,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    'Address'),
              ),
            ],
          ),
        ));
  }

  Widget fullBody(List<User> users) {
    return CupertinoFormSection.insetGrouped(
        header: header(),
        children: [
          ...List.generate(users.length,
                  (index) => buildCupertinoFormRow(users[index]))
        ]);
  }

  Widget buildCupertinoFormRow(User user) {
    return CupertinoFormRow(
        child: Row(
      children: [
        Container(
          //color: Colors.white,
          width: 30,
          height: 30,
          alignment: Alignment.centerLeft,
          child: Text(
            style: const TextStyle(fontSize: 20),
            user.id.toString(),
          ),
        ),
        Container(
          //color: Colors.white,
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          width: 120,
          height: 30,
          alignment: Alignment.centerLeft,
          child: Text(style: const TextStyle(fontSize: 20), user.firstName),
        ),
        Container(
          //color: Colors.white,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          width: 90,
          height: 30,
          alignment: Alignment.centerLeft,
          child: Text(style: const TextStyle(fontSize: 20), user.lastName),
        ),
        Container(
          //color: Colors.white,
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          width: 110,
          height: 30,
          alignment: Alignment.centerLeft,
          child: Text(style: const TextStyle(fontSize: 17), user.address),
        ),
      ],
    ));
  }
}
