import 'package:cartmates/src/features/profile/domain/entities/profile.dart';
import 'package:cartmates/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:cartmates/src/imports/core_imports.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  FutureEither<UserProfile> call() => _repository.getProfile();
}
