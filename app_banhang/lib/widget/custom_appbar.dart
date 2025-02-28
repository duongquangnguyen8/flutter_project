import 'package:app_banhang/views/cart_views.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'images/icon_homee.png',
          width: 30,
          height: 30,
        ),
        const Text(
          'Bán sách',
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () => {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CartViews()))
          },
          child: const Icon(
            Icons.shopping_cart,
            size: 30,
          ),
        )
      ],
    );
  }
}
