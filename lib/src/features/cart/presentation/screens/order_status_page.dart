import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/presentation/providers/order_status_provider.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/order_summary_card.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/deal_progress_card.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/host_info_card.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/order_timeline.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/pickup_location_card.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/action_banner.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/host_updates_feed.dart';

class OrderStatusPage extends ConsumerWidget {
  const OrderStatusPage({super.key, required this.dealId});

  final String dealId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(orderStatusItemProvider(dealId));
    final dealDetail = getMockDealDetail(dealId);

    return Scaffold(
      appBar: AppTopBar(title: dealDetail.deal.name),
      body: itemAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Order not found'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActionBanner(
                  item: item,
                  onAction: () {
                    context.showTypedSnackBar(
                      'Action triggered for ${item.name}',
                      type: SnackBarType.info,
                    );
                  },
                ),
                SizedBox(height: AppSpacing.md),
                OrderSummaryCard(item: item),
                SizedBox(height: AppSpacing.md),
                OrderTimeline(events: item.timelineEvents),
                SizedBox(height: AppSpacing.md),
                HostUpdatesFeed(updates: dealDetail.updates),
                SizedBox(height: AppSpacing.md),
                HostInfoCard(host: dealDetail.host),
                SizedBox(height: AppSpacing.md),
                PickupLocationCard(dealDetail: dealDetail),
                SizedBox(height: AppSpacing.md),
                DealProgressCard(dealDetail: dealDetail),
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
