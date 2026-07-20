import 'package:cartmates/src/imports/imports.dart';

import '../../domain/entities/vendor_deal.dart';

enum VendorCardVariant { closingSoon, suggested }

class SameVendorDealCard extends StatelessWidget {
  final SameVendorDeal deal;
  final VendorCardVariant variant;
  final VoidCallback? onTap;

  const SameVendorDealCard({
    super.key,
    required this.deal,
    required this.variant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    if (variant == VendorCardVariant.closingSoon) {
      return _buildClosingSoonCard(cs, tt);
    }
    return _buildSuggestedCard(cs, tt);
  }

  Widget _buildClosingSoonCard(ColorScheme cs, TextTheme tt) {
    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppBorders.card,
        border: Border.all(color: cs.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorders.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGrid(height: 112.h),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimerAndRatingRow(cs, tt),
                  SizedBox(height: AppSpacing.xxs.h),
                  _buildName(tt, cs),
                  SizedBox(height: AppSpacing.xxs.h),
                  _buildPriceRow(cs, tt),
                  if (deal.tag != null) ...[
                    SizedBox(height: AppSpacing.xxs.h),
                    _buildTagBadge(cs, tt),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedCard(ColorScheme cs, TextTheme tt) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppBorders.card,
        border: Border.all(color: cs.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorders.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGrid(isSquare: true),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSpacing.xxs.h),
                  _buildName(tt, cs),
                  SizedBox(height: AppSpacing.xxs.h),
                  _buildPriceRow(cs, tt),
                  SizedBox(height: AppSpacing.xxs.h),
                  if (deal.hasTimer) _buildTimerBadge(cs, tt),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid({double? height, bool isSquare = false}) {
    final imageCount = deal.imageUrls.length.clamp(0, 4);
    final placeholders = List<String>.generate(
      4 - imageCount,
      (_) => '',
    );
    final allImages = [...deal.imageUrls, ...placeholders];

    if (isSquare) {
      return AspectRatio(
        aspectRatio: 1,
        child: Builder(
          builder: (context) => _buildGridContent(context, allImages),
        ),
      );
    }

    return SizedBox(
      height: height ?? 112.h,
      child: Builder(
        builder: (context) => _buildGridContent(context, allImages),
      ),
    );
  }

  Widget _buildGridContent(BuildContext context, List<String> images) {
    final cs = context.theme.colorScheme;
    return ColoredBox(
      color: cs.surfaceContainerHighest,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildGridImage(images[0])),
                const SizedBox(width: 1),
                Expanded(child: _buildGridImage(images[1])),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildGridImage(images[2])),
                const SizedBox(width: 1),
                Expanded(child: _buildGridImage(images[3])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridImage(String url) {
    if (url.isEmpty) {
      return const SizedBox.expand();
    }
    return AppCachedImage(
      imageUrl: url,
      fit: BoxFit.cover,
      useSkeleton: true,
    );
  }

  Widget _buildTimerBadge(ColorScheme cs, TextTheme tt) {
    return Row(
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedTime02,
          size: 14.r,
          color: cs.error,
        ),
        SizedBox(width: AppSpacing.xxs.w),
        Text(
          deal.timerText,
          style: tt.labelSmall?.copyWith(color: cs.error),
        ),
      ],
    );
  }

  Widget _buildTimerAndRatingRow(ColorScheme cs, TextTheme tt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (deal.hasTimer)
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedTime02,
                size: 12.r,
                color: cs.error,
              ),
              SizedBox(width: AppSpacing.xxs.w),
              Text(
                deal.timerText,
                style: tt.labelSmall?.copyWith(color: cs.error),
              ),
            ],
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildName(TextTheme tt, ColorScheme cs) {
    return Text(
      deal.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: tt.titleMedium?.copyWith(color: cs.onSurface),
    );
  }

  Widget _buildPriceRow(ColorScheme cs, TextTheme tt) {
    return Row(
      children: [
        Text(
          '\$${deal.minPrice.toStringAsFixed(0)}',
          style: tt.bodyMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          ' / \$${deal.maxPrice.toStringAsFixed(0)} Min',
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildTagBadge(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xxs.h,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: AppBorders.xs,
      ),
      child: Text(
        deal.tag!,
        style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
      ),
    );
  }
}
