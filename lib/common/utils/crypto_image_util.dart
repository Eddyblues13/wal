// lib/common/utils/crypto_image_util.dart
class CryptoImageUtil {
  // Get crypto image URL from CoinGecko API
  // CoinGecko provides free API for crypto images
  static String getCryptoImageUrl(String symbol) {
    // Map symbols to CoinGecko IDs
    final symbolToId = {
      'BTC': 'bitcoin',
      'ETH': 'ethereum',
      'TON': 'the-open-network',
      'USDT': 'tether',
      'USDC': 'usd-coin',
      'STARCOIN': 'starcoin',
      'STAR': 'starcoin',
      'BNB': 'binancecoin',
      'SOL': 'solana',
      'ADA': 'cardano',
      'DOT': 'polkadot',
      'DOGE': 'dogecoin',
      'XRP': 'ripple',
      'MATIC': 'matic-network',
      'LTC': 'litecoin',
      'TRX': 'tron',
      'AVAX': 'avalanche-2',
      'LINK': 'chainlink',
      'UNI': 'uniswap',
    };

    // Get CoinGecko ID or use symbol in lowercase
    final coinId = symbolToId[symbol.toUpperCase()] ?? symbol.toLowerCase();

    // Return CoinGecko image URL
    return 'https://assets.coingecko.com/coins/images/${_getCoinGeckoImageId(coinId)}/large/${coinId}.png';
  }

  // Alternative: Use simpler URL format that works for most coins
  static String getCryptoImageUrlSimple(String symbol) {
    // Map common symbols to their image URLs
    final symbolToUrl = {
      'TON': 'https://assets.coingecko.com/coins/images/17980/large/ton_symbol.png',
      'USDT': 'https://assets.coingecko.com/coins/images/325/large/Tether.png',
      'STARCOIN': 'https://assets.coingecko.com/coins/images/17980/large/ton_symbol.png', // Using TON as placeholder
      'STAR': 'https://assets.coingecko.com/coins/images/17980/large/ton_symbol.png', // Using TON as placeholder
      'BTC': 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      'ETH': 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
    };

    // Return mapped URL or generic crypto icon
    return symbolToUrl[symbol.toUpperCase()] ?? 
           'https://assets.coingecko.com/coins/images/1/large/bitcoin.png'; // Default to Bitcoin
  }

  // Helper to get CoinGecko image ID (simplified - using direct URLs instead)
  static int _getCoinGeckoImageId(String coinId) {
    // This is a simplified approach - in production, you'd want to cache these IDs
    // For now, we'll use the simpler URL format
    return 1; // Placeholder
  }

  // Get image URL - main method to use
  static String getImageUrl(String symbol, {String? customUrl}) {
    // If custom URL is provided and valid, use it
    if (customUrl != null && 
        customUrl.isNotEmpty && 
        (customUrl.startsWith('http://') || customUrl.startsWith('https://'))) {
      return customUrl;
    }

    // Otherwise, use CoinGecko
    return getCryptoImageUrlSimple(symbol);
  }
}

