import 'package:app_banhang/view_models/auth_view_models.dart';
import 'package:app_banhang/views/login_views.dart';
import 'package:app_banhang/views/otp_views.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassView extends StatelessWidget {
  const ForgotPassView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ForgotPassword(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginViews(),
      },
    );
  }
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _txtEmail = TextEditingController();

  void _sendOtp() async {
    String email = _txtEmail.text;
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: 'Vui lòng nhập email');
      return;
    }
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await Provider.of<AuthViewModels>(context, listen: false)
          .forgotPassword(email);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => OtpViews()));
      await preferences.setString('email_forgot_pass', email);
    } catch (e) {
      if (e.toString().contains('Not found or exists')) {
        Fluttertoast.showToast(msg: 'Email không tồn tại hoặc sai định dạng');
      } else {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Quên mật khẩu',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _txtEmail,
                decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Nhập địa chỉ email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    _sendOtp();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(500, 40),
                    backgroundColor: const Color.fromARGB(255, 108, 164, 209),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Gửi OTP',
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
