import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/routing/app_nav_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: AppNavBar(
        currentRoute: location,
      ),
    );
  }
}
