import 'package:flutter/material.dart';

import '../../../errorMesages/error_messages.dart';

class UserFormWidget extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const UserFormWidget({super.key, required this.nameController, required this.emailController, required this.passwordController});

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children:  [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            onChanged: (value) {
              if (value.length>=20) {
                ScaffoldMessenger.of(context).showSnackBar(Messages().error(context: context,duration: const Duration(seconds: 3),message:  "Name uzunluğu uygun değil"),);
              }
            },
            maxLength: 20,
            keyboardType: TextInputType.name,
            decoration:

              const  InputDecoration(border: OutlineInputBorder(), hintText: "Name",counterText: ""),
                controller: widget.nameController,
                
          ),
        ),
        Padding(
               padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
             onChanged: (value) {
              if (value.length>=20) {
                ScaffoldMessenger.of(context).showSnackBar(Messages().error(context: context,duration: const Duration(seconds: 3),message:  "E-mail uzunluğu uygun değil"),);
              }
            },
            maxLength: 30,
            keyboardType: TextInputType.emailAddress,
            decoration:
              const  InputDecoration(border: OutlineInputBorder(), hintText: "E-mail",counterText: ""),
                controller: widget.emailController,
          ),
        ),
        Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            maxLength: 20,
             onChanged: (value) {
              if (value.length>=20) {
                ScaffoldMessenger.of(context).showSnackBar(Messages().error(context: context,duration: const Duration(seconds: 3),message:  "Password uzunluğu uygun değil"),);
              }
            },
            decoration:

              const  InputDecoration(border: OutlineInputBorder(), hintText: "Password",counterText: ""),
              keyboardType: TextInputType.text,
              obscureText: true,
                controller: widget.passwordController,
          ),
        ),
        
      ],
    );
  }
}
