class Balance{
  final double balance;

  const Balance({required this.balance});

  Map<String, dynamic> toMap(){
    return{
      'balance': balance
    };
  }
}