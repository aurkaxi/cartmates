import 'package:equatable/equatable.dart';

class SameProductDeal extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double currentPrice;
  final double originalPrice;
  final int qtyCurrent;
  final int qtyGoal;
  final int confirmedQty;
  final int holdQty;
  final Duration? timeRemaining;
  final double savingsPercentage;

  const SameProductDeal({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    required this.originalPrice,
    required this.qtyCurrent,
    required this.qtyGoal,
    this.confirmedQty = 0,
    this.holdQty = 0,
    this.timeRemaining,
    this.savingsPercentage = 0,
  });

  double get progress => qtyGoal > 0 ? qtyCurrent / qtyGoal : 0;
  double get confirmedProgress => qtyGoal > 0 ? confirmedQty / qtyGoal : 0;
  double get holdProgress => qtyGoal > 0 ? holdQty / qtyGoal : 0;

  bool get hasTimer => timeRemaining != null;
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

  bool get isHighSavings => savingsPercentage >= 30;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        currentPrice,
        originalPrice,
        qtyCurrent,
        qtyGoal,
        confirmedQty,
        holdQty,
        timeRemaining,
        savingsPercentage,
      ];
}
