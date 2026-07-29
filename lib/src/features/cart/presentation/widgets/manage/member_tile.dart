import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/presentation/providers/manage_order_provider.dart';

class MemberTile extends StatelessWidget {
  const MemberTile({
    super.key,
    required this.member,
    this.onAction,
  });

  final CartItemMember member;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return InkWell(
      onTap: onAction,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: cs.outlineVariant, width: 1),
        ),
        child: Row(
          children: [
            _MemberAvatar(
              name: member.name,
              avatarUrl: member.avatarUrl,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        'x${member.quantity}',
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '\$${member.totalPaid.toStringAsFixed(0)}',
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _MemberAction(
              status: member.status,
              onTap: onAction,
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({
    required this.name,
    required this.avatarUrl,
  });

  final String name;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: avatarUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: AppCachedImage(
                imageUrl: avatarUrl,
                width: 40.w,
                height: 40.h,
                fit: BoxFit.cover,
              ),
            )
          : Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
    );
  }
}

class _MemberAction extends StatelessWidget {
  const _MemberAction({
    required this.status,
    this.onTap,
  });

  final ParticipantStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DealStatusChip(
          status: status,
          type: StatusType.participant,
          size: ChipSize.small,
        ),
        if (status == ParticipantStatus.hold ||
            status == ParticipantStatus.disputed) ...[
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.chevron_right,
              color: cs.onSurfaceVariant,
              size: 20.sp,
            ),
          ),
        ],
      ],
    );
  }
}
