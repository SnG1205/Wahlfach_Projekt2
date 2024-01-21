import 'package:flutter/material.dart';
import 'package:wahlfach_projekt/screens/buy_stock_page.dart';
import 'package:wahlfach_projekt/utils/database.dart';
import 'package:wahlfach_projekt/screens/depot_page.dart';
import 'package:wahlfach_projekt/entities/stock.dart';
import 'package:wahlfach_projekt/entities/user.dart';


class UserPage extends StatelessWidget{
  final User user;

  UserPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.firstName}!'), 
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,),
        iconTheme: const IconThemeData(color: Colors.white),
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

  void navigateToBuy(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => BuyStockPage(user)));
  }

  void navigateToDepot() async{
    List<Stock> depotStocks = await bankDAO.getStocksByClientId(bankDAO.openConnection(), user.id!);
    Navigator.push(context, MaterialPageRoute(builder: (context) => DepotPage(user, depotStocks)));
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: Column(
      children: [
        const Padding(
          padding:  EdgeInsets.fromLTRB(0, 50, 0, 15),
          child: Text(
            "Please choose one of the options below.",
            style: TextStyle(
              fontSize: 20,
            )
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 90, 0, 15),
          child: FilledButton(
            onPressed: navigateToBuy,
            style: const ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size(200, 50)),
              backgroundColor: MaterialStatePropertyAll(Colors.deepOrangeAccent)
            ),
            child: const Text('Buy Stock'),
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
          child: FilledButton(
            style: const ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size(200, 50)),
              backgroundColor: MaterialStatePropertyAll(Colors.deepOrangeAccent)
            ),
            onPressed: navigateToDepot,
            child: const Text('Show my Depot'),
          )
        ),
      ],
    ));
  }
}