import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';

class DealStatusActions extends StatelessWidget {
  const DealStatusActions({
    super.key,
    required this.item,
    this.onAction,
    this.onTrackingUpdate,
  });

  final CartItem item;
  final VoidCallback? onAction;
  final VoidCallback? onTrackingUpdate;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          if (item.dealStatus == DealStatus.recruiting) ...[
            _ActionRow(
              icon: Icons.check_circle_outline,
              label: 'Ready to Order',
              description: 'Goal reached or manual trigger',
              onTap: onAction,
              color: cs.primary,
            ),
            _ActionRow(
              icon: Icons.cancel_outlined,
              label: 'Cancel Deal',
              description: 'Refund all participants',
              onTap: onAction,
              color: cs.error,
            ),
          ] else if (item.dealStatus == DealStatus.ready) ...[
            _ActionRow(
              icon: Icons.shopping_cart_outlined,
              label: 'Place Order',
              description: 'Confirm and place bulk order',
              onTap: onAction,
              color: cs.primary,
            ),
          ] else if (item.dealStatus == DealStatus.ordered) ...[
            _TrackingSection(
              trackingNumber: item.trackingNumber,
              trackingUrl: item.trackingUrl,
              onUpdate: onTrackingUpdate,
            ),
            SizedBox(height: 8.h),
            _ActionRow(
              icon: Icons.local_shipping_outlined,
              label: 'Mark as Arrived',
              description: 'Items have arrived at pickup',
              onTap: onAction,
              color: cs.primary,
            ),
          ] else if (item.dealStatus == DealStatus.arrived) ...[
            _ActionRow(
              icon: Icons.check_circle,
              label: 'Auto-Complete',
              description: 'Completes when all picked up',
              onTap: null,
              color: cs.onSurfaceVariant,
            ),
          ] else if (item.dealStatus == DealStatus.expired) ...[
            _ActionRow(
              icon: Icons.cancel_outlined,
              label: 'Cancel Deal',
              description: 'Refund all participants',
              onTap: onAction,
              color: cs.error,
            ),
            _ActionRow(
              icon: Icons.shopping_cart_outlined,
              label: 'Order with Less',
              description: 'Proceed with current members',
              onTap: onAction,
              color: cs.primary,
            ),
          ] else if (item.dealStatus == DealStatus.completed) ...[
            const _SummaryRow(label: 'Status', value: 'All items distributed'),
            _SummaryRow(
                label: 'Members', value: '${item.progressCurrent ?? 0} served'),
          ] else if (item.dealStatus == DealStatus.cancelled) ...[
            const _SummaryRow(label: 'Status', value: 'Deal cancelled'),
            const _SummaryRow(label: 'Refund', value: 'Processing'),
          ],
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.description,
    this.onTap,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String description;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: onTap != null
                ? color.withValues(alpha: 0.1)
                : cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: onTap != null
                  ? color.withValues(alpha: 0.3)
                  : cs.outlineVariant,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onTap != null ? color : cs.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      description,
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: color,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackingSection extends StatelessWidget {
  const _TrackingSection({
    this.trackingNumber,
    this.trackingUrl,
    this.onUpdate,
  });

  final String? trackingNumber;
  final String? trackingUrl;
  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tracking Info',
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onUpdate != null)
                GestureDetector(
                  onTap: onUpdate,
                  child: Text(
                    trackingNumber != null ? 'Edit' : 'Add',
                    style: tt.labelMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (trackingNumber != null) ...[
            SizedBox(height: 8.h),
            _InfoRow(label: 'Number', value: trackingNumber!),
            if (trackingUrl != null)
              _InfoRow(label: 'URL', value: trackingUrl!),
          ] else ...[
            SizedBox(height: 8.h),
            Text(
              'No tracking info added yet',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
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
    final tt = context.textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          Flexible(
            child: Text(
              value,
              style: tt.labelSmall?.copyWith(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          Text(
            value,
            style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
