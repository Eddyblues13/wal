import 'package:flutter/material.dart';
import 'package:wal/pages/discover/discover.dart';
import 'package:wal/pages/earn/earn.dart';
import 'package:wal/pages/home/dialog/settings_page.dart';
import 'package:wal/pages/home/home.dart';
import 'package:wal/pages/swap/swap.dart';
import 'package:wal/pages/trending/trending.dart';

Widget buildPage(int index) {
  switch (index) {
    case 0:
      return const Home();
    case 1:
      return const SwapPage();
    case 2:
      return const StakePage();
    case 3:
      return const SettingsPage();

    default:
      return const Home();
  }
}
