import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'common/routes/routes.dart';
import 'common/service/theme_service.dart';
import 'global.dart';

Future<void> main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    _themeService = ThemeService();
  }

  @override
  void dispose() {
    _themeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _themeService,
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MultiBlocProvider(
            providers: [...AppPages.allBlocProviders(context)],
            child: ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (context, child) => MaterialApp(
                builder: EasyLoading.init(),
                debugShowCheckedModeBanner: false,
                theme: themeService.getLightTheme(),
                darkTheme: themeService.getDarkTheme(),
                themeMode: themeService.themeMode,
                onGenerateRoute: AppPages.GenerateRouteSettings,
              ),
            ),
          );
        },
      ),
    );
  }
}
