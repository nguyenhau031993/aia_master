class AssetItem {
  final String id;
  final String name;
  final String type; // 'cash', 'stock', 'crypto', 'gold'
  double amount; // Số lượng (VD: 1000 CP)
  double currentPrice; // Giá thị trường hiện tại
  final String icon;

  AssetItem({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.currentPrice,
    required this.icon,
  });

  // Tính tổng giá trị tài sản = Số lượng * Giá
  double get totalValue => amount * currentPrice;
}
