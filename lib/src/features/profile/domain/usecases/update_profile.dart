import 'package:cartmates/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:cartmates/src/imports/core_imports.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  FutureEither<void> call({
    String? bkashNumber,
    String? contactNumber,
    String? defaultPickupPoint,
    String? name,
    String? photoUrl,
  }) =>
      _repository.updateProfile(
        bkashNumber: bkashNumber,
        contactNumber: contactNumber,
        defaultPickupPoint: defaultPickupPoint,
        name: name,
        photoUrl: photoUrl,
      );
}
