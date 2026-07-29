import 'package:cartmates/src/features/deals/domain/entities/deal.dart';
import 'package:cartmates/src/features/profile/data/models/profile_model.dart';

class PublicUserProfile {
  final UserProfileModel profile;
  final List<SameProductDeal> hostedDeals;
  final List<SameProductDeal> joinedDeals;

  const PublicUserProfile({
    required this.profile,
    required this.hostedDeals,
    required this.joinedDeals,
  });
}

class ProfileDataSource {
  UserProfileModel? _cached;

  static const _initialProfile = UserProfileModel(
    id: '1',
    email: 'tanvir@bu.ac.bd',
    name: 'Tanvir Hasan',
    photoUrl: 'https://picsum.photos/seed/tanvir/200/200',
    bkashNumber: '01712345678',
    contactNumber: '01798765432',
    dealsJoined: 12,
    dealsHosted: 8,
    dealsHostedSuccess: 6,
    dealsHostedFailed: 2,
    reputationPoints: 87,
    totalSavedBdt: 3450,
  );

  Future<UserProfileModel> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _cached ??= _initialProfile;
    return _cached!;
  }

  Future<void> updateProfile({
    String? bkashNumber,
    String? contactNumber,
    String? name,
    String? photoUrl,
  }) async {
    _cached ??= _initialProfile;
    _cached = _cached!.copyWith(
      bkashNumber: bkashNumber,
      contactNumber: contactNumber,
      name: name,
      photoUrl: photoUrl,
    );
  }

  Future<PublicUserProfile> getPublicProfile(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _mockPublicProfiles[userId] ?? _mockPublicProfiles['2']!;
  }

  static final Map<String, PublicUserProfile> _mockPublicProfiles = {
    '2': const PublicUserProfile(
      profile: UserProfileModel(
        id: '2',
        email: 'rifat@bu.ac.bd',
        name: 'Rifat Ahmed',
        photoUrl: 'https://picsum.photos/seed/rifat/200/200',
        bkashNumber: '01812345678',
        contactNumber: '01898765432',
        dealsJoined: 22,
        dealsHosted: 15,
        dealsHostedSuccess: 13,
        dealsHostedFailed: 2,
        reputationPoints: 142,
        totalSavedBdt: 8900,
      ),
      hostedDeals: [
        SameProductDeal(
          id: '101',
          name: 'Sony WH-1000XM5 Noise Canceling Headphones - Bulk Order',
          imageUrl: 'https://picsum.photos/seed/sonyxm5/800/600',
          currentPrice: 249,
          originalPrice: 399,
          qtyCurrent: 15,
          qtyGoal: 20,
          confirmedQty: 10,
          holdQty: 5,
          timeRemaining: Duration(hours: 48),
          savingsPercentage: 37,
        ),
        SameProductDeal(
          id: '102',
          name: 'Ikea Desk Lamp (TERTIAL) — Bulk',
          imageUrl: 'https://picsum.photos/seed/ikealamp/800/600',
          currentPrice: 18,
          originalPrice: 35,
          qtyCurrent: 8,
          qtyGoal: 15,
          confirmedQty: 5,
          holdQty: 3,
          timeRemaining: Duration(hours: 72),
          savingsPercentage: 49,
        ),
      ],
      joinedDeals: [
        SameProductDeal(
          id: '103',
          name: 'Bulk Organic Avocados (Box of 20)',
          imageUrl: 'https://picsum.photos/seed/avocado/800/600',
          currentPrice: 18.50,
          originalPrice: 35,
          qtyCurrent: 12,
          qtyGoal: 15,
          confirmedQty: 10,
          holdQty: 2,
          timeRemaining: Duration(hours: 24),
          savingsPercentage: 47,
        ),
      ],
    ),
    '3': const PublicUserProfile(
      profile: UserProfileModel(
        id: '3',
        email: 'nafisa@bu.ac.bd',
        name: 'Nafisa Khan',
        photoUrl: 'https://picsum.photos/seed/nafisa/200/200',
        bkashNumber: '01912345678',
        contactNumber: null,
        dealsJoined: 9,
        dealsHosted: 5,
        dealsHostedSuccess: 5,
        dealsHostedFailed: 0,
        reputationPoints: 95,
        totalSavedBdt: 4200,
      ),
      hostedDeals: [
        SameProductDeal(
          id: '201',
          name: 'A4 Sketchbook Bundle (Pack of 10)',
          imageUrl: 'https://picsum.photos/seed/sketchbook/800/600',
          currentPrice: 15,
          originalPrice: 33,
          qtyCurrent: 22,
          qtyGoal: 50,
          confirmedQty: 15,
          holdQty: 7,
          timeRemaining: Duration(hours: 96),
          savingsPercentage: 55,
        ),
      ],
      joinedDeals: [
        SameProductDeal(
          id: '202',
          name: 'Laundry Pods Mega Pack (120ct)',
          imageUrl: 'https://picsum.photos/seed/laundry/800/600',
          currentPrice: 21.99,
          originalPrice: 39.99,
          qtyCurrent: 45,
          qtyGoal: 100,
          confirmedQty: 30,
          holdQty: 15,
          timeRemaining: Duration(hours: 48),
          savingsPercentage: 45,
        ),
        SameProductDeal(
          id: '203',
          name: 'Logitech M330 Silent Mouse — Bulk',
          imageUrl: 'https://picsum.photos/seed/m330/800/600',
          currentPrice: 18,
          originalPrice: 30,
          qtyCurrent: 7,
          qtyGoal: 10,
          confirmedQty: 5,
          holdQty: 2,
          timeRemaining: Duration(hours: 36),
          savingsPercentage: 40,
        ),
      ],
    ),
  };
}
