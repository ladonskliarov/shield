import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/splash_button.dart';
import '/domain/blocs/auth_bloc.dart';
import '/domain/blocs/hero_bloc.dart';
import 'dart:math';
import '/colors.dart';
import '/domain/blocs/missions_bloc.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({required this.uid, super.key});
  final String uid;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    BlocProvider.of<HeroBloc>(context).add(LoadHeroEvent(widget.uid));
    BlocProvider.of<MissionsBloc>(context).add(LoadMissionsEvent());
    super.initState();
  }

  double heroEnergy = 100;

  bool canTakeMission(
    String threatLevel,
  ) {
    final Map<String, double> energyCosts = {
      'Low': 20,
      'Medium': 30,
      'High': 40,
      'World-Ending': 50,
    };

    final double cost = energyCosts[threatLevel]!;
    if (heroEnergy >= cost) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                decoration: BoxDecoration(color: bgColor),
                child: SafeArea(
                  child: BlocBuilder<HeroBloc, HeroState>(
                    builder: (context, state) {
                      if (state is HeroLoadedState) {
                        heroEnergy = state.hero.energy;
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hello,',
                                          style: TextStyle(
                                            color: logoColor,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          state.hero.name,
                                          style: TextStyle(
                                            color: logoColor,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Your fatigue lvl is',
                                        style: TextStyle(
                                          color: logoColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      LinearProgressIndicator(
                                        color: Colors.blue,
                                        value: state.hero.energy / 100,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SplashButton(
                                      onTap: () {
                                        BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                                      },
                                      textStyle: TextStyle(color: logoColor, fontSize: 24, fontWeight: FontWeight.bold),
                                      text: 'Sign out'),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if (state is HeroInitialState) {
                        return SizedBox();
                      } else {
                        return SizedBox(
                          width: double.infinity,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Current missions',
                  style: TextStyle(color: logoColor, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 6,
              child: BlocBuilder<MissionsBloc, MissionsState>(builder: (context, state) {
                if (state is MissionsLoadedState) {
                  return _CustomCarousel(
                      items: state.missions
                          .map((e) => _MissionCard(
                              canTakeMission: canTakeMission,
                              missionId: e.id,
                              status: e.status,
                              threatLevel: e.threatLevel,
                              imageUrl: e.imageUrl))
                          .toList());
                } else if (state is MissionsInitialState) {
                  return SizedBox();
                } else {
                  return SizedBox();
                }
              }),
            ),
            Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

class _CustomCarousel extends StatefulWidget {
  final List<Widget> items;

  const _CustomCarousel({required this.items});

  @override
  State<_CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<_CustomCarousel> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateScale(int index, double page) {
    final diff = (index - page).abs();
    return max(1 - (diff * 0), 0.2);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double page = _controller.hasClients && _controller.page != null
                  ? _controller.page!
                  : _controller.initialPage.toDouble();

              final scale = _calculateScale(index, page);
              final opacity = max(0.4, scale);

              return Center(
                child: Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: child,
                  ),
                ),
              );
            },
            child: widget.items[index],
          );
        },
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.missionId,
    required this.status,
    required this.threatLevel,
    required this.imageUrl,
    required this.canTakeMission,
  });

  final bool Function(String threatLevel) canTakeMission;
  final String missionId;
  final String status;
  final String threatLevel;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.fill,
                width: double.infinity,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(logoColor),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }
                },
              ),
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        bgColor,
                        bgColor,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (status == 'Completed')
                              const Text(
                                'Completed',
                                style: TextStyle(
                                  color: logoColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Viga',
                                ),
                              ),
                            if (status == 'Ongoing')
                              SplashButton(
                                onTap: () {
                                  if (canTakeMission(threatLevel)) {
                                    BlocProvider.of<HeroBloc>(context)
                                        .add(ReserveMissionEvent(threatLevel: threatLevel, missionId: missionId));
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const _NickFuryCallingDialog(),
                                    );
                                  }
                                },
                                text: 'Take'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Level: $threatLevel',
                          style: TextStyle(
                            color: logoColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Viga',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (status == 'Completed')
                Positioned.fill(
                  child: Container(color: secondaryColor),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NickFuryCallingDialog extends StatelessWidget {
  const _NickFuryCallingDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: bgColor,
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Nick Fury is calling!',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/images/budanov.jpeg'),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CallButton(
                icon: Icons.call_end,
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
              ),
              _CallButton(
                icon: Icons.call,
                color: Colors.green,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _CallButton({required this.icon, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(15.0),
      shape: const CircleBorder(),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
