import 'package:cartmates/src/imports/imports.dart';

import '../../domain/entities/deal.dart';
import '../../domain/entities/deal_category.dart';
import '../../domain/entities/vendor_deal.dart';
import '../widgets/widgets.dart';

class DealsPage extends ConsumerWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _SearchBar()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md.h)),
            SliverToBoxAdapter(child: _ClosingSoonSection()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg.h)),
            SliverToBoxAdapter(child: _MaxSavingSection()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg.h)),
            SliverToBoxAdapter(child: _SuggestedSection()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl.h)),
          ],
        ),
      ),
    );
  }
}

// ── Search Bar ─────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md.w,
        AppSpacing.md.h,
        AppSpacing.md.w,
        0,
      ),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: AppBorders.lg,
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            SizedBox(width: AppSpacing.md.w),
            HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              size: 20.r,
              color: cs.onSurfaceVariant,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search bulk deals...',
                  hintStyle: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm.w,
                    vertical: 0,
                  ),
                ),
                style: tt.bodyMedium?.copyWith(color: cs.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onAction,
              child: Row(
                children: [
                  Text(
                    actionText!,
                    style: tt.labelLarge?.copyWith(color: cs.primary),
                  ),
                  SizedBox(width: AppSpacing.xxs.w),
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight01,
                    size: 16.r,
                    color: cs.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Closing Soon Section ───────────────────────────────────────────────────

class _ClosingSoonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final closingSoonDeals = _sampleClosingSoonDeals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Closing Soon',
          actionText: 'View All',
          onAction: () {},
        ),
        SizedBox(height: AppSpacing.sm.h),
        SizedBox(
          height: 230.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            itemCount: closingSoonDeals.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.r),
            itemBuilder: (context, index) {
              final deal = closingSoonDeals[index];
              if (deal is SameProductDeal) {
                return SameProductDealCard(
                  deal: deal,
                  variant: DealCardVariant.closingSoon,
                  onTap: () => context.push(
                    AppRoutes.sameProductDealDetailPath(deal.id),
                  ),
                );
              } else if (deal is SameVendorDeal) {
                return SameVendorDealCard(
                  deal: deal,
                  variant: VendorCardVariant.closingSoon,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

// ── Maximum Saving Section ─────────────────────────────────────────────────

class _MaxSavingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final maxSavingDeals = _sampleMaxSavingDeals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Maximum Saving',
          actionText: 'View All',
          onAction: () {},
        ),
        SizedBox(height: AppSpacing.sm.h),
        SizedBox(
          height: 230.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            itemCount: maxSavingDeals.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.r),
            itemBuilder: (context, index) {
              final deal = maxSavingDeals[index];
              return SameProductDealCard(
                deal: deal,
                variant: DealCardVariant.maximumSaving,
                onTap: () => context.push(
                  AppRoutes.sameProductDealDetailPath(deal.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Suggested For You Section ──────────────────────────────────────────────

class _SuggestedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Suggested for You'),
        SizedBox(height: AppSpacing.sm.h),
        _CategoryChips(),
        SizedBox(height: AppSpacing.md.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.r,
              mainAxisSpacing: 16.r,
              mainAxisExtent: 240.h,
            ),
            itemCount: _sampleSuggestedDeals.length,
            itemBuilder: (context, index) {
              final deal = _sampleSuggestedDeals[index];
              if (deal is SameProductDeal) {
                return SameProductDealCard(
                  deal: deal,
                  variant: DealCardVariant.suggested,
                  onTap: () => context.push(
                    AppRoutes.sameProductDealDetailPath(deal.id),
                  ),
                );
              } else if (deal is SameVendorDeal) {
                return SameVendorDealCard(
                  deal: deal,
                  variant: VendorCardVariant.suggested,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

// ── Category Chips ─────────────────────────────────────────────────────────

class _CategoryChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
        itemCount: _sampleCategories.length,
        separatorBuilder: (_, __) => SizedBox(width: 16.r),
        itemBuilder: (context, index) {
          final category = _sampleCategories[index];
          final isSelected = index == 0;

          return ChoiceChip(
            label: Text(category.name),
            selected: isSelected,
            onSelected: (_) {},
            labelStyle: tt.labelLarge?.copyWith(
              color: isSelected ? cs.onPrimary : cs.onSurface,
            ),
            selectedColor: cs.primary,
            backgroundColor: cs.surface,
            side: BorderSide(
              color: isSelected ? cs.primary : cs.outline,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppBorders.sm,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

// ── Sample Data ────────────────────────────────────────────────────────────

final _sampleCategories = [
  const DealCategory(id: '1', name: 'All'),
  const DealCategory(id: '2', name: 'Groceries'),
  const DealCategory(id: '3', name: 'Supplies'),
  const DealCategory(id: '4', name: 'Tech Acc.'),
  const DealCategory(id: '5', name: 'Dorm'),
];

final _sampleClosingSoonDeals = <dynamic>[
  const SameProductDeal(
    id: '1',
    name: 'Bulk Organic Avocados (Box of 20)',
    imageUrl: 'https://picsum.photos/seed/avocado/400/300',
    currentPrice: 18.50,
    originalPrice: 35,
    qtyCurrent: 12,
    qtyGoal: 15,
    confirmedQty: 10,
    holdQty: 2,
    timeRemaining: Duration(hours: 2, minutes: 15),
  ),
  const SameProductDeal(
    id: '2',
    name: 'Artisan Dark Roast Coffee (5lbs)',
    imageUrl: 'https://picsum.photos/seed/coffee/400/300',
    currentPrice: 42,
    originalPrice: 75,
    qtyCurrent: 8,
    qtyGoal: 10,
    confirmedQty: 6,
    holdQty: 2,
    timeRemaining: Duration(hours: 5, minutes: 30),
  ),
  const SameVendorDeal(
    id: 'v1',
    name: 'Costco Campus Delivery',
    imageUrls: [
      'https://picsum.photos/seed/costco1/200/200',
      'https://picsum.photos/seed/costco2/200/200',
      'https://picsum.photos/seed/costco3/200/200',
      'https://picsum.photos/seed/costco4/200/200',
    ],
    minPrice: 350,
    maxPrice: 500,
    timeRemaining: Duration(hours: 2, minutes: 15),
    tag: 'Free Shipping Split',
  ),
  const SameVendorDeal(
    id: 'v2',
    name: 'H-Mart Bulk Split',
    imageUrls: [
      'https://picsum.photos/seed/hmart1/200/200',
      'https://picsum.photos/seed/hmart2/200/200',
      'https://picsum.photos/seed/hmart3/200/200',
      'https://picsum.photos/seed/hmart4/200/200',
    ],
    minPrice: 120,
    maxPrice: 200,
    timeRemaining: Duration(hours: 5, minutes: 30),
    tag: 'Wholesale Pricing',
  ),
];

final _sampleMaxSavingDeals = [
  const SameProductDeal(
    id: '3',
    name: 'A4 Sketchbook Bundle (Pack of 10)',
    imageUrl: 'https://picsum.photos/seed/sketch/400/300',
    currentPrice: 15,
    originalPrice: 33,
    qtyCurrent: 22,
    qtyGoal: 50,
    confirmedQty: 15,
    holdQty: 7,
    savingsPercentage: 55,
  ),
  const SameProductDeal(
    id: '4',
    name: 'Wireless Earbuds Pro',
    imageUrl: 'https://picsum.photos/seed/earbuds/400/300',
    currentPrice: 29.99,
    originalPrice: 59.99,
    qtyCurrent: 30,
    qtyGoal: 40,
    confirmedQty: 25,
    holdQty: 5,
    savingsPercentage: 50,
  ),
];

final _sampleSuggestedDeals = <dynamic>[
  const SameProductDeal(
    id: '5',
    name: 'Laundry Pods Mega Pack (120ct)',
    imageUrl: 'https://picsum.photos/seed/laundry/400/400',
    currentPrice: 21.99,
    originalPrice: 39.99,
    qtyCurrent: 45,
    qtyGoal: 100,
    timeRemaining: Duration(days: 2),
  ),
  const SameVendorDeal(
    id: 'v3',
    name: 'Local Farmers Market',
    imageUrls: [
      'https://picsum.photos/seed/farm1/200/200',
      'https://picsum.photos/seed/farm2/200/200',
      'https://picsum.photos/seed/farm3/200/200',
      'https://picsum.photos/seed/farm4/200/200',
    ],
    minPrice: 45,
    maxPrice: 100,
    timeRemaining: Duration(days: 2),
  ),
  const SameProductDeal(
    id: '6',
    name: 'Instant Ramen Box (48 Pack)',
    imageUrl: 'https://picsum.photos/seed/ramen/400/400',
    currentPrice: 18,
    originalPrice: 30,
    qtyCurrent: 12,
    qtyGoal: 48,
    timeRemaining: Duration(days: 3),
  ),
  const SameVendorDeal(
    id: 'v4',
    name: 'Target Dorm Run',
    imageUrls: [
      'https://picsum.photos/seed/target1/200/200',
      'https://picsum.photos/seed/target2/200/200',
      'https://picsum.photos/seed/target3/200/200',
      'https://picsum.photos/seed/target4/200/200',
    ],
    minPrice: 150,
    maxPrice: 200,
    timeRemaining: Duration(days: 1),
  ),
];
