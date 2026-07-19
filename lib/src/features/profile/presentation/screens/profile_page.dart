import 'package:cartmates/src/imports/core_imports.dart';
import 'package:cartmates/src/imports/packages_imports.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: AppTopBar(title: 'Profile'),
      body: Center(child: Text('Profile Page - Placeholder')),
    );
  }
}
