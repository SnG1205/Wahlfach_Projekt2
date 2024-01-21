import 'package:flutter/material.dart';
import 'package:wahlfach_projekt/entities/user.dart';

class UserList extends StatelessWidget{
  final List<User> userList;

  UserList(this.userList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    itemCount: userList.length+1,
    itemBuilder: (context, index){
      if(index == 0){
        return ListTile(
          title: Row(
            children: [
              Container(
                color: Colors.white,
                width: 30,
                height: 30,
                alignment: Alignment.bottomCenter,
                child: const Text(
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  'ID'
                  ),
              ),
              Container(
                color: Colors.white,
                width: 120,
                height: 30,
                alignment: Alignment.bottomLeft,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    'First Name'
                  ),
              ),
              Container(
                color: Colors.white,
                width: 90,
                height: 30,
                alignment: Alignment.bottomLeft,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    'Last Name'
                  ),
              ),
              Container(
                color: Colors.white,
                width: 90,
                height: 30,
                alignment: Alignment.bottomLeft,
                child: const Text(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    'Address'
                  ),
              ),
            ],
          ),
        );
      }
      else{
        var user = userList[index-1];
        return ListTile(
          title: Row(
            children: [
              Container(
                color: Colors.white,
                width: 30,
                height: 30,
                alignment: Alignment.center,
                child: Text(
                    style: const TextStyle(fontSize: 20),
                    user.id.toString(),
                  ),
              ),
              Container(
                color: Colors.white,
                width: 120,
                height: 30,
                alignment: Alignment.centerLeft,
                child: Text(
                    style: const TextStyle(fontSize: 20),
                    user.firstName
                  ),
              ),
              Container(
                color: Colors.white,
                width: 90,
                height: 30,
                alignment: Alignment.centerLeft,
                child: Text(
                    style: const TextStyle(fontSize: 20),
                    user.lastName
                  ),
              ),
              Container(
                color: Colors.white,
                width: 110,
                height: 30,
                alignment: Alignment.centerLeft,
                child: Text(
                    style: const TextStyle(fontSize: 20),
                    user.address
                  ),
              ),
            ],
          ),
        );
      }
    });
  }
}