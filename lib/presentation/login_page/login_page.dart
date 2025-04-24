import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../colors.dart';
import '../widgets/corner_clipper.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/splash_button.dart';
import '/domain/blocs/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      body: Stack(
        children: <Widget>[
          Positioned(
              left: -250,
              top: 60,
              child: SizedBox(height: 600, width: 500, child: Image.asset('assets/images/shield.png'))),
          Positioned(
              top: 60,
              right: 25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      fit: BoxFit.fill,
                    )),
              )),
          Positioned(
              top: 200,
              left: 00,
              child: Container(
                decoration: BoxDecoration(
                  color: logoColor,
                ),
                child: Text(
                  '  S.H.I.E.L.D. UA  ',
                  style: TextStyle(fontSize: 44, fontWeight: FontWeight.w500, fontFamily: 'Viga', color: bgColor),
                ),
              )),
          Positioned(top: 290, right: 0, bottom: 0, child: LayerOne()),
          Positioned(top: 318, right: 0, bottom: 28, child: LayerTwo()),
          Positioned(top: 320, right: 0, bottom: 48, child: LayerThree()),
        ],
      ),
    );
  }
}

class LayerOne extends StatelessWidget {
  const LayerOne({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CornerClipper(cutTopLeft: true, cutSize: 60),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 654,
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(60.0), bottomRight: Radius.circular(60.0)),
        ),
      ),
    );
  }
}

class LayerTwo extends StatelessWidget {
  const LayerTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CornerClipper(cutTopLeft: true, cutSize: 60),
      child: Container(
        width: 399,
        height: 584,
        decoration: BoxDecoration(
          color: logoColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60.0),
            bottomRight: Radius.circular(60.0),
            bottomLeft: Radius.circular(60.0),
          ),
        ),
      ),
    );
  }
}

class LayerThree extends StatefulWidget {
  const LayerThree({super.key});

  @override
  State<LayerThree> createState() => _LayerThreeState();
}

class _LayerThreeState extends State<LayerThree> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: SizedBox(
        height: 584,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 59,
                top: 99,
                child: Text(
                  'Stark mail',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              Positioned(
                left: 59,
                top: 129,
                child: SizedBox(
                  width: 310,
                  child: CustomTextField(
                    scrollController: scrollController,
                    controller: _loginController,
                    hintText: 'Enter ***@stark.com',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!RegExp(r'^[\w\.-]{4,}@stark\.com$').hasMatch(value)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Positioned(
                left: 59,
                top: 199,
                child: Text(
                  'Secret password',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              Positioned(
                left: 59,
                top: 229,
                child: SizedBox(
                  width: 310,
                  child: CustomTextField(
                    scrollController: scrollController,
                    controller: _passwordController,
                    hintText: 'Enter password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Positioned(
                top: 365,
                right: 60,
                child: SplashButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<AuthBloc>(context)
                        .add(SendLoginEvent(email: _loginController.text, password: _passwordController.text));
                    }
                  },
                  text: 'Sign in')),
            ],
          ),
        ),
      ),
    );
  }
}
