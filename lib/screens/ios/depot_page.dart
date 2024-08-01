import 'package:flutter/cupertino.dart';

import '../../entities/stock.dart';
import '../../entities/user.dart';
import '../../list_views/ios/stock_list.dart';
import '../../utils/database.dart';

class DepotPageIOS extends StatelessWidget {
  final User user;
  final List<Stock> depotStocks;

  DepotPageIOS(this.user, this.depotStocks);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('${user.firstName}`s shares'),
      ),
      child: BodyStateful(user, depotStocks),
    );
  }
}

class BodyStateful extends StatefulWidget {
  final User user;
  final List<Stock> stocks;

  //final Map<String, dynamic> stock;

  BodyStateful(this.user, this.stocks);

  @override
  _BodyState createState() => _BodyState(user, stocks);
}

class _BodyState extends State<BodyStateful> {
  final User user;
  final List<Stock> stocks;

  //final Map<String, dynamic> stock;
  _BodyState(this.user, this.stocks);

  final bankDAO = BankingDatabase();

  @override
  Widget build(BuildContext context) {
    return StockListIOS(stocks, user);
  }
}
