import 'package:app_banhang/models/user.dart';
import 'package:app_banhang/view_models/auth_view_models.dart';
import 'package:app_banhang/views/login_views.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RegisterViews extends StatelessWidget {
  const RegisterViews({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Register(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginViews(),
      },
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cfPassController = TextEditingController();
  bool checkPass = true;
  bool checkPass2 = true;
  void toggolePass() {
    setState(() {
      checkPass = !checkPass;
    });
  }

  void toggolePass2() {
    setState(() {
      checkPass2 = !checkPass2;
    });
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

  void _register() async {
    String email = _emailController.text;
    String pass = _passController.text;
    String cfPass = _cfPassController.text;

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _showErrorDialog('Vui lòng nhập email hợp lệ');
    } else if (pass.isEmpty || pass.length < 6) {
      _showErrorDialog('Mật khẩu tối thiếu phải có 6 kí tự');
    } else if (cfPass.isEmpty || pass != cfPass) {
      _showErrorDialog('Mật khẩu phải giống nhau');
    } else {
      try {
        UserModel user = new UserModel.withEmailAndPass(
            email: email, password: pass, role: 'user');
        await Provider.of<AuthViewModels>(context, listen: false)
            .register(user);
        Fluttertoast.showToast(msg: 'Đăng ký thành công');
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed('/login');
      } catch (error) {
        if (error.toString().contains('Email is already exists')) {
          _showErrorDialog(
              'Tài khoản đã tồn tại vui lòng đăng ký bằng tài khoản khác!');
        } else {
          print('Lỗi ${error}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Đăng ký',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                obscureText: checkPass,
                controller: _passController,
                decoration: InputDecoration(
                    hintText: 'Mật khẩu',
                    labelText: 'Mật khẩu',
                    suffixIcon: IconButton(
                      onPressed: () {
                        toggolePass();
                      },
                      icon: Icon(
                        checkPass
                            ? Icons.visibility
                            : Icons.visibility_off_sharp,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                obscureText: checkPass2,
                controller: _cfPassController,
                decoration: InputDecoration(
                    hintText: 'Nhập lại mật khẩu',
                    labelText: 'Nhập lại mật khẩu',
                    suffixIcon: IconButton(
                      onPressed: () {
                        toggolePass2();
                      },
                      icon: Icon(
                        checkPass2
                            ? Icons.visibility
                            : Icons.visibility_off_sharp,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  _register();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(500, 50)),
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 162, 163, 163),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(500, 50)),
                child: const Text(
                  'Trở về',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
