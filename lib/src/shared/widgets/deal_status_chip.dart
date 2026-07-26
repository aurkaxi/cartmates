import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/imports/imports.dart';

enum StatusType { deal, participant }

class DealStatusChip extends StatelessWidget {
  const DealStatusChip({
    super.key,
    required this.status,
    this.size = ChipSize.medium,
    this.type = StatusType.deal,
  });

  final dynamic status; // DealStatus or ParticipantStatus
  final ChipSize size;
  final StatusType type;

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

  Color _backgroundColor(ColorScheme cs, AppColorsExtension ac) {
    if (type == StatusType.deal) {
      return _dealBackgroundColor(cs, ac, status as DealStatus);
    }
    return _participantBackgroundColor(cs, ac, status as ParticipantStatus);
  }

  Color _dealBackgroundColor(
          ColorScheme cs, AppColorsExtension ac, DealStatus s) =>
      switch (s) {
        DealStatus.recruiting => cs.primaryContainer,
        DealStatus.ready => ac.infoContainer ?? cs.primaryContainer,
        DealStatus.ordered => ac.infoContainer ?? cs.primaryContainer,
        DealStatus.arrived => cs.secondaryContainer,
        DealStatus.completed => cs.surfaceContainerHigh,
        DealStatus.expired => ac.warningContainer ?? cs.tertiaryContainer,
        DealStatus.cancelled => cs.errorContainer,
      };

  Color _participantBackgroundColor(
          ColorScheme cs, AppColorsExtension ac, ParticipantStatus s) =>
      switch (s) {
        ParticipantStatus.hold => ac.warningContainer ?? cs.tertiaryContainer,
        ParticipantStatus.confirmed =>
          ac.successContainer ?? cs.secondaryContainer,
        ParticipantStatus.denied => cs.errorContainer,
        ParticipantStatus.ordered => ac.infoContainer ?? cs.primaryContainer,
        ParticipantStatus.arrived => cs.secondaryContainer,
        ParticipantStatus.completed => cs.surfaceContainerHigh,
        ParticipantStatus.expired =>
          ac.warningContainer ?? cs.tertiaryContainer,
        ParticipantStatus.disputed =>
          ac.warningContainer ?? cs.tertiaryContainer,
      };

  Color _textColor(ColorScheme cs, AppColorsExtension ac) {
    if (type == StatusType.deal) {
      return _dealTextColor(cs, ac, status as DealStatus);
    }
    return _participantTextColor(cs, ac, status as ParticipantStatus);
  }

  Color _dealTextColor(ColorScheme cs, AppColorsExtension ac, DealStatus s) =>
      switch (s) {
        DealStatus.recruiting => cs.onPrimaryContainer,
        DealStatus.ready => ac.onInfoContainer ?? cs.onPrimaryContainer,
        DealStatus.ordered => ac.onInfoContainer ?? cs.onPrimaryContainer,
        DealStatus.arrived => cs.onSecondaryContainer,
        DealStatus.completed => cs.onSurfaceVariant,
        DealStatus.expired => ac.onWarningContainer ?? cs.onTertiaryContainer,
        DealStatus.cancelled => cs.onErrorContainer,
      };

  Color _participantTextColor(
          ColorScheme cs, AppColorsExtension ac, ParticipantStatus s) =>
      switch (s) {
        ParticipantStatus.hold =>
          ac.onWarningContainer ?? cs.onTertiaryContainer,
        ParticipantStatus.confirmed =>
          ac.onSuccessContainer ?? cs.onSecondaryContainer,
        ParticipantStatus.denied => cs.onErrorContainer,
        ParticipantStatus.ordered =>
          ac.onInfoContainer ?? cs.onPrimaryContainer,
        ParticipantStatus.arrived => cs.onSecondaryContainer,
        ParticipantStatus.completed => cs.onSurfaceVariant,
        ParticipantStatus.expired =>
          ac.onWarningContainer ?? cs.onTertiaryContainer,
        ParticipantStatus.disputed =>
          ac.onWarningContainer ?? cs.onTertiaryContainer,
      };

  Color _borderColor(ColorScheme cs, AppColorsExtension ac) {
    if (type == StatusType.deal) {
      return _dealBorderColor(cs, ac, status as DealStatus);
    }
    return _participantBorderColor(cs, ac, status as ParticipantStatus);
  }

  Color _dealBorderColor(ColorScheme cs, AppColorsExtension ac, DealStatus s) =>
      switch (s) {
        DealStatus.recruiting => cs.primary,
        DealStatus.ready => ac.info,
        DealStatus.ordered => ac.info,
        DealStatus.arrived => cs.secondary,
        DealStatus.completed => cs.outlineVariant,
        DealStatus.expired => ac.warning,
        DealStatus.cancelled => cs.error,
      };

  Color _participantBorderColor(
          ColorScheme cs, AppColorsExtension ac, ParticipantStatus s) =>
      switch (s) {
        ParticipantStatus.hold => ac.warning,
        ParticipantStatus.confirmed => ac.success,
        ParticipantStatus.denied => cs.error,
        ParticipantStatus.ordered => ac.info,
        ParticipantStatus.arrived => cs.secondary,
        ParticipantStatus.completed => cs.outlineVariant,
        ParticipantStatus.expired => ac.warning,
        ParticipantStatus.disputed => ac.warning,
      };
}

enum ChipSize { small, medium, large }
