import 'package:cartmates/src/imports/imports.dart';

class OrderStatusPage extends ConsumerWidget {
  const OrderStatusPage({super.key, required this.dealId});

  final String dealId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Order Status'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 64.r,
              color: context.colors.onSurfaceVariant,
            ),
            SizedBox(height: 16.h),
            Text(
              'Order Status Page',
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Deal ID: $dealId',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Coming soon...',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
