import 'package:app_banhang/view_models/auth_view_models.dart';
import 'package:app_banhang/views/forgot_pass_views.dart';
import 'package:app_banhang/views/reset_pass_views.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OTPInput(),
      debugShowCheckedModeBanner: false,
      routes: {'/forgot_password': (context) => const ForgotPassView()},
    );
  }
}

class OTPInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OTPState();
}

class _OTPState extends State<OTPInput> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode()); // để quản lí focus của 6 ô

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _verifiOtp() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? email = preferences.getString('email_forgot_pass');
    String otp = _otpControllers.map((controller) => controller.text).join();
    //sử dụng map và join để lấy
    //nó là vòng lặp thôi mỗi vòng lấy ra một phần từ và join để gộp thành chuỗi
    if (otp.isEmpty) {
      Fluttertoast.showToast(msg: 'Bạn chưa nhập otp');
    }
    try {
      await Provider.of<AuthViewModels>(context, listen: false)
          .verifyOTP(email!, otp);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ResetPassViews()));
    } catch (error) {
      if (error.toString().contains('Otp has expired or Invalid')) {
        Fluttertoast.showToast(msg: 'Otp sai hoặc hết hạn');
      }
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
                          Navigator.of(context).pushNamed('/forgot_password');
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 30,
                        ),
                      )),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Xác thực OTP',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _otpFocusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1) {
                          //đảm bảo ô nhập không bị trống
                          if (index < 5) {
                            //ô nhập cuối
                            FocusScope.of(context)
                                .requestFocus(_otpFocusNodes[index + 1]);
                          } else {
                            //đóng focus
                            _otpFocusNodes[index].unfocus();
                          }
                        } else if (value.isEmpty && index > 0) {
                          //xoá bỏ thì quay lại focus-1
                          FocusScope.of(context)
                              .requestFocus(_otpFocusNodes[index - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () {
                    _verifiOtp();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(500, 40),
                    backgroundColor: const Color.fromARGB(255, 108, 164, 209),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Nhập OTP',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
