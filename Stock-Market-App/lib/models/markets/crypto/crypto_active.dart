class CryptoActiveModel {
  
  final String symbol;
  final double price;
  final double changesPercentage;
  final double change;
  final double dayLow;
  final double dayHigh;
  final double yearHigh;
  final double yearLow;
  final double marketCap;
  final double priceAvg50;
  final double priceAvg200;
  final double volume;
  final double avgVolume;
  final String exhange;

  CryptoActiveModel({
    this.symbol,
    this.price,
    this.changesPercentage,
    this.change,
    this.dayLow,
    this.dayHigh,
    this.yearHigh,
    this.yearLow,
    this.marketCap,
    this.priceAvg50,
    this.priceAvg200,
    this.volume,
    this.avgVolume,
    this.exhange
  });

  factory CryptoActiveModel.fromJson(Map<String, dynamic> json) {
    return CryptoActiveModel(
      symbol: json['symbol'],
      price: json['price'],
      changesPercentage: json['changesPercentage'],
      change: json['change'],
      dayLow: json['dayLow'],
      dayHigh: json['dayHigh'],
      yearHigh: json['yearHigh'],
      yearLow: json['yearLow'],
      marketCap: json['marketCap'],
      priceAvg50: json['priceAvg50'],
      priceAvg200: json['priceAvg200'],
      volume: json['volume'],
      avgVolume: json['avgVolume'],
      exhange: json['exhange'],
    );
  }
}
