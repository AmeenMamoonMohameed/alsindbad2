import 'dart:core';
import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';

enum NotificationAction { none, profile, list, product, order }

enum NotificationType { message, notification, publicNotification }

// NotificationAction exportActionEnum(String type) {
//   switch (type) {
//     case "create_product_akarak":
//       return NotificationAction.created;
//     case "update_product_akarak":
//       return NotificationAction.updated;
//     default:
//       return NotificationAction.alert;
//   }
// }

class NotificationModel {
  final int id;
  final NotificationAction action;
  final NotificationType type;
  late String? externalId;
  late String? userId;
  final String name;
  final String description;
  late String? url;
  late String? arguments;
  late int? priority;
  late String? image;
  late String? icon;
  final bool isRecived;
  final bool isTemporarily;
  late String? temporarilyUntil;
  late String? expiryDate;

  NotificationModel({
    required this.id,
    required this.action,
    required this.type,
    this.externalId,
    this.userId,
    required this.name,
    required this.description,
    this.url,
    this.arguments,
    this.priority,
    this.image,
    this.icon,
    required this.isRecived,
    required this.isTemporarily,
    this.temporarilyUntil,
    this.expiryDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    NotificationType notificationType = NotificationType.values[
        int.parse(json['type'] == null ? "0" : json['type'].toString())];
    NotificationAction notificationAction = NotificationAction.values[
        int.parse(json['action'] == null ? "0" : json['action'].toString())];

    return NotificationModel(
      id: int.parse(json['id']?.toString() ?? '0'),
      action: notificationAction,
      type: notificationType,
      externalId: json['externalId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      arguments: json['arguments'],
      priority: int.parse(json['priority']?.toString() ?? '0'),
      image: json['image'] ?? '',
      icon: json['icon'] ?? '',
      isRecived: false, //json['isRecived'],
      isTemporarily: true, //json['isTemporarily'],
      temporarilyUntil: json['temporarilyUntil'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
    );
  }

  // factory NotificationModel.fromRemoteMessage(RemoteMessage message) {

  //   return NotificationModel(
  //     action: exportActionEnum(message.data['action'] ?? 'Unknown'),
  //     title: message.data['title'] ?? 'Unknown',
  //     id: int.tryParse(message.data['id'].toString()) ?? 0,
  //   );
  // }
}
