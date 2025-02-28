class Product {
  String id;
  String productName;
  String description;
  double price;
  String image;
  String categoryId;

  Product(
      {required this.id,
      required this.productName,
      required this.description,
      required this.price,
      required this.image,
      required this.categoryId});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      productName: json['productName'],
      description: json['description'],
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'],
      image: json['image'],
      categoryId: json['categoryId'],
    );
  }

  get getId => id;

  set setId(id) => this.id = id;

  get getProductName => productName;

  set setProductName(String productName) => this.productName = productName;

  get getDescription => description;

  set setDescription(description) => this.description = description;

  get getPrice => price;

  set setPrice(price) => this.price = price;

  get getImage => image;

  set setImage(image) => this.image = image;

  get getCategoryId => categoryId;

  set setCategoryId(categoryId) => this.categoryId = categoryId;

  @override
  String toString() {
    return 'Product(id: $id, productName: $productName, description: $description, price: $price, image: $image, categoryId: $categoryId)';
  }
}
