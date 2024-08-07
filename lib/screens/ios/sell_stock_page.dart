import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../entities/stock.dart';
import '../../entities/user.dart';
import '../../utils/database.dart';

class SellStockPageIOS extends StatelessWidget {
  final User user;
  final Stock stock;

  SellStockPageIOS(this.user, this.stock);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Sell ${stock.symbols} Stock'),
        ),
        child: BodyStateful(user, stock)
    );
  }
}

class BodyStateful extends StatefulWidget{
  final User user;
  final Stock stock;
  //final Map<String, dynamic> stock;

  BodyStateful(this.user, this.stock);

  @override
  _BodyState createState() => _BodyState(user, stock);
}

class _BodyState extends State<BodyStateful>{
  final User user;
  final Stock stock;

  _BodyState(this.user, this.stock);

  final bankDAO = BankingDatabase();
  final amountController = TextEditingController();

  void sellStock() async{
    final db =  bankDAO.openConnection();
    double currentBalance = (await bankDAO.getBalance(db))[0].balance;
    try{
      int sellAmount = int.parse(amountController.text);
      if(sellAmount > 0){
        if(sellAmount > stock.amount){
          Fluttertoast.showToast(msg: 'You don`t have enough shares to sell');
          amountController.clear();
        } else if (sellAmount == stock.amount){
          bankDAO.deleteStock(db, stock);
          bankDAO.updateBalance(db, currentBalance + sellAmount.toDouble()*stock.price);
          Fluttertoast.showToast(msg: 'You succesfully sold all shares of ${stock.symbols}.');
          amountController.clear();
        }
        else{
          Stock updatedStock = Stock.withoutId(clientId: stock.clientId, symbols: stock.symbols, price: stock.price, amount: stock.amount - sellAmount);
          bankDAO.updateStock(db, updatedStock);
          bankDAO.updateBalance(db, currentBalance + sellAmount.toDouble()*updatedStock.price);
          Fluttertoast.showToast(msg: 'You succesfully sold $sellAmount shares.');
          amountController.clear();
          FocusScope.of(context).unfocus();
        }
      }else{
        Fluttertoast.showToast(msg: 'Insert number greater than 0');
        amountController.clear();
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: 'Please enter a number');
      amountController.clear();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: Column(
      children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(0, 140, 0, 50),
            child: Text(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
              'Please enter below the amount You want to sell:',
            )
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
            child: CupertinoTextField(
              autocorrect: false,
              placeholder: 'Amount',
              controller: amountController,
              /*decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter amount',
                  labelText: 'Enter amount'
              ),*/
            )
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 45, 0, 15),
            child: CupertinoButton(
              onPressed: sellStock,
              /*style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(200, 50)),
                  backgroundColor: MaterialStatePropertyAll(Colors.lightGreenAccent)
              ),*/
              child: const Text(
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  'Sell Stock'
              ),
            )
        )
      ],
    ));
  }
}