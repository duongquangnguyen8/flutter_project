import 'package:app_banhang/models/product.dart';
import 'package:app_banhang/view_models/cart_view_models.dart';
import 'package:app_banhang/view_models/product_view_models.dart';
import 'package:app_banhang/views/nav_bar_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Cart(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CartState();
}

class _CartState extends State<_Cart> {
  List<dynamic> _listIDProduct = [];
  List<dynamic> _listProduct = [];
  List<dynamic> _quantities = [];
  dynamic _totalPrice = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCart();
  }

  Future<void> _getCart() async {
    _listIDProduct.clear();
    _listProduct.clear();
    _quantities.clear();

    await Provider.of<CartViewModels>(context, listen: false).getCartByUserId();
    _listIDProduct =
        await Provider.of<CartViewModels>(context, listen: false).listProduct;
    _quantities = await Provider.of<CartViewModels>(context, listen: false)
        .listQuantities;
    _totalPrice = await Provider.of<CartViewModels>(context, listen: false)
        .priceProductCart;
    for (var item in _listIDProduct) {
      await Provider.of<ProductViewModels>(context, listen: false)
          .getProductById(item);
      Product? product =
          await Provider.of<ProductViewModels>(context, listen: false).product;

      if (product != null) {
        _listProduct.add(product);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _updateTotalPrice() {
    dynamic newTotal = 0;
    for (int i = 0; i < _listProduct.length; i++) {
      newTotal += _listProduct[i].price * _quantities[i];
    }
    setState(() {
      _totalPrice = newTotal;
    });
  }

  void _increaseQuantity(int index) {
    setState(() {
      _quantities[index]++;
      _updateTotalPrice();
    });
  }

  void _decreaseQuantity(int index) {
    if (_quantities[index] > 1) {
      setState(() {
        _quantities[index]--;
        _updateTotalPrice();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NavBarViews()));
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Center(
          child: Text(
            'Giỏ hàng',
            style: TextStyle(fontSize: 23),
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _listProduct.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Image.network(
                                  _listProduct[index].getImage,
                                  width: 100,
                                  height: 100,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                _increaseQuantity(index),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(10, 10),
                                              backgroundColor: Color.fromARGB(
                                                  255, 151, 201, 153),
                                            ),
                                            child: const Icon(Icons.add),
                                          ),
                                          Text(
                                            _quantities[index].toString(),
                                            style:
                                                const TextStyle(fontSize: 23),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                _decreaseQuantity(index),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(10, 10),
                                              backgroundColor: Color.fromARGB(
                                                  255, 151, 201, 153),
                                            ),
                                            child: const Icon(Icons.remove),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text(
                                                  'Thông báo',
                                                  textAlign: TextAlign.center,
                                                ),
                                                content: const Text(
                                                  'Bạn muốn xoá sản phẩm khỏi giỏ hàng?',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Không')),
                                                  TextButton(
                                                      onPressed: () {},
                                                      child:
                                                          const Text('Đồng ý'))
                                                ],
                                              ));
                                    },
                                    child: const Icon(
                                      Icons.remove_circle_outline,
                                      size: 30,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Opacity(
                                opacity: 0.7,
                                child: Text(
                                  'Tổng',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Text(
                                '$_totalPriceđ',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 63, 122, 233)),
                              child: const Text(
                                'Đặt hàng',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
