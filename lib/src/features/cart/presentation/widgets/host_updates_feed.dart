import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/deals/domain/entities/same_product_deal_detail.dart';

class HostUpdatesFeed extends StatelessWidget {
  const HostUpdatesFeed({super.key, required this.updates});

  final List<SameProductDealUpdate> updates;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    if (updates.isEmpty) return const SizedBox.shrink();

    return AppCard(
      title: 'Host Updates',
      child: Column(
        children: updates.map((update) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: AppBorders.sm,
                border: Border(
                  left: BorderSide(
                    color: cs.primary,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatTimestamp(update.timestamp),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    update.message,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
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
