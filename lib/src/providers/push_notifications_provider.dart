import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:io';
import 'dart:async';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
      print('===== FCM Token =====');
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (info) async {
      print('======= On Message ========');
      print(info);
      String argumento = 'no-data';
      if (Platform.isAndroid) {
        argumento = info['data']['comida'] ?? 'no-data';
      } else {
        argumento = info['comida'] ?? 'no-data-ios';
      }
      _mensajesStreamController.sink.add(argumento);
    }, onLaunch: (info) async {
      print('======= On Launch ========');
      print(info);
    }, onResume: (info) async {
      print('======= On Resume ========');
      print(info);

      String argumento = 'no-data';

      if (Platform.isAndroid) {
        argumento = info['data']['comida'] ?? 'no-data';
      } else {
        argumento = info['comida'] ?? 'no-data-ios';
      }

      _mensajesStreamController.sink.add(argumento);
    });
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}

//TOKEN: e3KAQGPstvk:APA91bF0Yzy_1TIjoYoHMKehwrqpVaJTQ8w0wILLPeSxccj7EX-F9Dpv_cqkL-7arHVFYJFZZO7zaE2onKVWhCkgHuE0BnRySQWTcYjeCmQm44kA_DCCnAI_WifaYgqsCyjlQgp1HjCw
