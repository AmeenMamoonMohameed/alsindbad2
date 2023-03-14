import 'dart:async';
import 'package:akarak/blocs/app_bloc.dart';
import 'package:akarak/models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'json.dart';

class Websocket {
  late IOWebSocketChannel channel;
  late String serverHostname;
  late String serverPort;

  Websocket(this.serverHostname, this.serverPort);

  // Websocket(this.serverHostname, this.serverPort) {
  //   channel = IOWebSocketChannel.connect(
  //       Uri.parse('wss://$serverHostname:$serverPort/socket'));
  //   // 'wss://$serverHostname:$serverPort/wss/chat',headers: {'bearer':'${AppBloc.userCubit.state?.token}'});
  // }

  void connectToServer() {
    channel = IOWebSocketChannel.connect(
      Uri.parse('ws://akarak-001-site5.gtempurl.com/socket'),
      // Uri.parse('ws://$serverHostname:$serverPort/socket'),
      headers: {
        // 'Origin': 'ws://akarak-001-site5.gtempurl.com',
        'Origin': 'ws://$serverHostname:$serverPort',
        'Authorization': 'bearer ${AppBloc.userCubit.state?.token}'
      },
    );
    print('connect to server');
  }

  void disconnectFromServer() {
    channel.sink.close(status.goingAway);
    print('disconnect to server');
  }

  void listenForMessages(void Function(dynamic message) onMessageReceived) {
    channel.stream.listen(
      onMessageReceived,
      onDone: () {
        channel = IOWebSocketChannel.connect(
          Uri.parse('ws://$serverHostname:$serverPort/socket'),
          headers: {
            'Origin': 'ws://$serverHostname:$serverPort',
            'Authorization': 'bearer ${AppBloc.userCubit.state?.token}'
          },
        );

        debugPrint('ws channel closed');
      },
      onError: (error) {
        debugPrint('ws error $error');
      },
    );
    print('now listening for messages');
  }

  void sendMessage(String message) {
    print('sending a message: $message');
    channel.sink.add(message);
    // channel.sink.add(Json.encodeMessageJSON(message));
  }
}
