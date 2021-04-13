import 'package:meta/meta.dart';
import 'package:sma/models/markets/crypto/crypto_active.dart';

class CryptoMoversModelData {
  final List<CryptoActiveModel> cryptoActiveModelData;

  CryptoMoversModelData({
    @required this.cryptoActiveModelData
  });

  static List<CryptoActiveModel> toList(List<dynamic> items) {
    return items
    .map((item) => CryptoActiveModel.fromJson(item))
    .toList();
  }
}
