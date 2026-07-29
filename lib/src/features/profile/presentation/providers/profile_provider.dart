import 'package:cartmates/src/features/profile/data/datasources/profile_data_source.dart';
import 'package:cartmates/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:cartmates/src/features/profile/domain/entities/profile.dart';
import 'package:cartmates/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:cartmates/src/imports/imports.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, UserProfile>(ProfileNotifier.new);

final publicProfileProvider =
    FutureProvider.family<PublicUserProfile, String>((ref, userId) async {
  final repo = ref.read(profileRepositoryProvider);
  final result = await repo.getPublicProfile(userId);
  return result.fold(
    (failure) => throw failure,
    (profile) => profile,
  );
});

class ProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() => fetchProfile();

  Future<UserProfile> fetchProfile() async {
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.getProfile();
    return result.fold(
      (failure) => throw failure,
      (profile) => profile,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => fetchProfile());
  }

  Future<void> updateProfile({
    String? bkashNumber,
    String? contactNumber,
    String? name,
    String? photoUrl,
  }) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(
      bkashNumber: bkashNumber,
      contactNumber: contactNumber,
      name: name,
      photoUrl: photoUrl,
    ));

    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.updateProfile(
      bkashNumber: bkashNumber,
      contactNumber: contactNumber,
      name: name,
      photoUrl: photoUrl,
    );
    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
      },
      (_) {},
    );
  }
}
