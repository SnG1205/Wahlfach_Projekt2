import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wahlfach_projekt/entities/stock_api.dart';

class BankApi{

  Future<StockApi> fetchStockPrice(String symbols) async {
    var formatter = DateFormat('yyyy-MM-dd');
    final currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final apiDate = currentDate.subtract(const Duration(days: 5)); //Note from 06.08: for some reason stopped working if date is earlier than 3 days before actual. Either new terms of use or some problem in API.
    final formattedDate = formatter.format(apiDate); //Note from 07.08 for some reason API doesn't provide any data from 03.08, mb date should be changed to static one :(
    final response = await http.get(Uri.parse(
      'https://api.polygon.io/v2/aggs/ticker/$symbols/range/1/day/$formattedDate/$formattedDate?adjusted=true&sort=asc&limit=120&apiKey=H1KXq7xnepqsiR6kI8VXha_aBykXh2Sz'
      ));
    if(response.statusCode == 200){
      return StockApi.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    else{
      throw Exception('Failed to load Stock');
    }
  } 
}