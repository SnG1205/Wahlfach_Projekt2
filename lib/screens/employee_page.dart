import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wahlfach_projekt/screens/buy_stock_page.dart';
import 'package:wahlfach_projekt/screens/create_user_page.dart';
import 'package:wahlfach_projekt/utils/database.dart';
import 'package:wahlfach_projekt/screens/depot_page.dart';
import 'package:wahlfach_projekt/screens/display_clients_page.dart';
import 'package:wahlfach_projekt/entities/stock.dart';
import 'package:wahlfach_projekt/entities/user.dart';

class EmployeePage extends StatelessWidget{
  final User user;

  EmployeePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.firstName}!'), 
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.amberAccent,),
        iconTheme: const IconThemeData(color: Colors.amberAccent),
      ), 
      body: BodyStateful(user)
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => BuyStockPage(client)));
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => DepotPage(client, depotStocks)));
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePage()));
    clear();
  }

  void navigateToDisplayClients() async{
    List<User> clientList = await bankDAO.getAllClients(database);
    Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayClientsPage(clientList)));
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
          padding: const EdgeInsets.fromLTRB(70, 15, 70, 15),
          child: TextField(
            controller: clientIdController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter id of the client',
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: FilledButton.tonal(
            onPressed: navigateToBuy,
            style: const ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size(200, 50)),
            ),
            child: const Text('Buy Stock'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: FilledButton.tonal(
            onPressed: getBankBalance,
            style: const ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size(200, 50)),
            ),
            child: const Text('Get Balance'),
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: FilledButton.tonal(
            onPressed: navigateToCreateClient,
            style: const ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size(200, 50)),
            ),
            child: const Text('Create User'),
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: FilledButton.tonal(
            onPressed: navigateToDisplayClients,
            style: ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.purple[300]),
              minimumSize: const MaterialStatePropertyAll(Size(200, 50)),
            ),
            child: const Text('Display clients'),
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: FilledButton.tonal(
            onPressed: navigateToDepot,
            style: const ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size(200, 50)),
            ),
            child: const Text('Show Depot'),
          )
        ),
      ],
    ));
  }
}
