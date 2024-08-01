import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wahlfach_projekt/screens/android/employee_page.dart';
import 'package:wahlfach_projekt/screens/android/user_page.dart';
import 'package:wahlfach_projekt/utils/database.dart';
import 'package:wahlfach_projekt/entities/user.dart';

import '../../entities/stock.dart';
import 'buy_stock_page.dart';
import 'create_page.dart';
import 'depot_page.dart';
import 'display_clients_page.dart';

class EmployeePageIOS extends StatelessWidget{
  final User user;

  EmployeePageIOS(this.user);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Welcome, ${user.firstName}"),
      ),
      child: BodyStateful(user),
    );
  }
}

class BodyStateful extends StatefulWidget{
  final User user;

  BodyStateful(this.user);

  @override
  _BodyState createState() => _BodyState(user);
}

class _BodyState extends State<BodyStateful>{
  final User user;

  _BodyState(this.user);

  final bankDAO = BankingDatabase();
  final database = BankingDatabase().openConnection();
  final clientIdController = TextEditingController();

  void clear(){
    FocusScope.of(context).unfocus();
    clientIdController.clear();
  }

  void navigateToBuy() async{
    try{
      int clientId = int.parse(clientIdController.text);
      User? client = await bankDAO.getClientById(database, clientId);
      if(client == null){
        Fluttertoast.showToast(msg: 'No user was found with such id');
        clientIdController.clear();
      }
      else{
        if(client.isEmployee == 1){
          Fluttertoast.showToast(msg: 'Given user is an employee.');
          clientIdController.clear();
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => BuyStockPageIOS(client)));
          clear();
        }
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: 'Please enter an id of user.');
      clientIdController.clear();
    }
  }

  void navigateToDepot() async{
    try{
      int clientId = int.parse(clientIdController.text);
      User? client = await bankDAO.getClientById(database, clientId);
      if(client == null){
        Fluttertoast.showToast(msg: 'No user was found with such id');
        clientIdController.clear();
      }
      else{
        if(client.isEmployee == 1){
          Fluttertoast.showToast(msg: 'Given user is an employee.');
          clientIdController.clear();
        }
        else{
          List<Stock> depotStocks = await bankDAO.getStocksByClientId(bankDAO.openConnection(), client.id!);
          Navigator.push(context, CupertinoPageRoute(builder: (context) => DepotPageIOS(client, depotStocks)));
          clear();
        }
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: 'Please enter an id of user.');
      clientIdController.clear();
    }
  }

  void navigateToCreateClient(){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => CreatePageIOS()));
    clear();
  }

  void navigateToDisplayClients() async{
    List<User> clientList = await bankDAO.getAllClients(database);
    Navigator.push(context, CupertinoPageRoute(builder: (context) => DisplayClientsPageIOS(clientList)));
    clear();
  }

  void getBankBalance() async{
    double bankBalance = (await bankDAO.getBalance(database))[0].balance;
    Fluttertoast.showToast(msg: 'Current balance is ${bankBalance.toStringAsFixed(2)}');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(70, 160, 70, 15),
            child: CupertinoTextField(
              controller: clientIdController,
            )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: CupertinoButton(
            onPressed: navigateToBuy,
            child: const Text('Buy Stock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          )
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: CupertinoButton(
              onPressed: getBankBalance,
              child: const Text('Get Balance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: CupertinoButton(
              onPressed: navigateToCreateClient,
              child: const Text('Create Client', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: CupertinoButton(
              onPressed: navigateToDisplayClients,
              child: const Text('Display Clients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: CupertinoButton(
              onPressed: navigateToDepot,
              child: const Text('Show Depot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )
        ),
      ],
    ));
  }
}
