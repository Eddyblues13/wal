import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/apis/wallet_api.dart';
import 'package:wal/common/apis/history_api.dart'; // ADD THIS IMPORT
import 'package:wal/global.dart';
import 'package:wal/pages/home/bloc/home_event.dart';
import 'package:wal/pages/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeLoadData>(_onLoadData);
    on<HomeLoadWalletData>(_onLoadWalletData);
    on<HomeRefreshData>(_onRefreshData);
    on<HomeTabChanged>(_onTabChanged);
    on<HomeBuyCrypto>(_onBuyCrypto);
    on<HomeSendCrypto>(_onSendCrypto);
    on<HomeReceiveCrypto>(_onReceiveCrypto);
    on<HomeSwapCrypto>(_onSwapCrypto);
    on<HomeDepositCrypto>(_onDepositCrypto);
    on<HomeManageCrypto>(_onManageCrypto);
    on<HomeReceiveNFTs>(_onReceiveNFTs);
    on<HomeLoadProfile>(_onLoadProfile);
    on<HomeCopyReferralCode>(_onCopyReferralCode);
  }

  void _onLoadData(HomeLoadData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, apiError: ''));

    try {
      // Debug storage first
      Global.storageService.debugStorage();

      // Get wallet address from storage (saved during login)
      String walletAddress = Global.storageService.getUserWallet();

      print('🔍 HomeBloc - Retrieved wallet from storage: "$walletAddress"');
      print('🔍 HomeBloc - Wallet is empty: ${walletAddress.isEmpty}');

      if (walletAddress.isEmpty) {
        print('⚠️ HomeBloc - No wallet address found in storage!');

        // Use demo data immediately
        _loadDemoData(emit);
      } else {
        print('🚀 HomeBloc - Found wallet, loading data...');

        // Set wallet address immediately
        emit(
          state.copyWith(
            isLoading: true,
            walletAddress: walletAddress,
            apiError: '',
          ),
        );

        // Then load wallet data in separate event
        add(HomeLoadWalletData(walletAddress));
      }
    } catch (e) {
      print('❌ HomeBloc - Error in _onLoadData: $e');
      emit(
        state.copyWith(
          isLoading: false,
          apiError: 'Failed to load wallet data: ${e.toString()}',
        ),
      );
    }
  }

  void _onLoadWalletData(
    HomeLoadWalletData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      print('💰 HomeBloc - Fetching wallet balance from API...');

      final walletData = await WalletAPI.getWalletBalance(event.walletAddress);

      if (walletData.containsKey('error')) {
        emit(state.copyWith(isLoading: false, apiError: walletData['error']));
        return;
      }

      final totalPortfolio =
          (walletData['total_portfolio_usdt'] as num?)?.toDouble() ?? 0.0;
      final assets =
          (walletData['assets'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final cryptoAssets = _convertApiAssetsToAppFormat(assets);

      // NEW: Load recent transactions
      print('📜 HomeBloc - Fetching transaction history...');
      final transactionData = await HistoryAPI.getTransactionHistory(
        event.walletAddress,
      );

      List<Map<String, dynamic>> recentTransactions = [];

      if (transactionData.containsKey('error')) {
        print(
          '⚠️ HomeBloc - Failed to load transactions: ${transactionData['error']}',
        );
        // Continue without transactions, don't fail the whole load
      } else {
        recentTransactions =
            (transactionData['transactions'] as List?)
                ?.cast<Map<String, dynamic>>()
                .take(5) // Get only last 5 transactions
                .toList() ??
            [];
        print(
          '✅ HomeBloc - Loaded ${recentTransactions.length} recent transactions',
        );
      }

      emit(
        state.copyWith(
          isLoading: false,
          balance: totalPortfolio,
          portfolioValue: totalPortfolio,
          cryptoAssets: cryptoAssets,
          recentTransactions:
              recentTransactions, // NEW: Add transactions to state
          apiError: '',
        ),
      );

      print(
        '✅ Wallet data loaded: \$$totalPortfolio, ${cryptoAssets.length} assets, ${recentTransactions.length} recent transactions',
      );

      // Load profile after successful wallet data load
      add(const HomeLoadProfile());
    } catch (e) {
      print('❌ HomeBloc - Error in _onLoadWalletData: $e');
      emit(
        state.copyWith(
          isLoading: false,
          apiError: 'Failed to fetch wallet data: ${e.toString()}',
        ),
      );
    }
  }

  void _loadDemoData(Emitter<HomeState> emit) {
    // NEW: Add demo transactions for when no wallet is available
    final demoTransactions = [
      {
        'date': '25-11-03 11:54',
        'coin': 'Starcoin',
        'amount': 10.0,
        'hash':
            'e4e3a315a7489160d25b80adbe566dcb92b711a30870fe5d1567f687d6dbc4fe',
        'explorer':
            'https://tonviewer.com/transaction/e4e3a315a7489160d25b80adbe566dcb92b711a30870fe5d1567f687d6dbc4fe',
      },
      {
        'date': '25-11-03 11:51',
        'coin': 'TON',
        'amount': 0.5,
        'hash':
            'a6b14e9331b23f1f0e42dc87b84c1d0706bc71fba7c9438cc021c8d6ae8e8690',
        'explorer':
            'https://tonviewer.com/transaction/a6b14e9331b23f1f0e42dc87b84c1d0706bc71fba7c9438cc021c8d6ae8e8690',
      },
    ];

    emit(
      state.copyWith(
        isLoading: false,
        balance: 12560.75,
        portfolioValue: 3560.25,
        portfolioChange: 2.34,
        cryptoAssets: [
          {
            'symbol': 'BTC',
            'name': 'Bitcoin',
            'amount': '0.005 BTC',
            'value': '\$225',
            'change': '+2.3%',
            'network': 'Bitcoin',
            'balance': 0.005,
          },
          {
            'symbol': 'ETH',
            'name': 'Ethereum',
            'amount': '0.15 ETH',
            'value': '\$350',
            'change': '+1.2%',
            'network': 'Ethereum',
            'balance': 0.15,
          },
        ],
        recentTransactions: demoTransactions, // NEW: Add demo transactions
      ),
    );

    // Load profile for demo data too
    add(const HomeLoadProfile());
  }

  // Refresh data
  void _onRefreshData(HomeRefreshData event, Emitter<HomeState> emit) {
    final currentWallet = state.walletAddress;
    if (currentWallet.isNotEmpty) {
      add(HomeLoadWalletData(currentWallet));
    } else {
      add(const HomeLoadData());
    }
  }

  // Helper: Convert API assets to app format
  List<Map<String, dynamic>> _convertApiAssetsToAppFormat(
    List<Map<String, dynamic>> apiAssets,
  ) {
    return apiAssets.map((asset) {
      final balance = (asset['balance'] as num?)?.toDouble() ?? 0.0;
      final price = (asset['price_usdt'] as num?)?.toDouble() ?? 0.0;
      final value = (asset['value_usdt'] as num?)?.toDouble() ?? 0.0;
      final change = price > 0
          ? ((value - (balance * price)) / (balance * price)) * 100
          : 0.0;

      return {
        'symbol': asset['symbol'] ?? 'Unknown',
        'name': asset['name'] ?? 'Unknown Asset',
        'amount': '${balance.toStringAsFixed(4)} ${asset['symbol'] ?? ''}',
        'value': '\$${value.toStringAsFixed(2)}',
        'change': '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
        'network': 'TON',
        'balance': balance,
        'price_usdt': price,
        'icon': asset['icon'],
        'contract': asset['contract'],
      };
    }).toList();
  }

  void _onLoadProfile(HomeLoadProfile event, Emitter<HomeState> emit) {
    final userProfile = {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'joinDate': '2023-01-15',
      'level': 'Gold Member',
      'avatarUrl': '',
    };

    const referralCode = 'WALLET2024';

    emit(state.copyWith(userProfile: userProfile, referralCode: referralCode));
  }

  void _onCopyReferralCode(
    HomeCopyReferralCode event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(isReferralCodeCopied: true));
  }

  void _onTabChanged(HomeTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  void _onBuyCrypto(HomeBuyCrypto event, Emitter<HomeState> emit) {}
  void _onSendCrypto(HomeSendCrypto event, Emitter<HomeState> emit) {}
  void _onReceiveCrypto(HomeReceiveCrypto event, Emitter<HomeState> emit) {}
  void _onSwapCrypto(HomeSwapCrypto event, Emitter<HomeState> emit) {}
  void _onDepositCrypto(HomeDepositCrypto event, Emitter<HomeState> emit) {}
  void _onManageCrypto(HomeManageCrypto event, Emitter<HomeState> emit) {}
  void _onReceiveNFTs(HomeReceiveNFTs event, Emitter<HomeState> emit) {}
}
