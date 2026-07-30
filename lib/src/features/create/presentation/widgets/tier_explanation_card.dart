import 'package:cartmates/src/imports/imports.dart';

class TierExplanationCard extends StatelessWidget {
  const TierExplanationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: AppBorders.lg,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20.r,
            color: cs.onSecondaryContainer,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              'Pricing tiers apply to total group quantity, not individual orders. '
              'For example, if 10 people each order 1 unit, that counts as 10 units toward reaching a tier.',
              style: tt.bodySmall?.copyWith(
                color: cs.onSecondaryContainer,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
