// home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/apis/home_api.dart';
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
        // Use default data immediately
        _loadDefaultData(emit);
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
      // Load default data on error
      _loadDefaultData(emit);
    }
  }

  void _onLoadWalletData(
    HomeLoadWalletData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      print('💰 HomeBloc - Fetching home data from API...');

      // Use HomeAPI which handles errors and returns default data
      final homeData = await HomeAPI.getHomeData(event.walletAddress);

      // Extract data from response
      final balance = (homeData['balance'] as num?)?.toDouble() ?? 0.0;
      final portfolioValue = (homeData['portfolioValue'] as num?)?.toDouble() ?? 0.0;
      final portfolioChange = (homeData['portfolioChange'] as num?)?.toDouble() ?? 0.0;
      final cryptoAssets = (homeData['cryptoAssets'] as List?)
          ?.cast<Map<String, dynamic>>() ?? [];
      final recentTransactions = (homeData['recentTransactions'] as List?)
          ?.cast<Map<String, dynamic>>() ?? [];
      final userProfile = homeData['userProfile'] as Map<String, dynamic>?;
      final referralCode = homeData['referralCode']?.toString() ?? '';

      emit(
        state.copyWith(
          isLoading: false,
          balance: balance,
          portfolioValue: portfolioValue,
          portfolioChange: portfolioChange,
          cryptoAssets: cryptoAssets,
          recentTransactions: recentTransactions,
          userProfile: userProfile,
          referralCode: referralCode,
          apiError: '',
        ),
      );

      print(
        '✅ Home data loaded: \$$balance, ${cryptoAssets.length} assets, ${recentTransactions.length} recent transactions',
      );
    } catch (e) {
      print('❌ HomeBloc - Error in _onLoadWalletData: $e');
      // Load default data on error
      _loadDefaultData(emit);
    }
  }

  void _loadDefaultData(Emitter<HomeState> emit) {
    print('📋 HomeBloc - Loading default data');
    
    final defaultData = HomeAPI.getHomeData("default");
    
    defaultData.then((homeData) {
      final balance = (homeData['balance'] as num?)?.toDouble() ?? 0.0;
      final portfolioValue = (homeData['portfolioValue'] as num?)?.toDouble() ?? 0.0;
      final portfolioChange = (homeData['portfolioChange'] as num?)?.toDouble() ?? 0.0;
      final cryptoAssets = (homeData['cryptoAssets'] as List?)
          ?.cast<Map<String, dynamic>>() ?? [];
      final recentTransactions = (homeData['recentTransactions'] as List?)
          ?.cast<Map<String, dynamic>>() ?? [];
      final userProfile = homeData['userProfile'] as Map<String, dynamic>?;
      final referralCode = homeData['referralCode']?.toString() ?? '';

      emit(
        state.copyWith(
          isLoading: false,
          balance: balance,
          portfolioValue: portfolioValue,
          portfolioChange: portfolioChange,
          cryptoAssets: cryptoAssets,
          recentTransactions: recentTransactions,
          userProfile: userProfile,
          referralCode: referralCode,
          apiError: '',
        ),
      );
    }).catchError((e) {
      print('❌ Error loading default data: $e');
      emit(
        state.copyWith(
          isLoading: false,
          apiError: 'Failed to load data',
        ),
      );
    });
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

  void _onLoadProfile(HomeLoadProfile event, Emitter<HomeState> emit) {
    // Profile is already loaded with home data
    // This is kept for backward compatibility
  }

  void _onCopyReferralCode(
    HomeCopyReferralCode event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(isReferralCodeCopied: true));
    
    // Reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (!isClosed) {
        emit(state.copyWith(isReferralCodeCopied: false));
      }
    });
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
