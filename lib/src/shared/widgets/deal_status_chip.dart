import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/imports/imports.dart';

class DealStatusChip extends StatelessWidget {
  const DealStatusChip({
    super.key,
    required this.status,
    this.size = ChipSize.medium,
  });

  final DealStatus status;
  final ChipSize size;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final ac = context.appColors;
    final tt = context.textTheme;

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor(cs, ac),
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: _borderColor(cs, ac), width: 1),
      ),
      child: Text(
        status.label,
        style: _textStyle(tt, cs, ac),
      ),
    );
  }

  EdgeInsets get _padding => switch (size) {
        ChipSize.small => EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        ChipSize.medium =>
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        ChipSize.large => EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      };

  double get _radius => switch (size) {
        ChipSize.small => 12.r,
        ChipSize.medium => 16.r,
        ChipSize.large => 20.r,
      };

  TextStyle _textStyle(TextTheme tt, ColorScheme cs, AppColorsExtension ac) =>
      switch (size) {
        ChipSize.small => tt.labelSmall?.copyWith(color: _textColor(cs, ac)) ??
            TextStyle(fontSize: 10, color: _textColor(cs, ac)),
        ChipSize.medium =>
          tt.labelMedium?.copyWith(color: _textColor(cs, ac)) ??
              TextStyle(fontSize: 12, color: _textColor(cs, ac)),
        ChipSize.large => tt.labelLarge?.copyWith(color: _textColor(cs, ac)) ??
            TextStyle(fontSize: 14, color: _textColor(cs, ac)),
      };

  Color _backgroundColor(ColorScheme cs, AppColorsExtension ac) =>
      switch (status) {
        DealStatus.recruiting => cs.primaryContainer,
        DealStatus.interested => cs.tertiaryContainer,
        DealStatus.hold => ac.warningContainer ?? cs.tertiaryContainer,
        DealStatus.confirmed => ac.successContainer ?? cs.secondaryContainer,
        DealStatus.ordered => ac.infoContainer ?? cs.primaryContainer,
        DealStatus.arrived => cs.secondaryContainer,
        DealStatus.completed => cs.surfaceContainerHigh,
      };

  Color _textColor(ColorScheme cs, AppColorsExtension ac) => switch (status) {
        DealStatus.recruiting => cs.onPrimaryContainer,
        DealStatus.interested => cs.onTertiaryContainer,
        DealStatus.hold => ac.onWarningContainer ?? cs.onTertiaryContainer,
        DealStatus.confirmed =>
          ac.onSuccessContainer ?? cs.onSecondaryContainer,
        DealStatus.ordered => ac.onInfoContainer ?? cs.onPrimaryContainer,
        DealStatus.arrived => cs.onSecondaryContainer,
        DealStatus.completed => cs.onSurfaceVariant,
      };

  Color _borderColor(ColorScheme cs, AppColorsExtension ac) => switch (status) {
        DealStatus.recruiting => cs.primary,
        DealStatus.interested => cs.tertiary,
        DealStatus.hold => ac.warning,
        DealStatus.confirmed => ac.success,
        DealStatus.ordered => ac.info,
        DealStatus.arrived => cs.secondary,
        DealStatus.completed => cs.outlineVariant,
      };
}

enum ChipSize { small, medium, large }
