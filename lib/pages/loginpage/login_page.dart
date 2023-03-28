import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../errorMesages/error_messages.dart';
import '../../providers/provider1/provider_one.dart';
import '../mainPage/main_page.dart';
import '../signuppage/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LoginFormWidget(
                nameController: _nameController,
                passwordController: _passwordController,
              ),
              ElevatedButton(
                onPressed: () async {
                  context.read<ProviderOne>().loginUser(
                      name: _nameController.text,
                      password: _passwordController.text,
                      context: context);
                  context.read<ProviderOne>().isLogin
                      ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainPage()),
                        )
                      : null;
                  _nameController.clear();
                  _passwordController.clear();
                },
                child:  Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Login",style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),),
                )),
              ),
              TextButton(
                onPressed: () {
                  _nameController.clear();
                  _passwordController.clear();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child:  Center(child: Text("Sign up",style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.blue),)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  final TextEditingController nameController;

  final TextEditingController passwordController;
  const LoginFormWidget(
      {super.key,
      required this.nameController,
      required this.passwordController});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            onChanged: (value) {
              if (value.length >= 20) {
                ScaffoldMessenger.of(context).showSnackBar(
                  Messages().error(
                      context: context,
                      duration: const Duration(seconds: 3),
                      message: "Name uzunluğu uygun değil"),
                );
              }
            },
            maxLength: 20,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Name",
                counterText: ""),
            controller: widget.nameController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            maxLength: 20,
            onChanged: (value) {
              if (value.length >= 20) {
                ScaffoldMessenger.of(context).showSnackBar(
                  Messages().error(
                      context: context,
                      duration: const Duration(seconds: 3),
                      message: "Password uzunluğu uygun değil"),
                );
              }
            },
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password",
                counterText: ""),
            keyboardType: TextInputType.text,
            obscureText: true,
            controller: widget.passwordController,
          ),
        ),
      ],
    );
  }
}
