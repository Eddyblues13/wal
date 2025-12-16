// lib/pages/home/dialog/bloc/history_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/apis/history_api.dart';
import 'package:wal/global.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const HistoryState()) {
    on<HistoryLoadData>(_onLoadData);
    on<HistoryRefreshData>(_onRefreshData);
    on<HistoryNetworkChanged>(_onNetworkChanged);
  }

  void _onLoadData(HistoryLoadData event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(isLoading: true, error: ''));

    try {
      // Get wallet address from storage
      String walletAddress = Global.storageService.getUserWallet();

      print('📜 HistoryBloc - Loading data for wallet: $walletAddress');

      if (walletAddress.isEmpty) {
        emit(
          state.copyWith(isLoading: false, error: 'No wallet address found'),
        );
        return;
      }

      // Set wallet address immediately
      emit(
        state.copyWith(
          isLoading: true,
          walletAddress: walletAddress,
          error: '',
        ),
      );

      // Fetch transaction history
      final historyData = await HistoryAPI.getTransactionHistory(walletAddress);

      if (historyData.containsKey('error')) {
        emit(state.copyWith(isLoading: false, error: historyData['error']));
        return;
      }

      final transactions =
          (historyData['transactions'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          [];
      final transactionCount = historyData['transaction_count'] as int? ?? 0;

      emit(
        state.copyWith(
          isLoading: false,
          transactions: transactions,
          transactionCount: transactionCount,
          error: '',
        ),
      );

      print('✅ History data loaded: $transactionCount transactions');
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load history: ${e.toString()}',
        ),
      );
    }
  }

  void _onRefreshData(HistoryRefreshData event, Emitter<HistoryState> emit) {
    add(const HistoryLoadData());
  }

  void _onNetworkChanged(
    HistoryNetworkChanged event,
    Emitter<HistoryState> emit,
  ) {
    emit(state.copyWith(selectedNetwork: event.network));
    // You can filter transactions by network here if needed
  }
}
