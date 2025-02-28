import 'package:app_banhang/models/favorite.dart';
import 'package:app_banhang/models/product.dart';
import 'package:app_banhang/view_models/cart_view_models.dart';
import 'package:app_banhang/view_models/favorite_view_models.dart';
import 'package:app_banhang/views/login_views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailViews extends StatelessWidget {
  final Product product;
  ProductDetailViews({required this.product});

  Widget build(BuildContext context) {
    return Scaffold(
      body: _ProductDetail(
        product: product,
      ),
    );
  }
}

class _ProductDetail extends StatefulWidget {
  final Product product;
  _ProductDetail({required this.product});

  @override
  State<StatefulWidget> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<_ProductDetail> {
  var _quantity = 1;
  var _setFavorite = false;
  void _increaseQuality() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuality() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addFavorite() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? idUser = preferences.getString('idUser');
    if (idUser != null) {
      try {
        FavoriteModel favoriteModel = new FavoriteModel(
            id: '', userId: idUser, productId: widget.product.id);
        await Provider.of<FavoriteViewModels>(context, listen: false)
            .postFavorite(favoriteModel);
        print('success');
      } catch (error) {
        print(error);
      }
    } else {
      print('idUser null');
    }
  }

  void _deleteFavorite() async {
    try {
      var idFavorite = Provider.of<FavoriteViewModels>(context, listen: false)
          .favorite!
          .getId;
      await Provider.of<FavoriteViewModels>(context, listen: false)
          .deleteFavorite(idFavorite);
      print('delete success');
    } catch (error) {
      print(error);
    }
  }

  void _setStateFavorite(bool isFavorite) {
    setState(() {
      _setFavorite = isFavorite; //cập nhật gtri mới
    });
  }

  void _checkStateFavorite() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? idUser = preferences.getString('idUser');
    if (idUser != null) {
      try {
        await Provider.of<FavoriteViewModels>(context, listen: false)
            .checkStateFavorite(widget.product.id, idUser, _setStateFavorite);
      } catch (error) {
        if (error.toString().contains('Invalid token or token expired')) {
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
        print(error);
      }
    } else {
      print('idUser null');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkStateFavorite();
  }

  @override
  Widget build(BuildContext context) {
    var priceProduct;
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Container(
            height: 400,
            decoration: const BoxDecoration(
              color: Color.fromARGB(
                  255, 138, 13, 81), // Đặt màu trong BoxDecoration
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 202, 187, 187),
                      ),
                      child: GestureDetector(
                        child: const Icon(Icons.arrow_back),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () => {
                                setState(() {
                                  _setFavorite = !_setFavorite;
                                  try {
                                    if (_setFavorite) {
                                      _addFavorite();
                                    } else {
                                      _deleteFavorite();
                                    }
                                  } catch (error) {
                                    print(error);
                                  }
                                })
                              },
                          child: _setFavorite
                              ? const Icon(
                                  Icons.favorite,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  size: 30,
                                ))),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.product.productName,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.product.price}đ',
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _increaseQuality,
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(10, 30),
                                  backgroundColor:
                                      const Color.fromARGB(255, 151, 201, 153)),
                              child: const Icon(Icons.add),
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 23),
                            ),
                            ElevatedButton(
                              onPressed: _decreaseQuality,
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(10, 30),
                                  backgroundColor:
                                      const Color.fromARGB(255, 151, 201, 153)),
                              child: const Icon(Icons.remove),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Mô tả',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.product.description,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async => {
                priceProduct = widget.product.getPrice * _quantity.toInt(),
                await Provider.of<CartViewModels>(context, listen: false)
                    .addCart(widget.product.getId, _quantity, priceProduct),
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 27, 143, 252),
                  minimumSize: const Size(400, 50)),
              child: const Text(
                'Thêm vào giỏ hàng',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
