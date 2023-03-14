import 'dart:convert';

import 'package:akarak/api/websockets.dart';
import 'package:akarak/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:akarak/blocs/bloc.dart';
import 'package:akarak/models/model.dart';
import '../../models/model_chat_status.dart';
import 'cubit.dart';

class RealTimeCubit extends Cubit<RealTimeState> {
  RealTimeCubit() : super(RealTimeLoading());

  static final Websocket websocket = Websocket('10.0.2.2', '5000');
  void Function(dynamic)? onNotifyNewMsg;
  void Function(dynamic)? onNotifyNewMsgReaction;
  void Function(dynamic)? onNotifyDeliveredStatus;
  void Function(dynamic)? onNotifyReadedStatus;
  void Function(dynamic)? onNotifyNewConnect;
  void Function(dynamic)? onNotifyNewBlocked;

  void connect() async {
    websocket.connectToServer();
    websocket.listenForMessages(notify);
    // websocket.sendMessage('message');
  }

  void disconnect() async {
    websocket.disconnectFromServer();
    // websocket.sendMessage('message');
  }

  Future<void> notify(dynamic message) async {
    var msg = ResultApiModel.fromJson(jsonDecode(message));
    if (msg.controller == 'chat') {
      switch (msg.action) {
        case 'notifyNewMsg':
          if (onNotifyNewMsg != null) onNotifyNewMsg!(msg);
          break;
        case 'notifyNewMsgReaction':
          if (onNotifyNewMsgReaction != null) onNotifyNewMsgReaction!(msg);
          break;
        case 'notifyDeliveredMsg':
          if (onNotifyDeliveredStatus != null) onNotifyDeliveredStatus!(msg);
          break;
        case 'notifyReadMsg':
          if (onNotifyReadedStatus != null) onNotifyReadedStatus!(msg);
          break;
        case 'notifyNewConnect':
          if (onNotifyNewConnect != null) onNotifyNewConnect!(msg);
          break;
        case 'notifyNewBlocked':
          if (onNotifyNewBlocked != null) onNotifyNewBlocked!(msg);
          break;
      }
    }
  }
}
