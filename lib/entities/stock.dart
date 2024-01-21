class Stock{
  final int? id;
  final int clientId;
  final String symbols;
  final double price;
  final int amount;

  const Stock({
    required this.id,
    required this.clientId,
    required this.symbols,
    required this.price,
    required this.amount
  });

  const Stock.withoutId({
    this.id,
    required this.clientId,
    required this.symbols,
    required this.price,
    required this.amount
  });

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'client_id': clientId,
      'symbols': symbols,
      'price': price,
      'amount': amount
    };
  }
}