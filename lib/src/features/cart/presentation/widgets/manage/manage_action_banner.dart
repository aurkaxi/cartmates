import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/presentation/providers/manage_order_provider.dart';

class ManageActionBanner extends StatelessWidget {
  const ManageActionBanner({
    super.key,
    required this.members,
    required this.dealStatus,
    this.onResolveDisputes,
  });

  final List<CartItemMember> members;
  final DealStatus dealStatus;
  final VoidCallback? onResolveDisputes;

  @override
  Widget build(BuildContext context) {
    final disputes = members
        .where(
          (m) => m.status == ParticipantStatus.disputed,
        )
        .toList();

    final holds = members
        .where(
          (m) => m.status == ParticipantStatus.hold,
        )
        .toList();

    if (disputes.isEmpty && holds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (disputes.isNotEmpty)
          _DisputeBanner(
            count: disputes.length,
            onTap: onResolveDisputes,
          ),
        if (disputes.isNotEmpty && holds.isNotEmpty) SizedBox(height: 8.h),
        if (holds.isNotEmpty) _HoldBanner(count: holds.length),
      ],
    );
  }
}

class _DisputeBanner extends StatelessWidget {
  const _DisputeBanner({
    required this.count,
    this.onTap,
  });

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cs.errorContainer,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: cs.error, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: cs.onErrorContainer,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count dispute${count > 1 ? 's' : ''} pending',
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onErrorContainer,
                    ),
                  ),
                  Text(
                    'Review before proceeding',
                    style: tt.labelSmall?.copyWith(
                      color: cs.onErrorContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: cs.onErrorContainer,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _HoldBanner extends StatelessWidget {
  const _HoldBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cs.tertiary, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.pending_actions,
            color: cs.onTertiaryContainer,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '$count member${count > 1 ? 's' : ''} pending payment review',
              style: tt.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: cs.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
