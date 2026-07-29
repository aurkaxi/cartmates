import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/deals/domain/entities/same_product_deal_detail.dart';

class HostInfoCard extends StatelessWidget {
  const HostInfoCard({super.key, required this.host});

  final SameProductDealHostInfo host;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    return AppCard(
      title: 'Campaign Host',
      child: Column(
        children: [
          GestureDetector(
            onTap: () => context.push(AppRoutes.publicProfilePath(host.userId)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppBorders.full,
                  child: AppCachedImage(
                    imageUrl: host.avatarUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    borderRadius: AppBorders.full,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              host.name,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.1),
                              borderRadius: AppBorders.xs,
                              border: Border.all(
                                color: cs.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              'HOST',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: cs.tertiary,
                          ),
                          SizedBox(width: AppSpacing.xxs),
                          Text(
                            '${host.reputationPoints} pts · ${host.successCount} success · ${host.failCount} fail',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Call Host',
              variant: ButtonVariant.outline,
              onPressed: () async {
                final uri = Uri.parse('tel:${host.contactNumber}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              prefixIcon: const Icon(Icons.call_rounded, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
