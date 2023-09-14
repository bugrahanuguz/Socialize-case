import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toni_case_study/extension.dart';
import 'package:toni_case_study/view/register_page.dart';
import '../view_model/firebase_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisibility = false;
  @override
  Widget build(BuildContext context) {
    final _firebaseCostumeAuthServices =
        Provider.of<FirebaseAuthServices>(context, listen: false);
    return Scaffold(
      appBar: loginPageAppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    emailTextField(),
                    SizedBox(height: context.height * 0.015),
                    passwordTextField(),
                    SizedBox(height: context.height * 0.02),
                    loginButton(context, _firebaseCostumeAuthServices),
                    const SizedBox(height: 12),
                    registerButton(context)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextButton registerButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RegisterPage()));
        },
        child: const Text(
          "Hesabın yok mu? Kayıt ol",
          style: TextStyle(color: myPrimaryColor),
        ));
  }

  SizedBox loginButton(
      BuildContext context, FirebaseAuthServices _firebaseCostumeAuthServices) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 45,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: myPrimaryColor, shape: const StadiumBorder()),
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    "Lütfen alanlarınızı kontrol edin!",
                    style: TextStyle(color: Colors.white),
                  )));
              return;
            }
            _firebaseCostumeAuthServices.signInWithEmailAndPassword(
                context, _emailController.text, _passwordController.text);
          },
          child: const Text(
            "Giriş yap",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      obscureText: !isVisibility,
      obscuringCharacter: "*",
      validator: (value) {
        if (value!.length < 6) {
          return 'Şifreniz en az 6 karakter olmalıdır';
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

  TextFormField emailTextField() {
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

  AppBar loginPageAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: myPrimaryColor,
      title: const Text(
        "Giriş Yap",
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}

const Color myPrimaryColor = Colors.teal;
