import 'package:wal/common/entities/wallet.dart';

class WalletService {
  static Future<List<CryptoAsset>> getTrendingAssets() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return [
      CryptoAsset(
        id: '1',
        name: 'ZK',
        symbol: 'ZK',
        logo: 'assets/images/zk.png',
        chainIcon: 'assets/images/bnb.png',
        price: 2.00,
        marketCap: 5260000000,
        change24h: -0.00,
        amount: 0,
        value: 0,
      ),
      CryptoAsset(
        id: '2',
        name: 'KOGE',
        symbol: 'KOGE',
        logo: 'assets/images/koge.png',
        chainIcon: 'assets/images/bnb.png',
        price: 0.50,
        marketCap: 333460000,
        change24h: -1.20,
        amount: 0,
        value: 0,
      ),
      CryptoAsset(
        id: '3',
        name: 'ETH',
        symbol: 'ETH',
        logo: 'assets/images/eth.png',
        chainIcon: 'assets/images/eth_chain.png',
        price: 3500.00,
        marketCap: 490000000000,
        change24h: 1.23,
        amount: 0,
        value: 0,
      ),
    ];
  }

  static Future<List<CryptoAsset>> getUserCryptoAssets() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return [
      CryptoAsset(
        id: '4',
        name: 'Bitcoin',
        symbol: 'BTC',
        logo: 'assets/images/btc.png',
        chainIcon: 'assets/images/btc_chain.png',
        price: 45000.00,
        marketCap: 880000000000,
        change24h: 2.15,
        amount: 0.25,
        value: 11250.00,
      ),
      CryptoAsset(
        id: '5',
        name: 'Ethereum',
        symbol: 'ETH',
        logo: 'assets/images/eth.png',
        chainIcon: 'assets/images/eth_chain.png',
        price: 3500.00,
        marketCap: 490000000000,
        change24h: 1.23,
        amount: 2.5,
        value: 8750.00,
      ),
    ];
  }

  static Future<List<NFTAsset>> getUserNFTs() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return [
      NFTAsset(
        id: '1',
        name: 'Bored Ape #1234',
        image: 'assets/images/bayc.png',
        collection: 'Bored Ape Yacht Club',
        floorPrice: 85.25,
        lastSalePrice: 92.50,
      ),
      NFTAsset(
        id: '2',
        name: 'CryptoPunk #5678',
        image: 'assets/images/cryptopunk.png',
        collection: 'CryptoPunks',
        floorPrice: 120.75,
        lastSalePrice: 135.00,
      ),
    ];
  }
}
