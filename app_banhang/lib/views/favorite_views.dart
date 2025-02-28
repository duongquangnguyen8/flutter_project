import 'package:app_banhang/models/product.dart';
import 'package:app_banhang/view_models/favorite_view_models.dart';
import 'package:app_banhang/view_models/product_view_models.dart';
import 'package:app_banhang/views/login_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Favorite(),
    );
  }
}

class _Favorite extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoriteState();
}

class _FavoriteState extends State<_Favorite> {
  List<Product> _listProduct = [];
  var _isLoading = true;

  Future<void> _getFavorite() async {
    List<Product> tempProductList = [];
    try {
      await Provider.of<FavoriteViewModels>(context, listen: false)
          .getFavorite();
      List<String> listIdProduct =
          Provider.of<FavoriteViewModels>(context, listen: false).listProductId;
      if (listIdProduct != null) {
        for (var idProduct in listIdProduct) {
          await Provider.of<ProductViewModels>(context, listen: false)
              .getProductById(idProduct);
          Product? product =
              Provider.of<ProductViewModels>(context, listen: false).product;
          if (product != null) {
            tempProductList.add(product);
          }
          Provider.of<ProductViewModels>(context, listen: false).clearProduct();
        }
      }
      setState(() {
        _listProduct = tempProductList;
      });
    } catch (error) {
      print(error);
      if (error.toString().contains('Invalid token or token expired')) {
        print('đâsđa');
        showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Thông báo'),
                  content: const Text('Phiên đăng đã nhập hết hạn'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginViews()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text('OK'))
                  ],
                )).then((_) {
          Navigator.of(context).pushAndRemoveUntil(
              //xoá bỏ các route view trước
              MaterialPageRoute(builder: (context) => const LoginViews()),
              (Route<dynamic> route) => false);
        });
      }
    } finally {
      //luôn được thự hiện
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _listProduct.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 1), // Tạo viền cho Container
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        )
                      ]
                      // Bo góc viền
                      ),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                        _listProduct[index].image,
                        width: 120,
                      ),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.fromLTRB(5, 0, 20, 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _listProduct[index].productName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              '${_listProduct[index].price}đ',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                      Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text('Thông báo'),
                                          content: const Text(
                                            'Bạn có chắc chắn muốn xoá khởi danh sách yêu thích?',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();

                                                // Sử dụng await để gọi phương thức không đồng bộ
                                                await Provider.of<
                                                            FavoriteViewModels>(
                                                        context,
                                                        listen: false)
                                                    .getIdFavorite(
                                                        _listProduct[index].id);

                                                String favoriteId = Provider.of<
                                                            FavoriteViewModels>(
                                                        context,
                                                        listen: false)
                                                    .favoriteId
                                                    .toString();

                                                await Provider.of<
                                                            FavoriteViewModels>(
                                                        context,
                                                        listen: false)
                                                    .deleteFavorite(favoriteId);

                                                _getFavorite();
                                              },
                                              child: const Text(
                                                'Đồng ý',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ));
                              },
                              child: const Icon(
                                Icons.remove_circle_outline,
                                size: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.shopping_cart,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
