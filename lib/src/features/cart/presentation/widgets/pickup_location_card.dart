import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/deals/domain/entities/same_product_deal_detail.dart';

class PickupLocationCard extends StatelessWidget {
  const PickupLocationCard({super.key, required this.dealDetail});

  final SameProductDealDetail dealDetail;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    final now = DateTime.now();
    final diff = dealDetail.deadline.difference(now);
    final daysLeft = diff.inDays;
    final hoursLeft = diff.inHours.remainder(24);

    String timerText;
    if (daysLeft > 0) {
      timerText = '$daysLeft day${daysLeft > 1 ? 's' : ''} left';
    } else if (hoursLeft > 0) {
      timerText = '$hoursLeft left';
    } else {
      timerText = 'Closing soon';
    }

    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final deadline = dealDetail.deadline;
    final deadlineText =
        '${monthNames[deadline.month - 1]} ${deadline.day}, ${deadline.hour}:${deadline.minute.toString().padLeft(2, '0')} ${deadline.hour >= 12 ? 'PM' : 'AM'}';

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: AppBorders.lg,
        color: cs.surface,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: cs.onSurfaceVariant,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          'DEADLINE',
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      deadlineText,
                      style: tt.labelLarge?.copyWith(color: cs.onSurface),
                    ),
                    SizedBox(height: 2),
                    Text(
                      timerText,
                      style: tt.labelSmall?.copyWith(color: cs.error),
                    ),
                  ],
                ),
              ),
            ),
            VerticalDivider(width: 1, color: cs.outlineVariant),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: cs.onSurfaceVariant,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          'PICKUP',
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      dealDetail.pickupLocation,
                      style: tt.labelLarge?.copyWith(color: cs.onSurface),
                    ),
                    SizedBox(height: 2),
                    Text(
                      dealDetail.pickupDetail,
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
