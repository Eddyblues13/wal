import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit<int> stores the selected top-tab index in the Stake page:
/// 0 => Stake Hub, 1 => My Staking
class StakeBloc extends Cubit<int> {
  StakeBloc() : super(0);

  void updateIndex(int index) => emit(index);
}
