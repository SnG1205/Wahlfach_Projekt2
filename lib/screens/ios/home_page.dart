import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wahlfach_projekt/screens/android/employee_page.dart';
import 'package:wahlfach_projekt/screens/android/user_page.dart';
import 'package:wahlfach_projekt/utils/database.dart';
import 'package:wahlfach_projekt/entities/user.dart';

class HomePageIOS extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: HomePageBody(),
    );
  }
}

class HomePageBody extends StatefulWidget{
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<HomePageBody>{
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final bankDAO = BankingDatabase();

  void navigate() async{
    final database = bankDAO.openConnection();
    try{
      User? user = await bankDAO.getClientByFullName(database, usernameController.text, passwordController.text);
      if(user!.isEmployee == 1){
        Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeePage(user)));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage(user)));
      }
      usernameController.clear();
      passwordController.clear();
    }
    catch(e){
      Fluttertoast.showToast(msg: "No user found with given credentials.");
      usernameController.clear();
      passwordController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    'Please enter Your credentials to login into Your account.'
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                child: CupertinoTextField(
                  controller: usernameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: CupertinoTextField(
                  controller: passwordController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                child: CupertinoButton(
                  onPressed: navigate,
                  child: const Text('Login', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 20)),
                )
              )
            ],)),
    );
  }

}