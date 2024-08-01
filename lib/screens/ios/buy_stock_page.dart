import 'package:flutter/cupertino.dart';
import '../../entities/user.dart';

class BuyStockPageIOS extends StatelessWidget{
  final User user;

  BuyStockPageIOS(this.user);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Buy Stock"),
      ),
      child: Center(
        child: Text('Welcome to buy stock!'),
      ),
    );
  }
}