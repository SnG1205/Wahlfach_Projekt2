import 'package:flutter/material.dart';
import 'package:wahlfach_projekt/utils/database.dart';
import 'package:wahlfach_projekt/entities/user.dart';
import 'package:wahlfach_projekt/list_views/android/user_list.dart';

class DisplayClientsPage extends StatelessWidget{
  final List<User> users;

  DisplayClientsPage(this.users);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of clients'), 
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,),
        iconTheme: const IconThemeData(color: Colors.white),
      ), 
      body: BodyStateful(users)
    );
  }

}

class BodyStateful extends StatefulWidget{
  final List<User> users;

  BodyStateful(this.users);

  @override
  _BodyState createState() => _BodyState(users);
}

class _BodyState extends State<BodyStateful>{
  final List<User> users;

  _BodyState(this.users);

  @override
  Widget build(BuildContext context) {
    return UserList(users);
  }
}