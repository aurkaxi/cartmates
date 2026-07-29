import 'package:cartmates/src/features/profile/data/datasources/profile_data_source.dart';
import 'package:cartmates/src/features/profile/domain/entities/profile.dart';
import 'package:cartmates/src/imports/core_imports.dart';

abstract class ProfileRepository {
  FutureEither<UserProfile> getProfile();
  FutureEither<void> updateProfile({
    String? bkashNumber,
    String? contactNumber,
    String? defaultPickupPoint,
    String? name,
    String? photoUrl,
  });
  FutureEither<PublicUserProfile> getPublicProfile(String userId);
}
