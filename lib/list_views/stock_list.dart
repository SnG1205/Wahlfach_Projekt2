import 'package:flutter/material.dart';
import 'package:wahlfach_projekt/screens/sell_stock_page.dart';
import 'package:wahlfach_projekt/entities/stock.dart';
import 'package:wahlfach_projekt/entities/user.dart';

class StockList extends StatelessWidget{
  final List<Stock> stockList;
  final User user;

  StockList(this.stockList, this.user);

  double calculateDepot(){
    double sum = 0;
    stockList.forEach((stock) {
      sum = sum + stock.price * stock.amount.toDouble();
     });
     return sum;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    itemCount: stockList.length+2,
    itemBuilder: (context, index){
      if(index == 0){
        return ListTile(
          title: Row(
            children: [
              Container(
                color: Colors.white,
                width: 50,
                height: 50,
                alignment: Alignment.centerLeft,
                child: const Text(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    'Nr.'
                  ),
              ),
              Container(
                color: Colors.white,
                width: 100,
                height: 50,
                alignment: Alignment.centerLeft,
                child: const Text(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    'Symbols',
                  ),
              ),
              Container(
                color: Colors.white,
                width: 80,
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                    style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    'Amount',
                  ),
              ),
              Container(
                color: Colors.white,
                width: 100,
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    'Price',
                  ),
              ),
            ],
          ),
        );
      }else if(index != stockList.length + 1){
        var stock = stockList[index-1];
        return ListTile(
          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SellStockPage(user, stock)));},
          title: Row(
            children: [
              Container(
                color: Colors.white,
                width: 50,
                height: 50,
                alignment: Alignment.centerLeft,
                child: Text(
                    style: const TextStyle(fontSize: 20),
                    (index).toString()
                  ),
              ),
              Container(
                color: Colors.white,
                width: 100,
                height: 50,
                alignment: Alignment.centerLeft,
                child: Text(
                    style: const TextStyle(fontSize: 20),
                    (stock.symbols),
                  ),
              ),
              Container(
                color: Colors.white,
                width: 80,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                    style: const TextStyle(fontSize: 20),
                    (stock.amount.toString()),
                  ),
              ),
              Container(
                color: Colors.white,
                width: 100,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                    style: const TextStyle(fontSize: 20),
                    (stock.price.toString()),
                  ),
              ),
            ],
          ),
        );
      }
      else{
        return ListTile(
          title: Text(
            style: const TextStyle(fontSize: 18),
            'Total sum of Your depot is: ${calculateDepot().toStringAsFixed(2)}'
            ),
        );
      }
    });
  }
}