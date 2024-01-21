import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wahlfach_projekt/utils/database.dart';
import 'package:wahlfach_projekt/entities/user.dart';

class CreatePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client creation'), 
        backgroundColor: Colors.blue, 
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,),
        iconTheme: const IconThemeData(color: Colors.white),
      ), 
      body: BodyStateful(),
    );
  }
}

class BodyStateful extends StatefulWidget{

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<BodyStateful>{

  final bankDAO = BankingDatabase();
  final database = BankingDatabase().openConnection();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();

  void addClientToDatabase() async{
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final address = addressController.text;
    final dbFirstName = firstName.replaceAll(' ', '');
    final dbLastName = lastName.replaceAll(' ', '');
    final dbAddress = address.replaceAll(' ', '');

    if(dbFirstName.isEmpty || dbLastName.isEmpty || dbAddress.isEmpty){
      Fluttertoast.showToast(msg: 'Fields can`t be empty');
    }
    else{
      bankDAO.insertClient(
      database, 
      User.withoutId(
        firstName: firstName, 
        lastName: lastName,
        address: address, 
        isEmployee: 0)
    );
    int id = (await bankDAO.getClientByFullName(database, firstName, lastName))!.id!;
    Fluttertoast.showToast(msg: 'Client was created with id: $id');
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: Text(
            style: TextStyle(fontSize: 20),
            'Write full name of the client below.'
          )        
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: TextField(
            controller: firstNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter first name of the client',
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: TextField(
            controller: lastNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter last name of the client',
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: TextField(
            controller: addressController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter address of the client',
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: FilledButton(
            onPressed: addClientToDatabase,
            style: const ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size(200, 50)),
              backgroundColor: MaterialStatePropertyAll(Colors.deepOrangeAccent),
            ),
            child: const Text('Create Client')
            )
        ),
      ],
    ));
  }
}