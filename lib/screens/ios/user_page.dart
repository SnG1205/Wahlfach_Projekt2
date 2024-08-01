import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wahlfach_projekt/screens/ios/buy_stock_page.dart';
import 'package:wahlfach_projekt/screens/ios/depot_page.dart';
import 'package:wahlfach_projekt/utils/database.dart';
import 'package:wahlfach_projekt/entities/user.dart';
import 'package:wahlfach_projekt/entities/stock.dart';

class UserPageIOS extends StatelessWidget {
  final User user;

  UserPageIOS(this.user);

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

  void navigateToBuy(){
    Navigator.push(context, CupertinoPageRoute(builder: (context) => BuyStockPageIOS(user)));
  }

  void navigateToDepot() async{
    List<Stock> depotStocks = await bankDAO.getStocksByClientId(bankDAO.openConnection(), user.id!);
    Navigator.push(context, CupertinoPageRoute(builder: (context) => DepotPageIOS(user, depotStocks)));
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
            child: CupertinoButton(
              onPressed: navigateToBuy,
              child: const Text('Buy Stock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
            child: CupertinoButton(
              onPressed: navigateToDepot,
              child: const Text('Show my Depot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            )
        ),
      ],
    ));
  }
}

