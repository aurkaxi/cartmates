import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/profile/presentation/providers/profile_provider.dart';

class ProfileEditSheet extends ConsumerStatefulWidget {
  final String field;
  final String? currentValue;

  const ProfileEditSheet({
    super.key,
    required this.field,
    this.currentValue,
  });

  @override
  ConsumerState<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends ConsumerState<ProfileEditSheet> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  String get _title =>
      widget.field == 'bkash' ? 'bKash Number' : 'Contact Number';
  String get _hint => widget.field == 'bkash' ? '01XXXXXXXXX' : '01XXXXXXXXX';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final value = _controller.text.trim();
    final notifier = ref.read(profileProvider.notifier);

    if (widget.field == 'bkash') {
      await notifier.updateProfile(bkashNumber: value.isEmpty ? null : value);
    } else {
      await notifier.updateProfile(contactNumber: value.isEmpty ? null : value);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.lg.h,
        AppSpacing.lg.w,
        bottomInset + AppSpacing.lg.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title,
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'Enter your ${_title.toLowerCase()}',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            SizedBox(height: AppSpacing.lg.h),
            AppTextField(
              controller: _controller,
              hint: _hint,
              keyboardType: TextInputType.phone,
              autofocus: true,
              validator: (v) {
                if (v != null &&
                    v.isNotEmpty &&
                    !RegExp(r'^01[3-9]\d{8}$').hasMatch(v)) {
                  return 'Enter a valid Bangladeshi number';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.lg.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    variant: ButtonVariant.outline,
                    height: ButtonSize.medium,
                    isFullWidth: true,
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: AppButton(
                    label: 'Save',
                    onPressed: _isSaving ? null : _save,
                    variant: ButtonVariant.primary,
                    height: ButtonSize.medium,
                    isLoading: _isSaving,
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
