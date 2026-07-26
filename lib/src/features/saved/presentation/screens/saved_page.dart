import 'package:cartmates/src/imports/imports.dart';
import '../providers/saved_deals_provider.dart';
import '../widgets/saved_deal_tile.dart';

class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final savedDeals = ref.watch(savedDealsProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const AppTopBar(title: 'Saved'),
      body: savedDeals.when(
        data: (deals) {
          if (deals.isEmpty) {
            return const AppEmptyState(
              icon: HugeIcons.strokeRoundedBookmark01,
              title: 'No saved deals',
              subtitle: 'Bookmark deals you like and they will appear here.',
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: deals.length,
            itemBuilder: (context, index) {
              return SavedDealTile(deal: deals[index]);
            },
          );
        },
        loading: () => const AppLoading(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(savedDealsProvider),
        ),
      ),
    );
  }
}
