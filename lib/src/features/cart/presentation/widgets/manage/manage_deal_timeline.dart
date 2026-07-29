import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/order_timeline_event.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';

class ManageDealTimeline extends StatelessWidget {
  const ManageDealTimeline({
    super.key,
    required this.events,
    required this.dealStatus,
  });

  final List<OrderTimelineEvent> events;
  final DealStatus dealStatus;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Timeline',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (events.isEmpty)
            _EmptyTimeline()
          else
            ...events.asMap().entries.map(
                  (entry) => _TimelineItem(
                    event: entry.value,
                    isLast: entry.key == events.length - 1,
                  ),
                ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.event,
    required this.isLast,
  });

  final OrderTimelineEvent event;
  final bool isLast;

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${timestamp.month}/${timestamp.day}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TimelineDot(
          type: event.type,
          isLast: isLast,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    _formatTimestamp(event.timestamp),
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                event.description,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              if (event.hostMessage != null) ...[
                SizedBox(height: 4.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    event.hostMessage!,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onPrimaryContainer,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({
    required this.type,
    required this.isLast,
  });

  final OrderTimelineEventType type;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final color = _getDotColor(type);

    return Column(
      children: [
        Container(
          width: 10.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getDotIcon(type),
            size: 6.sp,
            color: Colors.white,
          ),
        ),
        if (!isLast)
          Container(
            width: 1.w,
            height: 24.h,
            color: cs.outlineVariant,
          ),
      ],
    );
  }

  Color _getDotColor(OrderTimelineEventType type) {
    return switch (type) {
      OrderTimelineEventType.joined => Colors.blue,
      OrderTimelineEventType.paymentSubmitted => Colors.orange,
      OrderTimelineEventType.paymentConfirmed => Colors.green,
      OrderTimelineEventType.paymentRejected => Colors.red,
      OrderTimelineEventType.disputeFiled => Colors.amber,
      OrderTimelineEventType.dealReady => Colors.purple,
      OrderTimelineEventType.dealOrdered => Colors.indigo,
      OrderTimelineEventType.shipped => Colors.teal,
      OrderTimelineEventType.arrived => Colors.cyan,
      OrderTimelineEventType.received => Colors.green,
    };
  }

  IconData _getDotIcon(OrderTimelineEventType type) {
    return switch (type) {
      OrderTimelineEventType.joined => Icons.person_add,
      OrderTimelineEventType.paymentSubmitted => Icons.receipt_long,
      OrderTimelineEventType.paymentConfirmed => Icons.check,
      OrderTimelineEventType.paymentRejected => Icons.close,
      OrderTimelineEventType.disputeFiled => Icons.gavel,
      OrderTimelineEventType.dealReady => Icons.flag,
      OrderTimelineEventType.dealOrdered => Icons.shopping_cart,
      OrderTimelineEventType.shipped => Icons.local_shipping,
      OrderTimelineEventType.arrived => Icons.inventory_2,
      OrderTimelineEventType.received => Icons.check_circle,
    };
  }
}

class _EmptyTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.timeline,
              size: 32.sp,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 8.h),
            Text(
              'No events yet',
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
