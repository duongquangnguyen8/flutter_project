import 'package:app_banhang/view_models/auth_view_models.dart';
import 'package:app_banhang/views/login_views.dart';
import 'package:app_banhang/views/otp_views.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassViews extends StatelessWidget {
  const ResetPassViews({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ResetPass(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/otp': (context) => OtpViews(),
      },
    );
  }
}

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  TextEditingController _passOld = TextEditingController();
  TextEditingController _passNew = TextEditingController();
  TextEditingController _cfPassNew = TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;
  void _togglePasswordVisbility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _togglePasswordVisbility3() {
    setState(() {
      _obscureText3 = !_obscureText3;
    });
  }

  void _resetPass() async {
    String passNew = _passNew.text;
    String cfPassNew = _cfPassNew.text;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? email = await preferences.getString('email_forgot_pass');
    if (passNew.isEmpty || cfPassNew.isEmpty) {
      Fluttertoast.showToast(msg: 'Bạn cần điền đủ thông tin');
      return;
    }
    if (passNew != cfPassNew) {
      Fluttertoast.showToast(msg: 'Mật khẩu phải giống nhau');
      return;
    }
    try {
      await Provider.of<AuthViewModels>(context, listen: false)
          .resetPass(email!, passNew);
      await preferences.remove('email_forgot_pass');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginViews()));
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
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
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/otp');
                    },
                  )),
              const Align(
                child: Text(
                  'Mật khẩu mới',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            controller: _passNew,
            obscureText: _obscureText3,
            decoration: InputDecoration(
                hintText: 'Mật khẩu mới',
                labelText: 'Mật khẩu mới',
                suffixIcon: IconButton(
                  onPressed: () {
                    _togglePasswordVisbility3();
                  },
                  icon: Icon(
                    _obscureText3 ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            controller: _cfPassNew,
            obscureText: _obscureText,
            decoration: InputDecoration(
                hintText: 'Nhập lại mật khẩu mới',
                labelText: 'Nhập lại mật khẩu mới',
                suffixIcon: IconButton(
                  onPressed: () {
                    _togglePasswordVisbility();
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () {
                _resetPass();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(500, 40),
                backgroundColor: const Color.fromARGB(255, 108, 164, 209),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Xác thực',
                style: TextStyle(fontSize: 18),
              ))
        ],
      ),
    ));
  }
}
