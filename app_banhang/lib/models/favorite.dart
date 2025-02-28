class FavoriteModel {
  String id;
  String userId;
  String productId;

  //constructor
  FavoriteModel(
      {required this.id, required this.userId, required this.productId});
  FavoriteModel.withIdUserAndProduct(
      {this.id = '', required this.userId, required this.productId});
//convert json sang object
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
        id: json['_id'], userId: json['userId'], productId: json['productId']);
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'productId': productId,
    };
  }

  String get getId => this.id;

  set setId(String id) => this.id = id;

  get getUserId => this.userId;

  set setUserId(userId) => this.userId = userId;

  get getProductId => this.productId;

  set setProductId(productId) => this.productId = productId;
}
