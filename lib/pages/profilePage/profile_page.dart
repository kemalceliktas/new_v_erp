import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/provider1/provider_one.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObs = true;

  void changeIsObs() {
    setState(() {
      isObs = !isObs;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.text =
        context.read<ProviderOne>().prefs.getString("email").toString();
    _passwordController.text =
        context.read<ProviderOne>().prefs.getString("password").toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ProviderOne>().changeBottomIndex(0);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Merhaba",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    "${context.read<ProviderOne>().prefs.getString("name")}",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Email",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: _emailController,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Password",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () => changeIsObs(),
                              icon: Icon(isObs
                                  ? Icons.remove_red_eye
                                  : MdiIcons.eyeOff))),
                      obscureText: isObs,
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: _passwordController,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
