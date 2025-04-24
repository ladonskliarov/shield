import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shield/data/repositories/hero_repository.dart';
import 'package:shield/data/repositories/missions_repository.dart';
import 'package:shield/domain/blocs/missions_bloc.dart';

import 'data/repositories/auth_repository.dart';
import 'domain/blocs/auth_bloc.dart';
import 'domain/blocs/hero_bloc.dart';
import 'router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => FirebaseAuthRepository()),
        RepositoryProvider<HeroRepository>(create: (_) => FirebaseHeroRepository()),
        RepositoryProvider<MissionsRepository>(create: (_) => FirebaseMissionsRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              //heroRepository: context.read<HeroRepository>(),
            ),
          ),
          BlocProvider<HeroBloc>(
            create: (context) => HeroBloc(heroRepository: context.read<HeroRepository>()),
          ),
          BlocProvider<MissionsBloc>(
              create: (context) => MissionsBloc(missionsRepository: context.read<MissionsRepository>()))
        ],
        child: MaterialApp.router(
          routerConfig: AppRouter().router,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
