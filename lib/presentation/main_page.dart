import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/presentation/login_page/login_page.dart';
import '/presentation/menu_page/menu_page.dart';
import '/domain/blocs/auth_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthenticatedState) {
          return MenuPage(uid: state.uid);
        } else if (state is UnauthenticatedState) {
          return LoginPage();
        } else if (state is AuthInitialState) {
          return SizedBox();
        } 
        return SizedBox();
      },
    );
  }
}
