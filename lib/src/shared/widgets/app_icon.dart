import '../../imports/imports.dart';

/// A wrapper widget that handles different icon libraries.
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
  });

  /// The icon to display.
  final List<List<dynamic>> icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return HugeIcon(
      icon: icon,
      size: size,
      color: color,
    );
  }
}
