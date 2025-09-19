import 'package:flutter/cupertino.dart';
import 'package:wal/common/service/storage_service.dart';

class Global {
  static late StorageService storageService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Bloc.observer = MyGlobalObserver();
    // await Firebase.initializeApp(
    //   // options: DefaultFirebaseOptions.currentPlatform,
    // );
    storageService = await StorageService().init();
  }
}
