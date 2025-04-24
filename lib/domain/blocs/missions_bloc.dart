import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/mission.dart';
import '../../data/repositories/missions_repository.dart';

sealed class MissionsEvent extends Equatable {
  const MissionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMissionsEvent extends MissionsEvent {}

class _MissionsUpdatedEvent extends MissionsEvent {
  final List<Mission> missions;

  const _MissionsUpdatedEvent(this.missions);

  @override
  List<Object?> get props => [missions];
}

sealed class MissionsState extends Equatable {
  const MissionsState();

  @override
  List<Object?> get props => [];
}

class MissionsInitialState extends MissionsState {}

class MissionsLoadingState extends MissionsState {}

class MissionsLoadedState extends MissionsState {
  final List<Mission> missions;

  const MissionsLoadedState(this.missions);

  @override
  List<Object?> get props => [missions];
}

class MissionsBloc extends Bloc<MissionsEvent, MissionsState> {
  final MissionsRepository missionsRepository;
  StreamSubscription<List<Mission>>? _missionsSubscription;

  MissionsBloc({required this.missionsRepository}) : super(MissionsInitialState()) {
    on<LoadMissionsEvent>(_onLoadMissions);
    on<_MissionsUpdatedEvent>((event, emit) {
      emit(MissionsLoadedState(event.missions));
    });
  }

  Future<void> _onLoadMissions(LoadMissionsEvent event, Emitter<MissionsState> emit) async {
    emit(MissionsLoadingState());

    await _missionsSubscription?.cancel();
    _missionsSubscription = missionsRepository.getMissions().listen(
      (missions) {
        add(_MissionsUpdatedEvent(missions));
      },
    );
  }

  @override
  Future<void> close() {
    _missionsSubscription?.cancel();
    return super.close();
  }
}
