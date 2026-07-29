import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? bkashNumber;
  final String? contactNumber;
  final String? defaultPickupPoint;
  final int dealsJoined;
  final int dealsHosted;
  final int dealsHostedSuccess;
  final int dealsHostedFailed;
  final int reputationPoints;
  final double totalSavedBdt;

  const UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.bkashNumber,
    this.contactNumber,
    this.defaultPickupPoint,
    required this.dealsJoined,
    required this.dealsHosted,
    required this.dealsHostedSuccess,
    required this.dealsHostedFailed,
    required this.reputationPoints,
    required this.totalSavedBdt,
  });

  factory UserProfile.empty() => const UserProfile(
        id: '',
        email: '',
        dealsJoined: 0,
        dealsHosted: 0,
        dealsHostedSuccess: 0,
        dealsHostedFailed: 0,
        reputationPoints: 0,
        totalSavedBdt: 0,
      );

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  UserProfile copyWith({
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
    return UserProfile(
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

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        photoUrl,
        bkashNumber,
        contactNumber,
        defaultPickupPoint,
        dealsJoined,
        dealsHosted,
        dealsHostedSuccess,
        dealsHostedFailed,
        reputationPoints,
        totalSavedBdt,
      ];
}
