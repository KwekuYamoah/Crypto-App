import 'dart:async';

import 'package:crypto_app/config.dart';
import 'package:ably_flutter_plugin/ably_flutter_plugin.dart' as ably;
import 'package:flutter/foundation.dart';

/// Adding currently available currenicies on Cryptocurrency Prices Hub

const List<Map> _coinTypes = [
  {
    "name": "Bitcoin",
    "code": "btc",
  },
  {
    "name": "Ethereum",
    "code": "eth",
  },
  {
    "name": "Ripple",
    "code": "xrp",
  }
];

/// Modelling cryptocurrency data to map to UI
class Coin {
  final String code;
  final double price;
  final DateTime dateTime;

  Coin({
    this.code,
    this.price,
    this.dateTime,
  });
}

/// class for Chat message
class ChatMessage {
  final String content;
  final DateTime dateTime;
  final bool isWriter;

  ChatMessage({
    this.content,
    this.dateTime,
    this.isWriter,
  });
}

/// Class to get update on coins
class CoinUpdates extends ChangeNotifier {
  CoinUpdates({this.name});
  final String name;

  Coin _coin;

  Coin get coin => _coin;
  updateCoin(value) {
    this._coin = value;
    notifyListeners();
  }
}

/// Class to get chat updates
class ChatUpdates extends ChangeNotifier {
  ChatMessage _message;
  ChatMessage get message => _message;
  updateChat(value) {
    this._message = value;
    notifyListeners();
  }
}

/// Creating main AblyService Class
class AblyService {
  final ably.Realtime _realtime;
  ably.RealtimeChannel _chatChannel;

  /// getting connection status of the realtime instance
  Stream<ably.ConnectionStateChange> get connection =>
      _realtime.connection.on();

  AblyService._(this._realtime);

  /// creating AlbyService instance
  static Future<AblyService> init() async {
    /// initialize client options for your Ably account using your private API key
    final ably.ClientOptions _clientOptions =
        ably.ClientOptions.fromKey(APIKey);
    
    /// initialize real-time object with the client options
    final _realtime = ably.Realtime(options: _clientOptions);

     /// connect the app to Ably's Realtime sevices supported by this SDK
    await _realtime.connect();

    /// reaturn the single instance of AblyService with the local `_realtime` instance to
    /// be set as the value of the service's `_realtime` property, so it can be used in
    /// all methods.
    return AblyService._(_realtime);
  }

  List<CoinUpdates> _coinUpdates = [];
  /// Start listening to cryptocurrency prices from Coindesk hub and return
  /// a list of `CoinUpdates` for each currency.
  List<CoinUpdates> getCoinUpdates() {
    if (_coinUpdates.isEmpty) {
      for (int i = 0; i < _coinTypes.length; i++) {
        String coinName = _coinTypes[i]['name'];
        String coinCode = _coinTypes[i]['code'];

        _coinUpdates.add(CoinUpdates(name: coinName));

        //launch a channel for each coin type
        ably.RealtimeChannel channel = _realtime.channels
            .get('[product:ably-coindesk/crypto-pricing]$coinCode:usd');

        //subscribe to receive channel messages
        final Stream<ably.Message> messageStream = channel.subscribe();

        //map each stream event to a Coin and start listining
        messageStream.where((event) => event.data != null).listen((message) {
          _coinUpdates[i].updateCoin(
            Coin(
              code: coinCode,
              price: double.parse('${message.data}'),
              dateTime: message.timestamp,
            ),
          );
        });
      }
    }
    return _coinUpdates;
  }

  /// This method is called one time when the chat page is opened, it doesn't
  /// read history (messages sent previously) so each time you leave and get
  /// back to chat page past messages will be lost.
  ChatUpdates getChatUpdates() {
    ChatUpdates _chatUpdates = ChatUpdates();

    _chatChannel = _realtime.channels.get('public-chat');

    var messageStream = _chatChannel.subscribe();

    messageStream.listen((message) {
      _chatUpdates.updateChat(
        ChatMessage(
          content: message.data,
          dateTime: message.timestamp,
          isWriter: message.name == "${_realtime.clientId}",
        ),
      );
    });

    return _chatUpdates;
  }

  /// connect to the same chat channel to publish new messages.
  /// The name of the channel is important, if it wasn't the same one subscribed
  /// to in [getChatUpdates] we won't get the published messages.
  Future sendMessage(String content) async {
    _realtime.channels.get('public-chat');

    await _chatChannel.publish(data: content, name: "${_realtime.clientId}");
  }
}
