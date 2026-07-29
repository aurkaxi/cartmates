import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/order_timeline_event.dart';

class OrderTimeline extends StatelessWidget {
  const OrderTimeline({super.key, required this.events});

  final List<OrderTimelineEvent> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    final sorted = List<OrderTimelineEvent>.from(events)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return AppCard(
      title: 'Order Timeline',
      child: Column(
        children: List.generate(sorted.length, (index) {
          final event = sorted[index];
          final isLast = index == sorted.length - 1;
          final isLatest = index == 0;

          return _TimelineItem(
            event: event,
            isLast: isLast,
            isLatest: isLatest,
          );
        }),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.event,
    required this.isLast,
    required this.isLatest,
  });

  final OrderTimelineEvent event;
  final bool isLast;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40.r,
            child: Column(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: isLatest
                        ? cs.primaryContainer
                        : cs.surfaceContainerHigh,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isLatest ? cs.primary : cs.outlineVariant,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _getIcon(event.type),
                      size: 20.r,
                      color: isLatest
                          ? cs.onPrimaryContainer
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: cs.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isLatest ? cs.primary : cs.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        _formatTimestamp(event.timestamp),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    event.description,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  if (event.hostMessage != null) ...[
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLow,
                        borderRadius: AppBorders.sm,
                        border: Border(
                          left: BorderSide(
                            color: cs.outlineVariant,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        '"${event.hostMessage}"',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(OrderTimelineEventType type) {
    return switch (type) {
      OrderTimelineEventType.joined => Icons.group_add_rounded,
      OrderTimelineEventType.paymentSubmitted => Icons.upload_file_rounded,
      OrderTimelineEventType.paymentConfirmed => Icons.verified_rounded,
      OrderTimelineEventType.paymentRejected => Icons.error_rounded,
      OrderTimelineEventType.disputeFiled => Icons.gavel_rounded,
      OrderTimelineEventType.dealReady => Icons.check_circle_rounded,
      OrderTimelineEventType.dealOrdered => Icons.shopping_cart_rounded,
      OrderTimelineEventType.shipped => Icons.local_shipping_rounded,
      OrderTimelineEventType.arrived => Icons.inventory_2_rounded,
      OrderTimelineEventType.received => Icons.check_circle_rounded,
    };
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
