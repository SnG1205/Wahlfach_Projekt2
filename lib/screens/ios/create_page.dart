import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../entities/user.dart';
import '../../utils/database.dart';

class CreatePageIOS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Create User"),
      ),
      child: BodyStateful(),
    );
  }
}

class BodyStateful extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<BodyStateful> {
  final bankDAO = BankingDatabase();
  final database = BankingDatabase().openConnection();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();

  void addClientToDatabase() async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final address = addressController.text;
    final dbFirstName = firstName.replaceAll(' ', '');
    final dbLastName = lastName.replaceAll(' ', '');
    final dbAddress = address.replaceAll(' ', '');

    if (dbFirstName.isEmpty || dbLastName.isEmpty || dbAddress.isEmpty) {
      Fluttertoast.showToast(msg: 'Fields can`t be empty');
    } else {
      bankDAO.insertClient(
          database,
          User.withoutId(
              firstName: firstName,
              lastName: lastName,
              address: address,
              isEmployee: 0));
      int id =
          (await bankDAO.getClientByFullName(database, firstName, lastName))!
              .id!;
      Fluttertoast.showToast(msg: 'Client was created with id: $id');
      firstNameController.clear();
      lastNameController.clear();
      addressController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.fromLTRB(30, 135, 30, 15),
                child: Text(
                    style: TextStyle(fontSize: 20),
                    'Write full name of the client below.')),
            Padding(
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 15),
                child: CupertinoTextField(
                  placeholder: 'First name',
                  controller: firstNameController,
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: CupertinoTextField(
                  placeholder: 'Last name',
                  controller: lastNameController,
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: CupertinoTextField(
                  placeholder: 'Address',
                  controller: addressController,
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: CupertinoButton(
                  onPressed: addClientToDatabase,
                  child: const Text('Create Client', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )),
          ],
        ));
  }
}
