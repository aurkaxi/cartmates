import 'package:cartmates/src/imports/core_imports.dart';
import 'package:cartmates/src/imports/packages_imports.dart';

class CampaignsPage extends ConsumerWidget {
  const CampaignsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: AppTopBar(title: 'Campaigns'),
      body: Center(child: Text('Campaigns Page - Placeholder')),
    );
  }
}
