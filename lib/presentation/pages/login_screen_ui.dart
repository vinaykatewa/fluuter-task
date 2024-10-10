import 'package:fltask/services/login_service_and_firebase.dart';
import 'package:fltask/presentation/pages/scheme_viewing_screen.dart';
import 'package:flutter/material.dart';
import 'package:fltask/presentation/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String associate = '';
  String email = '';
  String password = '';
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          'Log in Now',
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 11, 72, 122)),
                        ),
                        SizedBox(height: 15.h),
                        Text('Please login to continue using our app'),
                        SizedBox(height: 40.h),
                        CustomTextField(
                          labelText: 'Associate',
                          readOnly: true,
                          onSaved: (value) => associate = value ?? '',
                        ),
                        SizedBox(height: 30.h),
                        CustomTextField(
                          labelText: 'Email',
                          onSaved: (value) => email = value ?? '',
                        ),
                        SizedBox(height: 30.h),
                        CustomTextField(
                          labelText: 'Password',
                          obscureText: true,
                          suffixIcon: Icon(Icons.visibility),
                          onSaved: (value) => password = value ?? '',
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            Text('Remember Me',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 11, 72, 122))),
                            Spacer(),
                            Text('Forgot Password?',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 11, 72, 122))),
                          ],
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: _submitForm,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 11, 72, 122),
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              ' Sign Up',
                              style: TextStyle(
                                color: Color.fromARGB(255, 11, 72, 122),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String trimmedEmail = email.trim();
      try {
        final response = await AuthService.login(trimmedEmail, password);
        FirebaseApi()
            .sendPushNotification('Welcome back', response['message'] ?? '');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SchemeViewingScreen(
                    token: response['token'] ?? '',
                  )),
        );
      } catch (e) {
        print('Login failed: $e');
      }
    }
  }
}
