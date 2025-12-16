import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/wallet/bloc/wallet_event.dart';
import 'package:wal/pages/wallet/bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(const WalletState()) {
    on<WalletTabChanged>(_onTabChanged);
    on<WalletNavIndexChanged>(_onNavIndexChanged);
    on<WalletLoadData>(_onLoadData);
    on<WalletBuyCrypto>(_onBuyCrypto);
    on<WalletDepositCrypto>(_onDepositCrypto);
    on<WalletManageCrypto>(_onManageCrypto);
    on<WalletReceiveNFTs>(_onReceiveNFTs);
  }

  void _onTabChanged(WalletTabChanged event, Emitter<WalletState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  void _onNavIndexChanged(
    WalletNavIndexChanged event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(bottomNavIndex: event.index));
  }

  void _onLoadData(WalletLoadData event, Emitter<WalletState> emit) async {
    emit(state.copyWith(isLoading: true));

    // Simulate data loading
    await Future.delayed(const Duration(seconds: 1));

    emit(
      state.copyWith(
        isLoading: false,
        balance: 1250.75,
        portfolioValue: 3560.25,
        portfolioChange: 2.34,
      ),
    );
  }

  void _onBuyCrypto(WalletBuyCrypto event, Emitter<WalletState> emit) {
    // Handle buy crypto logic
    print('Buy Crypto triggered');
  }

  void _onDepositCrypto(WalletDepositCrypto event, Emitter<WalletState> emit) {
    // Handle deposit crypto logic
    print('Deposit Crypto triggered');
  }

  void _onManageCrypto(WalletManageCrypto event, Emitter<WalletState> emit) {
    // Handle manage crypto logic
    print('Manage Crypto triggered');
  }

  void _onReceiveNFTs(WalletReceiveNFTs event, Emitter<WalletState> emit) {
    // Handle receive NFTs logic
    print('Receive NFTs triggered');
  }
}
