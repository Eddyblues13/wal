class CryptoAsset {
  final String id;
  final String name;
  final String symbol;
  final String logo;
  final String chainIcon;
  final double price;
  final double marketCap;
  final double change24h;
  final double amount;
  final double value;

  CryptoAsset({
    required this.id,
    required this.name,
    required this.symbol,
    required this.logo,
    required this.chainIcon,
    required this.price,
    required this.marketCap,
    required this.change24h,
    required this.amount,
    required this.value,
  });
}

class NFTAsset {
  final String id;
  final String name;
  final String image;
  final String collection;
  final double floorPrice;
  final double lastSalePrice;

  NFTAsset({
    required this.id,
    required this.name,
    required this.image,
    required this.collection,
    required this.floorPrice,
    required this.lastSalePrice,
  });
}
