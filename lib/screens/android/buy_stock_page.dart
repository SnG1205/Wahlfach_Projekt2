import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wahlfach_projekt/utils/bank_api.dart';
import 'package:wahlfach_projekt/utils/database.dart';
import 'package:wahlfach_projekt/entities/stock.dart';
import 'package:wahlfach_projekt/entities/stock_api.dart';
import 'package:wahlfach_projekt/entities/user.dart';

class BuyStockPage extends StatelessWidget{
  final User user;

  BuyStockPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Stock'), 
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
  final symbolsController = TextEditingController();
  final amountController = TextEditingController();
  final bankingApi = BankApi();

  StockApi? stockApi;
  String apiRequest = '';
  double balance = 1;

  void getBalance() async {
    double forState = (await bankDAO.getBalance(bankDAO.openConnection()))[0].balance;
    setState(() {
      balance = forState;
    });
  }

  void fetchStock() async{
    if(symbolsController.text != ''){
      try{
        stockApi = await bankingApi.fetchStockPrice(symbolsController.text);
      setState(()  {
        apiRequest = 'Price per share of the ${stockApi!.ticker} stock is: ${stockApi!.results['o'].toString()}';
      }); 
      }
      catch(e){
        Fluttertoast.showToast(msg: "No stock was found with given symbols. Please try again.");
      }
    }
    
  }

  void buyStock() async{
    if(apiRequest.isEmpty){
      Fluttertoast.showToast(msg: "Please find the shares that You want to buy first.");
    }
    else{
      Future<Database> db = bankDAO.openConnection();
      double pricePerShare = stockApi!.results['o'];
      double currentBalance = (await bankDAO.getBalance(db))[0].balance;
      Stock? stockInDatabase = await bankDAO.getStockByClientIdAndSymbols(db, user.id!, stockApi!.ticker);
      try{
        int amount = int.parse(amountController.text);
        if(amount > 0){
          if(pricePerShare*(amount.toDouble()) > currentBalance){
            Fluttertoast.showToast(msg: 'You don`t have enough balance to buy shares.');
          }
          else{
            if(stockInDatabase == null){
            bankDAO.insertStock(db, Stock.withoutId(clientId: user.id!, symbols: stockApi!.ticker, price: pricePerShare, amount: amount));
            }
            else{
            int newAmount = amount + stockInDatabase.amount;
            bankDAO.updateStock(db, Stock.withoutId(clientId: user.id!, symbols: stockApi!.ticker, price: pricePerShare, amount: newAmount));
            }
            bankDAO.updateBalance(db, currentBalance - pricePerShare * amount);
            Fluttertoast.showToast(msg: 'Shares were succesfully bought.');
            symbolsController.clear();
            amountController.clear();
          }
        } else{
          Fluttertoast.showToast(msg: 'Insert number greater than 0');
          amountController.clear();
        }
      }
      catch(e){
        Fluttertoast.showToast(msg: 'Please enter a valid number');
        amountController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: TextField(
            controller: symbolsController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter symbols of desired stock',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: fetchStock,
              )
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: TextField(
            controller: amountController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter amount to buy',
            ),
          )        
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: Text(
            style: const TextStyle(fontSize: 16),
            apiRequest
            )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: FilledButton(
            onPressed: buyStock,
            style: const ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size(200, 50)),
            ),
            child: const Text('Buy Shares')
          )        
        )
        ],
      )
    );
  }
}