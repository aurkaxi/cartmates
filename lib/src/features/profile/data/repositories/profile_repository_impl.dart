import 'package:cartmates/src/features/profile/data/datasources/profile_data_source.dart';
import 'package:cartmates/src/features/profile/domain/entities/profile.dart';
import 'package:cartmates/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:cartmates/src/imports/core_imports.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource = ProfileDataSource();

  @override
  FutureEither<UserProfile> getProfile() {
    return runTask(() async {
      return await _dataSource.getProfile();
    });
  }

  @override
  FutureEither<void> updateProfile({
    String? bkashNumber,
    String? contactNumber,
    String? defaultPickupPoint,
    String? name,
    String? photoUrl,
  }) {
    return runTask(() async {
      await _dataSource.updateProfile(
        bkashNumber: bkashNumber,
        contactNumber: contactNumber,
        name: name,
        photoUrl: photoUrl,
      );
    });
  }

  @override
  FutureEither<PublicUserProfile> getPublicProfile(String userId) {
    return runTask(() async {
      return await _dataSource.getPublicProfile(userId);
    });
  }
}
