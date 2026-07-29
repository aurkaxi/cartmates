import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Your Order',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DealStatusChip(
                status: item.participantStatus,
                type: StatusType.participant,
                size: ChipSize.small,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          _InfoRow(label: 'Item', value: '${item.name} x ${item.quantity}'),
          _InfoRow(
              label: 'Total Paid', value: '\$${item.price.toStringAsFixed(2)}'),
          _InfoRow(label: 'Order ID', value: '#${item.id.toUpperCase()}'),
          if (item.trackingNumber != null) ...[
            _TrackingRow(
              trackingNumber: item.trackingNumber!,
              trackingUrl: item.trackingUrl,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingRow extends StatelessWidget {
  const _TrackingRow({
    required this.trackingNumber,
    this.trackingUrl,
  });

  final String trackingNumber;
  final String? trackingUrl;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;
    final isUrl = trackingUrl != null &&
        (trackingUrl!.startsWith('http://') ||
            trackingUrl!.startsWith('https://'));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tracking',
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          if (isUrl)
            GestureDetector(
              onTap: () async {
                try {
                  final uri = Uri.parse(trackingUrl!);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (_) {}
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.link,
                    size: 14.sp,
                    color: cs.primary,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text(
                      trackingNumber,
                      style: tt.bodyMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trackingNumber,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: () async {
                    await CopyService.instance.copy(trackingNumber);
                    if (context.mounted) {
                      context.showTypedSnackBar(
                        'Tracking number copied',
                        type: SnackBarType.success,
                      );
                    }
                  },
                  child: Icon(
                    Icons.copy_rounded,
                    size: 14.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
