class StockApi{
  final String ticker;
  final Map<String, dynamic> results;

  const StockApi({
    required this.ticker,
    required this.results,
  });

  StockApi fromJson(Map<String, dynamic> json){
    return StockApi(ticker: json['ticker'], results: json['results']);
  }

  factory StockApi.fromJson(Map<String, dynamic> json){
    return StockApi(ticker: json['ticker'], results: json['results'][0]);
  }
}