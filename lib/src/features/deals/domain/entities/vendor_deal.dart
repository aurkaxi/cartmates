import 'package:equatable/equatable.dart';

class SameVendorDeal extends Equatable {
  final String id;
  final String name;
  final List<String> imageUrls;
  final double minPrice;
  final double maxPrice;
  final Duration? timeRemaining;
  final String? tag;

  const SameVendorDeal({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.minPrice,
    required this.maxPrice,
    this.timeRemaining,
    this.tag,
  });

  String get timerText {
    if (timeRemaining == null) return '';
    final hours = timeRemaining!.inHours;
    final minutes = timeRemaining!.inMinutes.remainder(60);
    if (hours > 24) {
      final days = hours ~/ 24;
      return 'Ends in $days day${days > 1 ? 's' : ''}';
    }
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  bool get hasTimer => timeRemaining != null;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrls,
        minPrice,
        maxPrice,
        timeRemaining,
        tag,
      ];
}
