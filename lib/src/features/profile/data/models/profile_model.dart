import 'package:cartmates/src/features/profile/domain/entities/profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.bkashNumber,
    super.contactNumber,
    super.defaultPickupPoint,
    required super.dealsJoined,
    required super.dealsHosted,
    required super.dealsHostedSuccess,
    required super.dealsHostedFailed,
    required super.reputationPoints,
    required super.totalSavedBdt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      photoUrl: json['photo_url'],
      bkashNumber: json['bkash_number'],
      contactNumber: json['contact_number'],
      defaultPickupPoint: json['default_pickup_point'],
      dealsJoined: json['deals_joined'] ?? 0,
      dealsHosted: json['deals_hosted'] ?? 0,
      dealsHostedSuccess: json['deals_hosted_success'] ?? 0,
      dealsHostedFailed: json['deals_hosted_failed'] ?? 0,
      reputationPoints: json['reputation_points'] ?? 0,
      totalSavedBdt: (json['total_saved_bdt'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      'bkash_number': bkashNumber,
      'contact_number': contactNumber,
      'default_pickup_point': defaultPickupPoint,
      'deals_joined': dealsJoined,
      'deals_hosted': dealsHosted,
      'deals_hosted_success': dealsHostedSuccess,
      'deals_hosted_failed': dealsHostedFailed,
      'reputation_points': reputationPoints,
      'total_saved_bdt': totalSavedBdt,
    };
  }

  @override
  UserProfileModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? bkashNumber,
    String? contactNumber,
    String? defaultPickupPoint,
    int? dealsJoined,
    int? dealsHosted,
    int? dealsHostedSuccess,
    int? dealsHostedFailed,
    int? reputationPoints,
    double? totalSavedBdt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      bkashNumber: bkashNumber ?? this.bkashNumber,
      contactNumber: contactNumber ?? this.contactNumber,
      defaultPickupPoint: defaultPickupPoint ?? this.defaultPickupPoint,
      dealsJoined: dealsJoined ?? this.dealsJoined,
      dealsHosted: dealsHosted ?? this.dealsHosted,
      dealsHostedSuccess: dealsHostedSuccess ?? this.dealsHostedSuccess,
      dealsHostedFailed: dealsHostedFailed ?? this.dealsHostedFailed,
      reputationPoints: reputationPoints ?? this.reputationPoints,
      totalSavedBdt: totalSavedBdt ?? this.totalSavedBdt,
    );
  }
}
