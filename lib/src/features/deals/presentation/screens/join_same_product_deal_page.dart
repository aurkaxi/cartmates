import 'dart:io';

import 'package:cartmates/src/imports/imports.dart';

import '../../domain/entities/deal.dart';
import '../../domain/entities/same_product_deal_detail.dart';

class JoinSameProductDealPage extends ConsumerStatefulWidget {
  final String dealId;

  const JoinSameProductDealPage({super.key, required this.dealId});

  @override
  ConsumerState<JoinSameProductDealPage> createState() =>
      _JoinSameProductDealPageState();
}

class _JoinSameProductDealPageState
    extends ConsumerState<JoinSameProductDealPage> {
  int _quantity = 1;
  String _paymentMethod = 'bkash';
  File? _paymentProof;

  SameProductDealDetail? _detail;

  @override
  void initState() {
    super.initState();
    _detail = _getMockJoinDealDetail(widget.dealId);
  }

  SameProductPricingTier get _activeTier {
    if (_detail == null) {
      return const SameProductPricingTier(minQty: 1, price: 0);
    }
    final totalQty = _detail!.deal.qtyCurrent + _quantity;
    final sorted = _detail!.pricingTiers.toList()
      ..sort((a, b) => a.minQty.compareTo(b.minQty));
    for (final tier in sorted.reversed) {
      if (totalQty >= tier.minQty) return tier;
    }
    return sorted.first;
  }

  int get _unitsLeft {
    if (_detail == null) return 0;
    return _detail!.deal.qtyGoal - _detail!.deal.qtyCurrent;
  }

  double get _totalAmount => _quantity * _activeTier.price;

  Future<void> _pickImage() async {
    final result = await MediaService.instance.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    result.fold(
      (failure) =>
          showToast(context, message: failure.message, status: 'error'),
      (file) {
        if (file != null) {
          setState(() => _paymentProof = file);
        }
      },
    );
  }

  void _handleSubmit() {
    if (_paymentMethod == 'bkash' && _paymentProof == null) {
      // showToast(
      //   context,
      //   message: 'Please upload payment proof',
      //   status: 'warning',
      // );
      return;
    }
    // showToast(
    //   context,
    //   message: 'Payment submitted successfully!',
    //   status: 'success',
    // );
    context.go(AppRoutes.cart);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    if (_detail == null) {
      return Scaffold(
        backgroundColor: cs.surface,
        body: const Center(child: Text('Deal not found')),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const AppTopBar(title: 'Join Deal'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSpacing.md.h),
                  _ProductCard(
                    detail: _detail!,
                    activeTier: _activeTier,
                    quantity: _quantity,
                    unitsLeft: _unitsLeft,
                    onQuantityChanged: (q) => setState(() => _quantity = q),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  _PaymentInstructionSection(
                    paymentMethod: _paymentMethod,
                    host: _detail!.host,
                    totalAmount: _totalAmount,
                    onPaymentMethodChanged: (m) =>
                        setState(() => _paymentMethod = m),
                  ),
                  if (_paymentMethod == 'bkash') ...[
                    SizedBox(height: AppSpacing.lg.h),
                    _PaymentProofSection(
                      paymentProof: _paymentProof,
                      onPickImage: _pickImage,
                      onRemoveImage: () => setState(() => _paymentProof = null),
                    ),
                  ],
                  SizedBox(height: AppSpacing.md.h),
                  _HoldWarningBanner(),
                  SizedBox(height: AppSpacing.xxl.h),
                ],
              ),
            ),
          ),
          _SubmitButton(onPressed: _handleSubmit),
        ],
      ),
    );
  }
}

