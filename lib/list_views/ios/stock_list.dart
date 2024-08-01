import 'package:flutter/cupertino.dart';
import '../../entities/stock.dart';
import '../../entities/user.dart';
import '../../screens/ios/sell_stock_page.dart';

class StockListIOS extends StatelessWidget {
  final List<Stock> stockList;
  final User user;

  StockListIOS(this.stockList, this.user);

  double calculateDepot() {
    double sum = 0;
    stockList.forEach((stock) {
      sum = sum + stock.price * stock.amount.toDouble();
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection.insetGrouped(
      header: Padding(
        padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
        child: Row(
          children: [
            Container(
              //color: Colors.white,
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: const Text(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  'Nr.'),
            ),
            Container(
              //color: Colors.white,
              width: 100,
              height: 50,
              alignment: Alignment.center,
              child: const Text(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                'Symbols',
              ),
            ),
            Container(
              //color: Colors.white,
              width: 100,
              height: 50,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const Text(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                'Amount',
              ),
            ),
            Container(
              //color: Colors.white,
              width: 100,
              height: 50,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: const Text(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                'Price',
              ),
            ),
          ],
        ),
      ),
      footer: Text(
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          'Total sum of Your depot is: ${calculateDepot().toStringAsFixed(2)}'),
      children: [
        ...List.generate(
            stockList.length,
            (index) =>
                buildCupertinoFormRow(stockList[index], index + 1, context))
      ],
    );
  }

  Widget buildCupertinoFormRow(Stock stock, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SellStockPageIOS(user, stock)));
      },
      child: CupertinoFormRow(
        child: Row(
          children: [
            Container(
              //color: Colors.white,
              width: 50,
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(
                  style: const TextStyle(fontSize: 20), (index).toString()),
            ),
            Container(
              //color: Colors.white,
              width: 100,
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(
                style: const TextStyle(fontSize: 20),
                (stock.symbols),
              ),
            ),
            Container(
              //color: Colors.white,
              width: 80,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                style: const TextStyle(fontSize: 20),
                (stock.amount.toString()),
              ),
            ),
            Container(
              //color: Colors.white,
              width: 100,
              height: 50,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                style: const TextStyle(fontSize: 20),
                (stock.price.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
