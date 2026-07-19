import 'package:cartmates/src/imports/core_imports.dart';
import 'package:cartmates/src/imports/packages_imports.dart';

class CreatePage extends ConsumerWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: AppTopBar(title: 'Create'),
      body: Center(child: Text('Create Page - Placeholder')),
    );
  }
}
