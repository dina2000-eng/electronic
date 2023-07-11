class UploadProductModel {
  final String name;
  final String description;
  final double price;
  final int inStock; // Changed to int for quantity
  final int categoryId;

  UploadProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.inStock,
    required this.categoryId,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price.toString(),
      'instock': inStock.toString(), // Convert int to string
      'category_id': categoryId.toString(),
    };
  }
}
