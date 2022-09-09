import 'dart:async';

import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'server_service.dart';

class MessageService {
  static final MessageService _instance = MessageService._internal();

  factory MessageService() {
    return _instance;
  }

  MessageService._internal() {
    _setupChannel();
  }

  final RxInt _badgeCounter = 0.obs;

  final ParseCloudFunction _receiveMessageCloudFunc =
      ParseCloudFunction('receiveMessage');
  final StreamController<Message> _onMessage = StreamController<Message>();
  final String senderUsername = ServerService.currentUser.username!;

  Future<void> _setupChannel() async {
    await checkManualMessage();
    final client = LiveQueryClient();
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Message'));
    query.whereEqualTo('receiver', senderUsername);
    query.whereEqualTo('isSent', false);
    final subscription = await client.subscribe(query);
    subscription.on(LiveQueryEvent.create,
        (messageObj) => _receiveMessage(messageObj as ParseObject));
  }

  Future<void> checkManualMessage() async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Message'));
    query.whereEqualTo('receiver', senderUsername);
    query.whereEqualTo('isSent', false);
    final result = await query.find();
    if (result.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      result.forEach((element) => _receiveMessage(element));
    }
  }

  void _receiveMessage(ParseObject messageObj) async {
    _badgeCounter.value++;
    ServerService.readMessage(messageObj.objectId!);
    _onMessage.add(Message.fromJson(messageObj.toJson()));
  }

  void resetBadge() {
    _badgeCounter.value = 0;
  }

  Stream<Message> get onMessage => _onMessage.stream;
  int get badgeCounter => _badgeCounter.value;
}

class Message {
  final String? objectId;
  final String sender;
  final String receiver;
  final String title;
  final String body;
  final String? data;

  Message(
    this.sender,
    this.receiver,
    this.title,
    this.body,
    this.data,
    this.objectId,
  );

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['sender'] as String,
      json['receiver'] as String,
      json['title'] as String,
      json['body'] as String,
      json['data'] as String?,
      json['objectId'] as String,
    );
  }
}
