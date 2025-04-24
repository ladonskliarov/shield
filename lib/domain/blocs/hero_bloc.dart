import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/hero.dart';
import '../../data/repositories/hero_repository.dart';

sealed class HeroEvent extends Equatable {
  const HeroEvent();

  @override
  List<Object?> get props => [];
}

class LoadHeroEvent extends HeroEvent {
  final String uid;

  const LoadHeroEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}

class _HeroUpdatedEvent extends HeroEvent {
  final Hero hero;

  const _HeroUpdatedEvent(this.hero);

  @override
  List<Object?> get props => [hero];
}

class ReserveMissionEvent extends HeroEvent {
  const ReserveMissionEvent({required this.threatLevel, required this.missionId});
  final String threatLevel;
  final String missionId;

  @override
  List<Object?> get props => [threatLevel, missionId];
}

sealed class HeroState extends Equatable {
  const HeroState();

  @override
  List<Object?> get props => [];
}

class HeroInitialState extends HeroState {}

class HeroLoadingState extends HeroState {}

class HeroLoadedState extends HeroState {
  final Hero hero;

  const HeroLoadedState(this.hero);

  @override
  List<Object?> get props => [hero];
}

class HeroBloc extends Bloc<HeroEvent, HeroState> {
  final HeroRepository heroRepository;
  StreamSubscription<Hero?>? _heroSubscription;

  HeroBloc({required this.heroRepository}) : super(HeroInitialState()) {
    on<LoadHeroEvent>(_onLoadHero);
    on<_HeroUpdatedEvent>((event, emit) {
      emit(HeroLoadedState(event.hero));
    });
    on<ReserveMissionEvent>((event, emit) async {
      await heroRepository.reserveMission(event.threatLevel, event.missionId);
    });
  }

  void _onLoadHero(LoadHeroEvent event, Emitter<HeroState> emit) {
    emit(HeroLoadingState());
    _heroSubscription?.cancel();
    
    _heroSubscription = heroRepository.getHero(event.uid).listen((hero) {
      if (hero != null) {
        add(_HeroUpdatedEvent(hero));
      }
    });
  }

  @override
  Future<void> close() {
    _heroSubscription?.cancel();
    return super.close();
  }
}
