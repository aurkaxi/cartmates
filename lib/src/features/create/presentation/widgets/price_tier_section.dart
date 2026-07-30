import 'package:cartmates/src/imports/imports.dart';
import '../../domain/entities/create_deal_draft.dart';

class PriceTierSection extends StatelessWidget {
  final List<CreateDealTierDraft> tiers;
  final ValueChanged<int> onAddTier;
  final void Function(int index) onRemoveTier;
  final void Function(int index, {int? minQty, double? price}) onUpdateTier;

  const PriceTierSection({
    super.key,
    required this.tiers,
    required this.onAddTier,
    required this.onRemoveTier,
    required this.onUpdateTier,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Tiers',
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        ...List.generate(tiers.length, (index) {
          final tier = tiers[index];
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'At Qty',
                    hint: 'Min qty',
                    keyboardType: TextInputType.number,
                    initialValue: tier.minQty.toString(),
                    onChanged: (value) {
                      final minQty = int.tryParse(value) ?? 1;
                      onUpdateTier(index, minQty: minQty);
                    },
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: AppTextField(
                    label: r'Price $',
                    hint: 'Per unit',
                    keyboardType: TextInputType.number,
                    initialValue: tier.price > 0 ? tier.price.toString() : '',
                    onChanged: (value) {
                      final price = double.tryParse(value) ?? 0;
                      onUpdateTier(index, price: price);
                    },
                  ),
                ),
                if (tiers.length > 1)
                  IconButton(
                    onPressed: () => onRemoveTier(index),
                    icon: Icon(
                      Icons.remove_circle_outline_rounded,
                      color: cs.error,
                      size: 22.r,
                    ),
                  ),
              ],
            ),
          );
        }),
        SizedBox(height: AppSpacing.xs.h),
        AppButton(
          label: '+ Add Tier',
          variant: ButtonVariant.ghost,
          onPressed: () => onAddTier(tiers.length),
          isFullWidth: true,
          height: ButtonSize.small,
        ),
      ],
    );
  }
}
