import 'package:flutter/cupertino.dart';

import '../../entities/stock.dart';
import '../../entities/user.dart';

class DepotPageIOS extends StatelessWidget{
  final User user;
  final List<Stock> depotStocks;

  DepotPageIOS(this.user, this.depotStocks);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('${user.firstName}`s shares'),
      ),
      child: Center(
        child: Text('Welcome to show depot!'),
      ),
    );
  }
}