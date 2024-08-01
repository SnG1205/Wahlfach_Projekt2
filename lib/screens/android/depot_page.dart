import 'package:flutter/material.dart';
import 'package:wahlfach_projekt/utils/database.dart';
import 'package:wahlfach_projekt/entities/stock.dart';
import 'package:wahlfach_projekt/list_views/android/stock_list.dart';
import 'package:wahlfach_projekt/entities/user.dart';

class DepotPage extends StatelessWidget{
  final User user;
  final List<Stock> stocks;

  DepotPage(this.user, this.stocks);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text('${user.firstName}`s shares'), 
      backgroundColor: Colors.blue,
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,),
      iconTheme: const IconThemeData(color: Colors.white),
    ), 
    body: BodyStateful(user, stocks)
  );
  }

}

class BodyStateful extends StatefulWidget{
  final User user;
  final List<Stock> stocks;
  //final Map<String, dynamic> stock;

  BodyStateful(this.user, this.stocks);

  @override
  _BodyState createState() => _BodyState(user, stocks);
}

class _BodyState extends State<BodyStateful>{
  final User user;
  final List<Stock> stocks;
  //final Map<String, dynamic> stock;
  _BodyState(this.user, this.stocks);

  final bankDAO = BankingDatabase();

  double calculateDepot(){
    double sum = 0;
    stocks.forEach((stock) {
      sum = sum + stock.price * stock.amount.toDouble();
     });
     return sum;
  }

  @override
  Widget build(BuildContext context) {
    return StockList(stocks, user);
  }
}