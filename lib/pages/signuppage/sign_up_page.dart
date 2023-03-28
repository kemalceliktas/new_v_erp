import 'package:erp_project/errorMesages/error_messages.dart';
import 'package:erp_project/pages/signuppage/widgets/user_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/provider1/provider_one.dart';
import '../loginpage/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }

  static const double paddingMain = 20.00;
  static const Duration messageDuration = Duration(seconds: 2);
  static const String messagePassword = "Şifre 5 haneden küçük olamaz";
  static const String messageMain =
      "İsim, Mail ve Şifre alanları boş bırakılamaz";
  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProviderOne>();
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: paddingMain),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserFormWidget(
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty) {
                      if (_passwordController.text.length < 5) {
                        ScaffoldMessenger.of(context).showSnackBar(Messages()
                            .error(
                                duration: messageDuration,
                                message: messagePassword,
                                context: context));

                        return;
                      }
                      context.read<ProviderOne>().registerUser(
                          context: context,
                          user: User(
                            name: _nameController.text,
                            email: _emailController.text,
                            isAdmin: false,
                            password: _passwordController.text,
                          ));

                      _emailController.clear();
                      _nameController.clear();
                      _passwordController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(Messages()
                          .error(
                              duration: messageDuration,
                              message: messageMain,
                              context: context));
                      return;
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: !provider.isLoading
                          ? Text(
                              "Register",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.white),
                            )
                          : const CircularProgressIndicator(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage()));
                  },
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Login",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
