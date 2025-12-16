import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingBloc extends Cubit<int> {
  TrendingBloc() : super(0);

  void updateIndex(int index) => emit(index);
}