// ── Product Card ─────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final SameProductDealDetail detail;
  final SameProductPricingTier activeTier;
  final int quantity;
  final int unitsLeft;
  final ValueChanged<int> onQuantityChanged;

  const _ProductCard({
    required this.detail,
    required this.activeTier,
    required this.quantity,
    required this.unitsLeft,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final sorted = detail.pricingTiers.toList()
      ..sort((a, b) => a.minQty.compareTo(b.minQty));

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: AppBorders.lg,
        color: cs.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.deal.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tt.titleMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          SizedBox(
            height: 72.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sorted.length,
              separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm.w),
              itemBuilder: (context, index) {
                final tier = sorted[index];
                final isActive = tier.minQty == activeTier.minQty;
                return _PricingTierCard(
                  tier: tier,
                  isActive: isActive,
                );
              },
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity Needed',
                    style: tt.titleMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs.h),
                  Row(
                    children: [
                      Text(
                        '\$${activeTier.price.toStringAsFixed(2)} / unit',
                        style: tt.labelSmall?.copyWith(color: cs.primary),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      Text(
                        '•',
                        style: tt.labelSmall?.copyWith(
                          color: cs.outlineVariant,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      Text(
                        '$unitsLeft units left',
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _QuantityStepper(
                quantity: quantity,
                max: unitsLeft,
                onChanged: onQuantityChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Pricing Tier Card ────────────────────────────────────────────────────────

class _PricingTierCard extends StatelessWidget {
  final SameProductPricingTier tier;
  final bool isActive;

  const _PricingTierCard({required this.tier, required this.isActive});

  String get _label {
    if (tier.minQty == 1) return '1-9 units';
    if (tier.minQty == 10) return '10-19 units';
    return '${tier.minQty}+ units';
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      width: 120.w,
      padding: EdgeInsets.all(AppSpacing.sm.r),
      decoration: BoxDecoration(
        border: Border.all(
          color: isActive ? cs.primary : cs.outlineVariant,
          width: isActive ? 2 : 1,
        ),
        borderRadius: AppBorders.lg,
        color: isActive ? cs.primary.withValues(alpha: 0.05) : cs.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _label,
            style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          SizedBox(height: AppSpacing.xxs.h),
          Text(
            '\$${tier.price.toStringAsFixed(0)}',
            style: tt.titleMedium?.copyWith(
              color: isActive ? cs.primary : cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quantity Stepper ─────────────────────────────────────────────────────────

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final int max;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({
    required this.quantity,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xxs.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: AppBorders.full,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove_rounded,
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
            child: Text(
              '$quantity',
              style: tt.titleMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            onTap: quantity < max ? () => onChanged(quantity + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: isDisabled ? cs.surfaceContainerHighest : cs.surface,
          shape: BoxShape.circle,
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18.r,
            color: isDisabled ? cs.outline : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── Payment Instruction Section ──────────────────────────────────────────────

class _PaymentInstructionSection extends StatelessWidget {
  final String paymentMethod;
  final SameProductDealHostInfo host;
  final double totalAmount;
  final ValueChanged<String> onPaymentMethodChanged;

  const _PaymentInstructionSection({
    required this.paymentMethod,
    required this.host,
    required this.totalAmount,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final phoneNumber = paymentMethod == 'bkash'
        ? (host.bkashNumber ?? 'N/A')
        : (host.contactNumber ?? 'N/A');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Instruction',
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        Container(
          padding: EdgeInsets.all(AppSpacing.md.r),
          decoration: BoxDecoration(
            color: cs.secondaryContainer,
            borderRadius: AppBorders.lg,
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pay to host',
                style: tt.labelSmall?.copyWith(
                  color: cs.onSecondaryContainer,
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
              _PaymentMethodDropdown(
                value: paymentMethod,
                onChanged: onPaymentMethodChanged,
              ),
              SizedBox(height: AppSpacing.md.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: cs.onSecondaryContainer,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: copy to clipboard
                    },
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.sm.r),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedCopy01,
                        size: 18.r,
                        color: cs.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                child: const AppDivider(),
              ),
              Text(
                'Total Amount',
                style: tt.labelSmall?.copyWith(
                  color: cs.onSecondaryContainer,
                ),
              ),
              SizedBox(height: AppSpacing.xxs.h),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Payment Method Dropdown ──────────────────────────────────────────────────

class _PaymentMethodDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _PaymentMethodDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppBorders.sm,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedArrowDown01,
          size: 18.r,
          color: cs.onSurfaceVariant,
        ),
        style: tt.bodyMedium?.copyWith(color: cs.onSurface),
        items: const [
          DropdownMenuItem(value: 'bkash', child: Text('bKash')),
          DropdownMenuItem(value: 'cash', child: Text('Cash')),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

// ── Payment Proof Section ────────────────────────────────────────────────────

class _PaymentProofSection extends StatelessWidget {
  final File? paymentProof;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const _PaymentProofSection({
    required this.paymentProof,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Proof',
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          'Upload a screenshot of your payment transfer for verification.',
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        SizedBox(height: AppSpacing.md.h),
        if (paymentProof != null)
          _ImagePreview(
            file: paymentProof!,
            onRemove: onRemoveImage,
          )
        else
          _UploadArea(onTap: onPickImage),
      ],
    );
  }
}

// ── Upload Area ──────────────────────────────────────────────────────────────

class _UploadArea extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadArea({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl.h),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: AppBorders.lg,
          border: Border.all(
            color: cs.outlineVariant,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.md.r),
              decoration: BoxDecoration(
                color: cs.surface,
                shape: BoxShape.circle,
                border: Border.all(color: cs.outlineVariant),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedUpload04,
                size: 32.r,
                color: cs.primary,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              'Click to upload',
              style: tt.labelLarge?.copyWith(color: cs.onSurface),
            ),
            SizedBox(height: AppSpacing.xxs.h),
            Text(
              'JPG, PNG (Max 5MB)',
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Image Preview ────────────────────────────────────────────────────────────

class _ImagePreview extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const _ImagePreview({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: AppBorders.lg,
          child: Image.file(
            file,
            width: double.infinity,
            height: 200.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: AppSpacing.sm.h,
          right: AppSpacing.sm.w,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: EdgeInsets.all(AppSpacing.xs.r),
              decoration: BoxDecoration(
                color: cs.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 16.r,
                color: cs.onError,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Hold Warning Banner ──────────────────────────────────────────────────────

class _HoldWarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: AppBorders.sm,
        border: Border.all(color: cs.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedInformationCircle,
            size: 18.r,
            color: cs.error,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                children: [
                  const TextSpan(text: 'You will be marked as '),
                  WidgetSpan(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: cs.error.withValues(alpha: 0.1),
                        borderRadius: AppBorders.xs,
                      ),
                      child: Text(
                        'Hold',
                        style: tt.labelSmall?.copyWith(
                          color: cs.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text: ' until the host verifies your payment.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Submit Button ────────────────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md.w,
        AppSpacing.md.h,
        AppSpacing.md.w,
        AppSpacing.md.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: AppButton(
        label: 'Submit',
        onPressed: onPressed,
        isFullWidth: true,
        suffixIcon: HugeIcon(
          icon: HugeIcons.strokeRoundedArrowRight01,
          size: 18.r,
          color: context.theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}

// ── Mock Data ────────────────────────────────────────────────────────────────

SameProductDealDetail? _getMockJoinDealDetail(String dealId) {
  return SameProductDealDetail(
    deal: const SameProductDeal(
      id: '1',
      name: 'Sony WH-1000XM5 Noise Canceling Headphones - Bulk Order',
      imageUrl: 'https://picsum.photos/seed/sonyxm5/800/600',
      currentPrice: 249,
      originalPrice: 399,
      qtyCurrent: 15,
      qtyGoal: 25,
      confirmedQty: 10,
      holdQty: 5,
      timeRemaining: Duration(hours: 48),
      savingsPercentage: 37,
    ),
    description: 'Bulk order for Sony WH-1000XM5 headphones.',
    source: 'https://www.amazon.com/dp/B09XS7JWHH',
    categoryTags: const ['TECH & AUDIO', 'SAME PRODUCT'],
    host: const SameProductDealHostInfo(
      name: 'Alex Chen',
      avatarUrl: 'https://picsum.photos/seed/alexchen/200/200',
      reputationPoints: 1247,
      successCount: 12,
      failCount: 1,
      bkashNumber: '01712345678',
      contactNumber: '01812345678',
    ),
    deadline: DateTime(2026, 10, 27, 17, 0),
    pickupLocation: 'Student Union',
    pickupDetail: 'Room 204',
    pricingTiers: const [
      SameProductPricingTier(minQty: 1, price: 249),
      SameProductPricingTier(minQty: 10, price: 219),
      SameProductPricingTier(minQty: 20, price: 199),
    ],
  );
}
