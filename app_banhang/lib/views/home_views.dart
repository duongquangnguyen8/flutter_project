import 'package:app_banhang/models/category.dart';
import 'package:app_banhang/models/product.dart';
import 'package:app_banhang/view_models/product_view_models.dart';
import 'package:app_banhang/views/login_views.dart';
import 'package:app_banhang/views/product_detail_views.dart';
import 'package:app_banhang/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeViews extends StatelessWidget {
  const HomeViews({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Category category_life =
      Category('Sách đời sống', Image.asset('images/img_life_category.png'));
  Category category_history =
      Category('Sách lịch sử', Image.asset('images/img_history_category.png'));
  Category category_academy =
      Category('Sách học tập', Image.asset('images/img_academy_category.png'));
  List<Category> listCategory = [];
  List<Product> listProduct = [];
  int? selectedPositon = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listCategory.add(category_life);
    listCategory.add(category_history);
    listCategory.add(category_academy);
    //khi khởi tạo homeview cần call luôn
    getProducts();
  }

  void getProducts() async {
    try {
      listProduct = await Provider.of<ProductViewModels>(context, listen: false)
          .getProduct();
      setState(() {}); //cập nhật ui khi đã lấy được sản phẩm
    } catch (error) {
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
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 249, 247),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Những cuốn sách \nhay nhất dành cho bạn,',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                            decoration: InputDecoration(
                          hintText: 'Tìm kiếm',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          suffixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                        )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listCategory.length,
                            itemBuilder: (context, positon) {
                              return Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedPositon = positon;
                                        listProduct.length;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: selectedPositon == positon
                                                ? Colors.green
                                                : const Color.fromARGB(
                                                        255, 171, 207, 162)
                                                    .withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          )
                                        ],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30)),
                                        border: Border.all(width: 1),
                                      ),
                                      child: Row(
                                        children: [
                                          listCategory[positon].image,
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(listCategory[positon]
                                              .categoryName),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      listProduct.isNotEmpty
                          ? GridView.builder(
                              itemCount: listProduct.length,
                              shrinkWrap:
                                  true, //chiếm diện tích đủ để hiển thị tránh lãng phí
                              physics:
                                  const NeverScrollableScrollPhysics(), //vô hiệu hoá khả năng cuộn của gridview
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                // childAspectRatio:
                                //     2 / 2, //chiều rộng và chiều cao
                                crossAxisSpacing: 10, //khoảng cách giữa cột
                                mainAxisSpacing: 10, //khoảng cách giữa các hàng
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: GestureDetector(
                                      onTap: () {
                                        //rootNavigator là đè lên thằng chứa homeview
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailViews(
                                                      product:
                                                          listProduct[index],
                                                    )));
                                      },
                                      child: Stack(
                                        children: [
                                          Card(
                                              child: SizedBox(
                                            height: 200,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.network(
                                                  listProduct[index].image,
                                                  fit: BoxFit.contain,
                                                  width: double.infinity,
                                                  height: 120,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      listProduct[index]
                                                          .productName,
                                                      overflow: TextOverflow
                                                          .ellipsis, //chuyển sang 3 chấm
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '${listProduct[index].price}đ',
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                        ],
                                      )),
                                );
                              })
                          : const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
