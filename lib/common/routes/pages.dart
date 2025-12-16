import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/routes/names.dart';
import 'package:wal/global.dart';
import 'package:wal/pages/application/bloc/app_blocs.dart';
import 'package:wal/pages/application/application_page.dart';
import 'package:wal/pages/discover/bloc/discover_bloc.dart';
import 'package:wal/pages/discover/discover.dart';
import 'package:wal/pages/earn/bloc/earn_bloc.dart';
import 'package:wal/pages/earn/earn.dart';
import 'package:wal/pages/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:wal/pages/forgot_password/forgot_password.dart';
import 'package:wal/pages/home/bloc/home_bloc.dart';
import 'package:wal/pages/home/home.dart';
import 'package:wal/pages/seed_phrase/bloc/seed_phrase_bloc.dart';
import 'package:wal/pages/seed_phrase/seed_phrase_page.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:wal/pages/sign_in/sign_in.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_bloc.dart';
import 'package:wal/pages/sign_up/sign_up.dart' hide SignIn;
import 'package:wal/pages/swap/bloc/swap_bloc.dart';
import 'package:wal/pages/swap/swap.dart';
import 'package:wal/pages/trending/bloc/trending_bloc.dart';
import 'package:wal/pages/trending/trending.dart';
import 'package:wal/pages/wallet/bloc/wallet_bloc.dart';
import 'package:wal/pages/wallet/wallet.dart';
import 'package:wal/pages/welcome/bloc/welcome_blocs.dart';
import 'package:wal/pages/welcome/welcome.dart';

class AppPages {
  static List<PageEntity> routes() {
    return [
      PageEntity(
        route: AppRoutes.INITIAL,
        page: const Welcome(),
        bloc: BlocProvider(create: (_) => WelcomeBloc()),
      ),
      PageEntity(
        route: AppRoutes.SIGN_IN,
        page: const SignIn(),
        bloc: BlocProvider(create: (_) => SignInBloc()),
      ),
      PageEntity(
        route: AppRoutes.SIGN_UP,
        page: const SignUp(),
        bloc: BlocProvider(create: (_) => SignUpBloc()),
      ),
      PageEntity(
        route: AppRoutes.SEED_PHRASE,
        page: const SeedPhrasePage(
          email: '',
          firstName: '',
          lastName: '',
        ), // Default values
        bloc: BlocProvider(create: (_) => SeedPhraseBloc()),
      ),
      PageEntity(
        route: AppRoutes.FORGOT_PASSWORD,
        page: const ForgotPassword(),
        bloc: BlocProvider(create: (_) => ForgotPasswordBloc()),
      ),
      PageEntity(
        route: AppRoutes.APPLICATION,
        page: const ApplicationPage(),
        bloc: BlocProvider(create: (_) => AppBlocs()),
      ),
      PageEntity(
        route: AppRoutes.HOME,
        page: const Home(),
        bloc: BlocProvider(create: (_) => HomeBloc()),
      ),
      PageEntity(
        route: AppRoutes.TRENDING,
        page: const TrendingPage(),
        bloc: BlocProvider(create: (_) => TrendingBloc()),
      ),
      PageEntity(
        route: AppRoutes.SWAP,
        page: const SwapPage(),
        bloc: BlocProvider(create: (_) => SwapBloc()),
      ),
      PageEntity(
        route: AppRoutes.EARN,
        page: const StakePage(),
        bloc: BlocProvider(create: (_) => StakeBloc()),
      ),
      PageEntity(
        route: AppRoutes.DISCOVER,
        page: const DiscoverPage(),
        bloc: BlocProvider(create: (_) => DiscoverBloc()),
      ),
      PageEntity(
        route: AppRoutes.WALLET,
        page: const Wallet(),
        bloc: BlocProvider(create: (_) => WalletBloc()),
      ),
    ];
  }

  static List<dynamic> allBlocProviders(BuildContext context) {
    List<dynamic> blocProviders = <dynamic>[];
    for (var pageEntity in routes()) {
      if (pageEntity.bloc != null) {
        blocProviders.add(pageEntity.bloc);
      }
    }
    return blocProviders;
  }

  static MaterialPageRoute GenerateRouteSettings(RouteSettings settings) {
    try {
      if (settings.name != null) {
        var result = routes().where(
          (element) => element.route == settings.name,
        );
        if (result.isNotEmpty) {
          final pageEntity = result.first;
          bool deviceFirstOpen = Global.storageService.getDeviceFirstOpen();

          if (pageEntity.route == AppRoutes.INITIAL && deviceFirstOpen) {
            bool isLoggedIn = Global.storageService.getIsLoggedIn();
            if (isLoggedIn) {
              return MaterialPageRoute(
                builder: (_) => const ApplicationPage(),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (_) => const SignIn(),
              settings: settings,
            );
          }

          return MaterialPageRoute(
            builder: (_) => pageEntity.page,
            settings: settings,
          );
        }
      }

      return MaterialPageRoute(
        builder: (_) => const SignIn(),
        settings: settings,
      );
    } catch (e) {
      return MaterialPageRoute(
        builder: (_) =>
            Scaffold(body: Center(child: Text('Error loading page: $e'))),
        settings: settings,
      );
    }
  }
}

class PageEntity {
  final String route;
  final Widget page;
  final dynamic bloc;

  PageEntity({required this.route, required this.page, this.bloc});
}
