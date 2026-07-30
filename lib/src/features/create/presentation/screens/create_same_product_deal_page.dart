import 'package:cartmates/src/imports/imports.dart';
import '../providers/create_deal_provider.dart';
import '../widgets/image_upload_section.dart';
import '../widgets/price_tier_section.dart';
import '../widgets/tier_explanation_card.dart';

class CreateSameProductDealPage extends ConsumerStatefulWidget {
  const CreateSameProductDealPage({super.key});

  @override
  ConsumerState<CreateSameProductDealPage> createState() =>
      _CreateSameProductDealPageState();
}

class _CreateSameProductDealPageState
    extends ConsumerState<CreateSameProductDealPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sourceUrlController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _qtyGoalController = TextEditingController();
  final _pickupLocationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createDealProvider.notifier).initializeTiers();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sourceUrlController.dispose();
    _originalPriceController.dispose();
    _qtyGoalController.dispose();
    _pickupLocationController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _handleCategoryInput(String value) {
    if (value.contains(',')) {
      final parts = value.split(',');
      for (final part in parts) {
        final trimmed = part.trim();
        if (trimmed.isNotEmpty) {
          ref.read(createDealProvider.notifier).addCategory(trimmed);
        }
      }
      final afterLastComma = value.split(',').last.trim();
      _categoryController.text = afterLastComma;
      _categoryController.selection = TextSelection.fromPosition(
        TextPosition(offset: afterLastComma.length),
      );
    }
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null && mounted) {
        final deadline =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        ref.read(createDealProvider.notifier).updateDeadline(deadline);
      }
    }
  }

  void _resetForm() {
    _nameController.clear();
    _sourceUrlController.clear();
    _originalPriceController.clear();
    _qtyGoalController.clear();
    _pickupLocationController.clear();
    _descriptionController.clear();
    _categoryController.clear();
    _formKey.currentState?.reset();
    ref.read(createDealProvider.notifier).reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createDealProvider.notifier).initializeTiers();
    });
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(createDealProvider.notifier).submit();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final state = ref.watch(createDealProvider);

    ref.listen<CreateDealState>(createDealProvider, (prev, next) {
      if (next.createdDeal != null && prev?.createdDeal == null) {
        showToast(context,
            message: 'Deal created successfully!', status: 'success');
        context.push(
            AppRoutes.sameProductDealDetailPath(next.createdDeal!.deal.id));
        _resetForm();
      }
      if (next.error != null && prev?.error == null) {
        showToast(context, message: next.error!, status: 'error');
      }
    });

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const AppTopBar(title: 'New Product Deal'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.md.h),
                    ImageUploadSection(
                      imageFile: state.draft.imageFile,
                      onImageChanged: (file) {
                        ref.read(createDealProvider.notifier).updateImage(file);
                      },
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    AppTextField(
                      label: 'Product Name',
                      hint: 'e.g. Logitech M330',
                      controller: _nameController,
                      onChanged: (v) =>
                          ref.read(createDealProvider.notifier).updateName(v),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (v.length > 100) return 'Max 100 characters';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    _CategoryInput(
                      controller: _categoryController,
                      categories: state.draft.categories,
                      onChanged: _handleCategoryInput,
                      onRemove: (c) => ref
                          .read(createDealProvider.notifier)
                          .removeCategory(c),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    AppTextField(
                      label: 'Source',
                      hint: 'Link or description',
                      controller: _sourceUrlController,
                      onChanged: (v) => ref
                          .read(createDealProvider.notifier)
                          .updateSourceUrl(v),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Original Price',
                            hint: r'$',
                            controller: _originalPriceController,
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              final price = double.tryParse(v) ?? 0;
                              ref
                                  .read(createDealProvider.notifier)
                                  .updateOriginalPrice(price);
                            },
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Required';
                              }
                              final price = double.tryParse(v);
                              if (price == null || price <= 0) {
                                return 'Must be > 0';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: AppTextField(
                            label: 'Qty Cap',
                            hint: 'Max items',
                            controller: _qtyGoalController,
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              final qty = int.tryParse(v) ?? 1;
                              ref
                                  .read(createDealProvider.notifier)
                                  .updateQtyGoal(qty);
                            },
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Required';
                              }
                              final qty = int.tryParse(v);
                              if (qty == null || qty < 1) return 'Must be ≥ 1';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    PriceTierSection(
                      tiers: state.draft.pricingTiers,
                      onAddTier: (_) =>
                          ref.read(createDealProvider.notifier).addTier(),
                      onRemoveTier: (i) =>
                          ref.read(createDealProvider.notifier).removeTier(i),
                      onUpdateTier: (i, {minQty, price}) {
                        ref
                            .read(createDealProvider.notifier)
                            .updateTier(i, minQty: minQty, price: price);
                      },
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    const TierExplanationCard(),
                    SizedBox(height: AppSpacing.md.h),
                    _DeadlinePicker(
                      deadline: state.draft.deadline,
                      onTap: _pickDeadline,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    AppTextField(
                      label: 'Pickup Spot',
                      hint: 'e.g. Library Gate',
                      controller: _pickupLocationController,
                      onChanged: (v) => ref
                          .read(createDealProvider.notifier)
                          .updatePickupLocation(v),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    Text(
                      'Description',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      onChanged: (v) => ref
                          .read(createDealProvider.notifier)
                          .updateDescription(v),
                      style: tt.bodyLarge?.copyWith(color: cs.onSurface),
                      cursorColor: cs.primary,
                      decoration: InputDecoration(
                        hintText: 'Describe the deal...',
                        hintStyle:
                            tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                        border: OutlineInputBorder(
                          borderRadius: AppBorders.sm,
                          borderSide: BorderSide(color: cs.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppBorders.sm,
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppBorders.sm,
                          borderSide: BorderSide(color: cs.primary),
                        ),
                        filled: true,
                        fillColor: cs.surfaceContainerLow,
                      ),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
          _SubmitButton(
            isLoading: state.isLoading,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}

// ── Category Input ──────────────────────────────────────────────────────────

class _CategoryInput extends StatelessWidget {
  final TextEditingController controller;
  final List<String> categories;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onRemove;

  const _CategoryInput({
    required this.controller,
    required this.categories,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        if (categories.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
            child: Wrap(
              spacing: AppSpacing.sm.w,
              runSpacing: AppSpacing.xs.h,
              children: categories
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      deleteIcon: Icon(Icons.close_rounded, size: 16.r),
                      onDeleted: () => onRemove(tag),
                      backgroundColor: cs.primaryContainer,
                      labelStyle:
                          tt.labelSmall?.copyWith(color: cs.onPrimaryContainer),
                      side:
                          BorderSide(color: cs.primary.withValues(alpha: 0.3)),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppBorders.full,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        AppTextField(
          controller: controller,
          hint: 'Type and press comma to add',
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ── Deadline Picker ─────────────────────────────────────────────────────────

class _DeadlinePicker extends StatelessWidget {
  final DateTime deadline;
  final VoidCallback onTap;

  const _DeadlinePicker({required this.deadline, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final now = DateTime.now();
    final isPast = deadline.isBefore(now);
    final displayText = isPast ? 'Select deadline' : _formatDeadline(deadline);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deadline',
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md.w,
              vertical: AppSpacing.md.h,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: AppBorders.sm,
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18.r,
                  color: isPast ? cs.onSurfaceVariant : cs.primary,
                ),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  displayText,
                  style: tt.bodyLarge?.copyWith(
                    color: isPast ? cs.onSurfaceVariant : cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDeadline(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, $hour:$minute $amPm';
  }
}

// ── Submit Button ───────────────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md.w,
        AppSpacing.md.h,
        AppSpacing.md.w,
        AppSpacing.md.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: context.theme.colorScheme.outlineVariant),
        ),
      ),
      child: AppButton(
        label: 'Create Deal',
        onPressed: isLoading ? null : onPressed,
        isLoading: isLoading,
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
