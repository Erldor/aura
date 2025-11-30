import "package:flutter_bloc/flutter_bloc.dart";

//
//  EVENTS
//

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateName extends ProfileEvent {
  final String name;
  UpdateName(this.name);
}

class UpdateImage extends ProfileEvent {
  final String avatarUrl;
  UpdateImage(this.avatarUrl);
}

//
// STATES
//

class ProfileState {
  final String? name;
  final String? avatarUrl;
  final bool loading;

  ProfileState({
    this.name,
    this.avatarUrl,
    this.loading = false,
  });

  ProfileState copyWith({
    String? name,
    String? avatarUrl,
    bool? loading,
  }) {
    return ProfileState(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      loading: loading ?? this.loading,
    );
  }
}

//
//  BLOC
//
/*
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository repository;

  ProfileBloc(this.repository) : super(ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateName>(_onUpdateName);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final user = await repository.getUser();
    
    emit(state.copyWith(
      name: user.name,
      photoUrl: user.photoUrl,
      loading: false,
    ));
  }

  Future<void> _onUpdateName(
    UpdateName event,
    Emitter<ProfileState> emit,
  ) async {
    await repository.updateName(event.name);

    emit(state.copyWith(name: event.name));
  }
}
*/