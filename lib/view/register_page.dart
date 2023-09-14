import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toni_case_study/extension.dart';

import '../view_model/firebase_auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  bool isVisibility = false;
  @override
  Widget build(BuildContext context) {
    final firebaseAuthServices =
        Provider.of<FirebaseAuthServices>(context, listen: false);
    return Scaffold(
      appBar: registerPageAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: context.height * 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      emailField(),
                      SizedBox(height: context.height * 0.015),
                      passwordField(),
                      SizedBox(height: context.height * 0.015),
                      confirmPasswordField(),
                      SizedBox(height: context.height * 0.02),
                      registerButton(context, firebaseAuthServices),
                      navigateLoginPageButton(context)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextButton navigateLoginPageButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          "Zaten bir hesabın var mı? Giriş yap",
          style: TextStyle(color: myPrimaryColor),
        ));
  }

  SizedBox registerButton(
      BuildContext context, FirebaseAuthServices firebaseAuthServices) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 45,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: myPrimaryColor, shape: const StadiumBorder()),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    "Lütfen alanlarınızı kontrol edin!",
                    style: TextStyle(color: Colors.white),
                  )));
              return;
            }
            firebaseAuthServices
                .createEmailAndPassword(
              context,
              _emailController.text.trim(),
              _passwordController.text.trim(),
            )
                .then((value) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: myPrimaryColor,
                  content: Text(
                    "Tebrikler hesabınız başarı ile oluşturuldu",
                    style: TextStyle(color: Colors.white),
                  )));
            });
          },
          child: const Text(
            "Kayıt yap",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
    );
  }

  TextFormField confirmPasswordField() {
    return TextFormField(
      obscureText: !isVisibility,
      obscuringCharacter: "*",
      validator: (value) {
        if (value!.isEmpty || value.length < 6) {
          return "Şifre en az 6 karakter olmalıdır";
        }
        if (_passwordController.text != value) {
          return "Lütfen aynı şifreyi girin";
        }
        return null;
      },
      controller: _passwordController2,
      decoration: InputDecoration(
          hintText: "Şifrenizi tekrar giriniz",
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          prefixIcon: const Icon(
            Icons.lock,
            color: myPrimaryColor,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: myPrimaryColor,
                width: 2,
              )),
          suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  isVisibility = !isVisibility;
                });
              },
              child: Icon(
                isVisibility == true ? Icons.visibility : Icons.visibility_off,
                color: myPrimaryColor,
              ))),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      obscureText: !isVisibility,
      obscuringCharacter: "*",
      validator: (value) {
        if (value!.isEmpty || value.length < 6) {
          return "Şifre en az 6 karakter olmalıdır";
        }
        if (_passwordController2.text != value) {
          return "Lütfen aynı şifreyi girin";
        }
        return null;
      },
      controller: _passwordController,
      decoration: InputDecoration(
          hintText: "Şifrenizi giriniz",
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          prefixIcon: const Icon(
            Icons.lock,
            color: myPrimaryColor,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: myPrimaryColor,
                width: 2,
              )),
          suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  isVisibility = !isVisibility;
                });
              },
              child: Icon(
                isVisibility == true ? Icons.visibility : Icons.visibility_off,
                color: myPrimaryColor,
              ))),
    );
  }

  TextFormField emailField() {
    return TextFormField(
      validator: (value) {
        final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value.toString());
        return !emailValid ? "Geçerli bir email giriniz" : null;
      },
      controller: _emailController,
      decoration: InputDecoration(
        hintText: "Email giriniz",
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        prefixIcon: const Icon(Icons.email, color: myPrimaryColor),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: myPrimaryColor,
              width: 2,
            )),
      ),
    );
  }

  AppBar registerPageAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: myPrimaryColor,
      title: const Text(
        "Hesap oluştur",
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}

const Color myPrimaryColor = Colors.teal;
