import 'dart:async';

import 'package:cartmates/src/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:cartmates/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cartmates/src/features/auth/domain/entities/user.dart';
import 'package:cartmates/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:cartmates/src/imports/imports.dart';

/// Provides the AuthRepository instance
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(localDatasource: AuthLocalDatasource());
});

/// Provides the current session state
final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return SessionNotifier(repository: repo);
});

/// Session states
enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionState {
  final SessionStatus status;
  final AppUser? user;

  const SessionState({this.status = SessionStatus.unknown, this.user});

  SessionState copyWith({SessionStatus? status, AppUser? user}) {
    return SessionState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}

class SessionNotifier extends StateNotifier<SessionState> {
  final AuthRepository _repository;

  SessionNotifier({required AuthRepository repository})
      : _repository = repository,
        super(const SessionState()) {
    _init();
  }

  Future<void> _init() async {
    // Check persisted session first
    final result = await _repository.getCurrentUser();
    result.fold(
      (_) => state = const SessionState(status: SessionStatus.unauthenticated),
      (user) {
        if (user != null) {
          // Convert AuthUser to AppUser
          final appUser = AppUser(
            id: user.id,
            email: user.email,
            name: user.username,
          );
          state =
              SessionState(status: SessionStatus.authenticated, user: appUser);
        } else {
          state = const SessionState(status: SessionStatus.unauthenticated);
        }
      },
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const SessionState(status: SessionStatus.unauthenticated);
  }
}
