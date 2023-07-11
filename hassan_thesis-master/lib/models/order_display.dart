class OrderDisplayModel {
  final int id;
  final double totalPrice;
  final String address;
  final String createdAt;
  final List<ProductOrderDisplay> products;

  OrderDisplayModel(
      this.id, this.totalPrice, this.address, this.createdAt, this.products);
}

class ProductOrderDisplay {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String? priceOfSellingProduct;
  final int quantityOfProduct;

  ProductOrderDisplay(this.id, this.name, this.description, this.price,
      this.image, this.quantityOfProduct, this.priceOfSellingProduct);
}
