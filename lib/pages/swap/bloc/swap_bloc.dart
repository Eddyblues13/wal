import 'package:flutter_bloc/flutter_bloc.dart';

class SwapBloc extends Cubit<int> {
  SwapBloc() : super(0);

  void updateIndex(int index) => emit(index);
}
