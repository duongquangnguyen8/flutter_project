import 'package:app_banhang/view_models/auth_view_models.dart';
import 'package:app_banhang/view_models/cart_view_models.dart';
import 'package:app_banhang/view_models/favorite_view_models.dart';
import 'package:app_banhang/view_models/product_view_models.dart';
import 'package:app_banhang/views/login_views.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthViewModels()),
          ChangeNotifierProvider(create: (_) => ProductViewModels()),
          ChangeNotifierProvider(create: (_) => FavoriteViewModels()),
          ChangeNotifierProvider(create: (_) => CartViewModels())
        ],
        child: const MaterialApp(
          home: LoginViews(),
          debugShowCheckedModeBanner: false,
        ),
      );
}
