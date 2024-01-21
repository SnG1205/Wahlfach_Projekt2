import "package:flutter/widgets.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import 'package:wahlfach_projekt/entities/balance.dart';
import 'package:wahlfach_projekt/entities/stock.dart';
import 'package:wahlfach_projekt/entities/user.dart';

class BankingDatabase{
 
  Future<Database> openConnection() async{
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'banking_database.db'),
      onCreate: (db, version) {
      db.execute(
        'CREATE TABLE clients(id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, address TEXT, is_employee INTEGER)',
      );
      db.execute(
        'CREATE TABLE stocks(id INTEGER PRIMARY KEY, client_id INTEGER, symbols TEXT, price DOUBLE, amount INTEGER, CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES clients(id))'
      );
      db.execute('CREATE TABLE balance(balance DOUBLE)');
      db.execute('INSERT INTO balance VALUES(1000000)');
      db.execute('INSERT INTO clients(first_name, last_name, address, is_employee) VALUES(?, ?, ?, ?)', ['Serhii', 'Holiev', 'Home', 1]);
    },
    version: 1,
    );
  }

  Future<void> insertClient(Future<Database> database, User user) async{
    final db = await database;
    await db.insert('clients', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  } 

  Future<void> deleteClient(Future<Database> database, User user) async{
    final db = await database;
    await db.delete('clients', where: 'id = ?', whereArgs: [user.id]);
  } 

  Future<void> insertStock(Future<Database> database, Stock stock) async{
    final db = await database;
    await db.insert('stocks', stock.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteStock(Future<Database> database, Stock stock) async{
    final db = await database;
    await db.delete('stocks', where: 'client_id = ? and symbols = ?', whereArgs: [stock.clientId, stock.symbols]);
  }

  Future<void> updateStock(Future<Database> database, Stock stock) async{
    final db = await database;
    await db.update('stocks', {'price': stock.price, 'amount': stock.amount}, where: 'client_id = ? AND symbols = ?', whereArgs: [stock.clientId, stock.symbols]);
  }

  Future<void> updateBalance(Future<Database> database, double balance) async{
    final db = await database;
    await db.update('balance', {'balance': balance});
  }

  Future<List<Balance>> getBalance(Future<Database> database) async{
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('balance');
    
    return List.generate(maps.length, (i) {
      return Balance(balance: maps[i]['balance'] as double);
    });
  }

  Future<List<User>> getAllClients(Future<Database> database) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('clients', where: 'is_employee = ?', whereArgs: [0]);

    return List.generate(maps.length, (i){
      return User(
        id: maps[i]['id'] as int,
        firstName: maps[i]['first_name'] as String,
        lastName: maps[i]['last_name'] as String,
        address: maps[i]['address'] as String,
        isEmployee: maps[i]['is_employee'] as int);
    });
  }

  Future<List<Stock>> getAllStocks(Future<Database> database) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('stocks', distinct: true);

    return List.generate(maps.length, (i){
      return Stock(
        id: maps[i]['id'] as int,
        clientId: maps[i]['client_id'] as int,
        symbols: maps[i]['symbols'] as String,
        price: maps[i]['price'] as double,
        amount: maps[i]['amount'] as int);
    });
  }

  Future<User?> getClientByFullName(Future<Database> database, String firstName, String lastName) async {
    final db = await database;

    final List<Map<String, dynamic>> client = await db.rawQuery('SELECT * FROM clients WHERE first_name = ? AND last_name = ?', [firstName, lastName]);
    try{
      final Map<String, dynamic> map = client[0];
      return User(id: map['id'],
        firstName: map['first_name'],
        lastName: map['last_name'], 
        address: map['address'],
        isEmployee: map['is_employee']);
    }
    catch(e){
      return null;
    }
  }

  Future<User?> getClientById(Future<Database> database, int id) async {
    final db = await database;

    final List<Map<String, dynamic>> client = await db.rawQuery('SELECT * FROM clients WHERE id = ?', [id]);
    try{
      final Map<String, dynamic> map = client[0];
      return User(id: map['id'],
        firstName: map['first_name'],
        lastName: map['last_name'], 
        address: map['address'],
        isEmployee: map['is_employee']);
    }
    catch(e){
      return null;
    }
  }

  Future<dynamic> getStocksByClientId(Future<Database> database, int clientId) async {
    final db = await database;

    try{
      final List<Map<String, dynamic>> stocksMap = await db.rawQuery('SELECT * FROM stocks WHERE client_id = ?', [clientId]);
      List<Stock> stocksList = List.empty(growable: true);
      stocksMap.forEach((stock) =>
        stocksList.add(
          Stock(id: stock['id'], clientId: stock['client_id'], symbols: stock['symbols'], price: stock['price'], amount: stock['amount'])
        )
      );
      return stocksList;
    }
    catch(e){
      print(e);
      //return Null;
    }
  }

  Future<dynamic> getStockByClientIdAndSymbols(Future<Database> database, int clientId, String symbols) async {
    final db = await database;

    try{
      final List<Map<String, dynamic>> stocksMap = await db.rawQuery('SELECT * FROM stocks WHERE client_id = ? AND symbols = ?', [clientId, symbols]);
      Map<String, dynamic> stockMap = stocksMap[0];
      return Stock(id: stockMap['id'], clientId: stockMap['client_id'], symbols: stockMap['symbols'], price: stockMap['price'], amount: stockMap['amount']);
    }
    catch(e){
      //print(e);
      return null;
    }
  }     
}

