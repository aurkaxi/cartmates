import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/routing/app_nav_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final hideBottomNav =
        location.contains('/detail') || location.contains('/order/');

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: hideBottomNav
          ? null
          : AppNavBar(
              navigationShell: navigationShell,
              currentRoute: location,
            ),
    );
  }
}
