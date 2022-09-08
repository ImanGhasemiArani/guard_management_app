import 'dart:async';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'server_service.dart';

class MessageService {
  static final MessageService _messageService = MessageService._instance();
  final ParseCloudFunction _receiveMessageCloudFunc =
      ParseCloudFunction('receiveMessage');
  final StreamController<Message> _onMessage = StreamController<Message>();
  final String senderUsername = ServerService.currentUser.username!;

  factory MessageService() {
    return _messageService;
  }
  MessageService._instance() {
    _setupChannel();
  }

  Future<void> _setupChannel() async {
    final client = LiveQueryClient();
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Message'));
    query.whereEqualTo('receiver', senderUsername);
    final subscription = await client.subscribe(query);
    subscription.on(LiveQueryEvent.create, (value) {
      _onMessage.add(Message.fromJson((value as ParseObject).toJson()));
    });
  }

  Future<void> _receiveMessage() async {
    final response = await _receiveMessageCloudFunc.execute();
    if (response.success && response.result != null) {
      final Message message = Message.fromJson(response.result);
      _onMessage.add(message);
    }
  }

  Stream<Message> get onMessage => _onMessage.stream;
}

class Message {
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
  );

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['sender'] as String,
      json['receiver'] as String,
      json['title'] as String,
      json['body'] as String,
      json['data'] as String?,
    );
  }
}
