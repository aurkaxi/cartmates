import 'package:cartmates/src/imports/imports.dart';

import '../../domain/entities/deal.dart';
import '../../domain/entities/deal_category.dart';
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

  const _SectionHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      child: Text(
        title,
        style: tt.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
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
        const _SectionHeader(title: 'Closing Soon'),
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
              return SameProductDealCard(
                deal: deal,
                variant: DealCardVariant.closingSoon,
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

// ── Maximum Saving Section ─────────────────────────────────────────────────

class _MaxSavingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final maxSavingDeals = _sampleMaxSavingDeals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Maximum Saving'),
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

class _SuggestedSection extends StatefulWidget {
  @override
  State<_SuggestedSection> createState() => _SuggestedSectionState();
}

class _SuggestedSectionState extends State<_SuggestedSection> {
  String _selectedCategoryId = '1'; // 'All'

  List<SameProductDeal> get _filteredDeals {
    if (_selectedCategoryId == '1') return _sampleSuggestedDeals;
    final category = _sampleCategories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => _sampleCategories.first,
    );
    return _sampleSuggestedDeals
        .where((d) => d.categoryTags.contains(category.name))
        .toList();
  }

  void _showCategorySheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: AppBorders.bottomSheet,
      ),
      builder: (ctx) {
        final cs = ctx.theme.colorScheme;
        final tt = ctx.theme.textTheme;
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppSpacing.md.h),
                Text(
                  'Select Category',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _sampleCategories.length,
                    itemBuilder: (ctx, index) {
                      final cat = _sampleCategories[index];
                      final isSelected = cat.id == _selectedCategoryId;
                      return ListTile(
                        title: Text(
                          cat.name,
                          style: tt.bodyLarge?.copyWith(
                            color: cs.onSurface,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_rounded,
                                color: cs.primary, size: 20.r)
                            : null,
                        onTap: () {
                          setState(() => _selectedCategoryId = cat.id);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final filteredDeals = _filteredDeals;
    final topCategories =
        _sampleCategories.where((c) => c.id != '1').take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Suggested for You'),
        SizedBox(height: AppSpacing.sm.h),
        SizedBox(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            itemCount: topCategories.length + 1,
            separatorBuilder: (_, __) => SizedBox(width: 12.r),
            itemBuilder: (context, index) {
              if (index == topCategories.length) {
                return ActionChip(
                  avatar:
                      Icon(Icons.tune_rounded, size: 18.r, color: cs.primary),
                  label: const Text('More'),
                  onPressed: _showCategorySheet,
                  labelStyle: tt.labelLarge?.copyWith(color: cs.primary),
                  backgroundColor: cs.surface,
                  side: BorderSide(color: cs.primary),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppBorders.sm,
                  ),
                );
              }
              final category = topCategories[index];
              final isSelected = category.id == _selectedCategoryId;

              return ChoiceChip(
                label: Text(category.name),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => _selectedCategoryId = category.id);
                },
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
        ),
        SizedBox(height: AppSpacing.md.h),
        if (filteredDeals.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            child: Text(
              'No deals in this category yet.',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          )
        else
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
              itemCount: filteredDeals.length,
              itemBuilder: (context, index) {
                final deal = filteredDeals[index];
                return SameProductDealCard(
                  deal: deal,
                  variant: DealCardVariant.suggested,
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

// ── Sample Data ────────────────────────────────────────────────────────────

final _sampleCategories = [
  const DealCategory(id: '1', name: 'All'),
  const DealCategory(id: '2', name: 'Electronics'),
  const DealCategory(id: '3', name: 'Stationery'),
  const DealCategory(id: '4', name: 'Lab Equipment'),
  const DealCategory(id: '5', name: 'Books'),
  const DealCategory(id: '6', name: 'Accessories'),
];

final _sampleClosingSoonDeals = [
  const SameProductDeal(
    id: 'cs1',
    name: 'Logitech M330 Silent Wireless Mouse',
    imageUrl:
        'https://resource.logitech.com/c_fill,q_auto,f_auto,dpr_1.0/w_400,c_limit,ar_4:3/content/dam/logitech/en/products/mice/m330-wireless-silent-mouse/2024-update/gallery/m330-wireless-mouse-top-view-black-gallery-01.png',
    currentPrice: 18.99,
    originalPrice: 29.99,
    qtyCurrent: 14,
    qtyGoal: 20,
    confirmedQty: 11,
    holdQty: 3,
    timeRemaining: Duration(hours: 2, minutes: 15),
    savingsPercentage: 37,
    categoryTags: ['Electronics'],
  ),
  const SameProductDeal(
    id: 'cs2',
    name: 'USB-C Hub 7-in-1 Adapter',
    imageUrl:
        'https://www.startech.com.bd/image/cache/catalog/hub/ugreen/cm512/cm512-500x500.webp',
    currentPrice: 14.50,
    originalPrice: 29.99,
    qtyCurrent: 8,
    qtyGoal: 10,
    confirmedQty: 6,
    holdQty: 2,
    timeRemaining: Duration(hours: 5, minutes: 30),
    savingsPercentage: 52,
    categoryTags: ['Electronics'],
  ),
  const SameProductDeal(
    id: 'cs3',
    name: 'A4 Mesh Document File Organizer (10 Pack)',
    imageUrl:
        'https://img-eu.kwcdn.com/local-goods-img/1fad18d330/444658ad-8f35-40a7-9215-503d66728681_1600x1600.jpeg.format.jpg?imageMogr2/auto-orient%7CimageView2/2/w/800/q/70/format/webp',
    currentPrice: 12,
    originalPrice: 22,
    qtyCurrent: 6,
    qtyGoal: 8,
    confirmedQty: 4,
    holdQty: 2,
    timeRemaining: Duration(hours: 8),
    savingsPercentage: 45,
    categoryTags: ['Stationery'],
  ),
];

final _sampleMaxSavingDeals = [
  const SameProductDeal(
    id: 'ms1',
    name: 'Arduino Uno R3 Starter Kit',
    imageUrl:
        'https://cdn.roboticsbd.com/4141-large_default/beginners-kit-arduino-uno-r3-robotics-bangladesh.jpg',
    currentPrice: 19.99,
    originalPrice: 44.99,
    qtyCurrent: 22,
    qtyGoal: 30,
    confirmedQty: 15,
    holdQty: 7,
    savingsPercentage: 56,
    categoryTags: ['Lab Equipment', 'Electronics'],
  ),
  const SameProductDeal(
    id: 'ms2',
    name: 'Breadboard + Jumper Wires Bundle',
    imageUrl:
        'https://robotechshop.com/wp-content/uploads/2016/03/Jumper-Wire-Set_01.jpg.webp',
    currentPrice: 5.99,
    originalPrice: 14.99,
    qtyCurrent: 35,
    qtyGoal: 50,
    confirmedQty: 28,
    holdQty: 7,
    savingsPercentage: 60,
    categoryTags: ['Lab Equipment'],
  ),
  const SameProductDeal(
    id: 'ms3',
    name: 'Mechanical Keyboard Switch Sampler (14 switches)',
    imageUrl:
        'https://images.squarespace-cdn.com/content/v1/5e5af256556661723b861bd1/7cd3e956-367a-4b22-a698-183ba238e223/Rattle9.jpg',
    currentPrice: 8.99,
    originalPrice: 19.99,
    qtyCurrent: 18,
    qtyGoal: 25,
    confirmedQty: 12,
    holdQty: 6,
    savingsPercentage: 55,
    categoryTags: ['Accessories'],
  ),
];

final _sampleSuggestedDeals = [
  const SameProductDeal(
    id: 'sg1',
    name: 'USB Flash Drive 64GB (10 Pack)',
    imageUrl:
        'https://m.media-amazon.com/images/I/81IEDqEE-3L._AC_UF894,1000_QL80_.jpg',
    currentPrice: 28,
    originalPrice: 59.99,
    qtyCurrent: 10,
    qtyGoal: 20,
    timeRemaining: Duration(days: 2),
    savingsPercentage: 53,
    categoryTags: ['Electronics'],
  ),
  const SameProductDeal(
    id: 'sg2',
    name: 'Pilot G2 Gel Pen (12 Pack)',
    imageUrl: 'https://m.media-amazon.com/images/I/713GdY+wh4L.jpg',
    currentPrice: 9.99,
    originalPrice: 21.60,
    qtyCurrent: 18,
    qtyGoal: 25,
    timeRemaining: Duration(days: 3),
    savingsPercentage: 54,
    categoryTags: ['Stationery'],
  ),
  const SameProductDeal(
    id: 'sg3',
    name: 'USB Desk Fan 12V for Lab Bench',
    imageUrl:
        'https://ae-pic-a1.aliexpress-media.com/kf/S36d5d63203e34b8ba1889cc9b32d4bf58.jpg',
    currentPrice: 7.50,
    originalPrice: 15.99,
    qtyCurrent: 5,
    qtyGoal: 15,
    timeRemaining: Duration(days: 4),
    savingsPercentage: 53,
    categoryTags: ['Electronics', 'Accessories'],
  ),
  const SameProductDeal(
    id: 'sg4',
    name: 'Scientific Calculator Casio FX-991EX',
    imageUrl:
        'https://www.perennial.com.bd/image/cache/catalog/Gadget/Calculator/cc-500x500.jpg',
    currentPrice: 16.99,
    originalPrice: 34.99,
    qtyCurrent: 8,
    qtyGoal: 15,
    timeRemaining: Duration(days: 5),
    savingsPercentage: 51,
    categoryTags: ['Electronics', 'Lab Equipment'],
  ),
  const SameProductDeal(
    id: 'sg5',
    name: 'Mechanical Pencil 0.5mm + Leads Bundle',
    imageUrl:
        'https://i5.walmartimages.com/seo/Nicpro-0-5mm-Mechanical-Pencil-Set-with-Case-3Pcs-MP1000-Metal-Artist-Pencil-8-Tube-HB-Lead-Refills-0-5mm-3-Erasers-9-Eraser-Refills_c574cda8-ce68-4557-86b1-70de8097241c.ab273f4695303be04b453a3e4d604fef.jpeg?odnHeight=768&odnWidth=768&odnBg=FFFFFF',
    currentPrice: 4.99,
    originalPrice: 11.99,
    qtyCurrent: 22,
    qtyGoal: 30,
    timeRemaining: Duration(days: 3),
    savingsPercentage: 58,
    categoryTags: ['Stationery'],
  ),
  const SameProductDeal(
    id: 'sg6',
    name: 'LED Desk Lamp USB Rechargeable',
    imageUrl:
        'https://pictures-bangladesh.jijistatic.com/6593365_NjIwLTYyMC0zOGMyNDgxZGI2LTE.webp',
    currentPrice: 11.99,
    originalPrice: 24.99,
    qtyCurrent: 7,
    qtyGoal: 12,
    timeRemaining: Duration(days: 6),
    savingsPercentage: 52,
    categoryTags: ['Electronics', 'Accessories'],
  ),
  const SameProductDeal(
    id: 'sg7',
    name: 'Soldering Iron Kit 60W with Stand',
    imageUrl:
        'https://m.media-amazon.com/images/I/81FqWOAb2NL._AC_UF894,1000_QL80_.jpg',
    currentPrice: 13.50,
    originalPrice: 29.99,
    qtyCurrent: 4,
    qtyGoal: 10,
    timeRemaining: Duration(days: 7),
    savingsPercentage: 55,
    categoryTags: ['Lab Equipment'],
  ),
  const SameProductDeal(
    id: 'sg8',
    name: 'Whiteboard Markers (8 Colors, 24 Pack)',
    imageUrl:
        'https://img.kwcdn.com/product/fancy/3faa2181-3f3e-4c02-a067-8a39c3c5ddcc.jpg?imageMogr2/auto-orient%7CimageView2/2/w/800/q/70/format/webp',
    currentPrice: 8.99,
    originalPrice: 18.99,
    qtyCurrent: 15,
    qtyGoal: 20,
    timeRemaining: Duration(days: 4),
    savingsPercentage: 53,
    categoryTags: ['Stationery'],
  ),
];
