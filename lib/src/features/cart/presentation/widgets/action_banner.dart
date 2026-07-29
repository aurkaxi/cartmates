import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';

class ActionBanner extends StatelessWidget {
  const ActionBanner({super.key, required this.item, required this.onAction});

  final CartItem item;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    final data = _getBannerData(item, cs);
    if (data == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.3),
        borderRadius: AppBorders.md,
        border: Border.all(color: data.color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIcon(item.participantStatus),
                color: cs.onSurface,
                size: 20.r,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  data.title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            data.message,
            style: context.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: data.buttonText,
              variant: item.participantStatus == ParticipantStatus.denied
                  ? ButtonVariant.danger
                  : ButtonVariant.primary,
              onPressed: onAction,
            ),
          ),
          if (data.showDispute) ...[
            SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Dispute to Admin',
                variant: ButtonVariant.outline,
                onPressed: onAction,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _BannerData? _getBannerData(CartItem item, ColorScheme cs) {
    switch (item.participantStatus) {
      case ParticipantStatus.hold:
        return _BannerData(
          title: 'Awaiting Verification',
          message: 'Your payment proof is being reviewed by the host.',
          buttonText: 'View Proof Submitted',
          color: cs.primaryContainer,
        );
      case ParticipantStatus.denied:
        return _BannerData(
          title: 'Action Required',
          message: item.rejectionReason ??
              'Your payment proof was rejected. Please review and take action.',
          buttonText: 'Resubmit Proof',
          color: cs.errorContainer,
          showDispute: true,
        );
      case ParticipantStatus.disputed:
        return _BannerData(
          title: 'Under Review',
          message: 'Your dispute is being reviewed by an admin.',
          buttonText: 'View Dispute Status',
          color: cs.tertiaryContainer,
        );
      case ParticipantStatus.arrived when !item.received:
        return _BannerData(
          title: 'Ready for Pickup!',
          message: 'Your items have arrived and are waiting for you.',
          buttonText: 'Confirm Receipt',
          color: cs.primaryContainer,
        );
      default:
        return null;
    }
  }

  IconData _getIcon(ParticipantStatus status) {
    return switch (status) {
      ParticipantStatus.hold => Icons.hourglass_top_rounded,
      ParticipantStatus.denied => Icons.error_rounded,
      ParticipantStatus.disputed => Icons.gavel_rounded,
      ParticipantStatus.arrived => Icons.celebration_rounded,
      _ => Icons.info_rounded,
    };
  }
}

class _BannerData {
  final String title;
  final String message;
  final String buttonText;
  final Color color;
  final bool showDispute;

  const _BannerData({
    required this.title,
    required this.message,
    required this.buttonText,
    required this.color,
    this.showDispute = false,
  });
}
