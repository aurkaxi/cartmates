import 'package:equatable/equatable.dart';

enum OrderTimelineEventType {
  joined('Joined Group Buy', 'group_add'),
  paymentSubmitted('Payment Submitted', 'upload_file'),
  paymentConfirmed('Payment Verified', 'verified'),
  paymentRejected('Payment Rejected', 'error'),
  disputeFiled('Dispute Filed', 'gavel'),
  dealReady('Goal Reached', 'check_circle'),
  dealOrdered('Campaign Funded & Ordered', 'shopping_cart'),
  shipped('Order Shipped', 'local_shipping'),
  arrived('Order Arrived', 'package_2'),
  received('Pickup Confirmed', 'check_circle');

  const OrderTimelineEventType(this.label, this.icon);
  final String label;
  final String icon;
}

class OrderTimelineEvent extends Equatable {
  final OrderTimelineEventType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final String? hostMessage;

  const OrderTimelineEvent({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.hostMessage,
  });

  @override
  List<Object?> get props => [type, title, description, timestamp, hostMessage];
}
