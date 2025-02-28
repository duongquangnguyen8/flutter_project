import 'package:app_banhang/view_models/auth_view_models.dart';
import 'package:app_banhang/views/forgot_pass_views.dart';
import 'package:app_banhang/views/home_views.dart';
import 'package:app_banhang/views/nav_bar_views.dart';
import 'package:app_banhang/views/register_views.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginViews extends StatefulWidget {
  const LoginViews({super.key});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginViews> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscureText = true;
  void _togglePasswordVisbility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Lỗi đăng nhập'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'))
              ],
            ));
  }

  void _login() async {
    print('login');
    String email = _emailController.text;
    String pass = _passController.text;
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _showErrorDialog('Vui lòng nhập email hợp lệ');
    } else if (pass.isEmpty || pass.length < 6) {
      _showErrorDialog('Mật khẩu tối thiếu phải có 6 kí tự');
    } else {
      try {
        await Provider.of<AuthViewModels>(context, listen: false)
            .login(email, pass);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NavBarViews()));
      } catch (error) {
        if (error.toString().contains('Invalid credentials')) {
          _showErrorDialog('Tài khoản hoặc mật khẩu sai');
        }
        print('lỗi: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 245, 245, 248),
        child: Center(
          // Thêm Center để căn giữa nội dung
          child: Padding(
            // Thêm Padding để có khoảng cách hợp lý
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Image.asset('images/img_logo.png'),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Nhập email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Thay đổi khoảng cách thành 16
                TextField(
                  controller: _passController, // Thêm TextField cho mật khẩu
                  decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _togglePasswordVisbility();
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ))),
                  obscureText: _obscureText,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ForgotPassView()));
                      },
                      child: const Text(
                        'Quên mật khẩu',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    _login();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(500, 50),
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                  child: const Text('Đăng nhập'),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => const RegisterViews()));
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(500, 50),
                        backgroundColor:
                            const Color.fromARGB(255, 211, 208, 208),
                        textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                    child: const Text('Đăng kí')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
