import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:536335012908:ios:9571e41104b8c6d56c6d89',
        apiKey: 'AIzaSyA2aocLKTzhTo2dnNAFlPKh1aXH9o1wHSY',
        projectId: 'quickcart-5ade3',
        messagingSenderId: '536335012908',
        iosBundleId: 'com.example.quickcart',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:536335012908:android:c5ae97933ed329b16c6d89',
        apiKey: 'AIzaSyA3_3W0JkRp9gZln2pp9TMVP_3qIM9kt0s',
        projectId: 'quickcart-5ade3',
        messagingSenderId: '536335012908',
      );
    }
  }
}
