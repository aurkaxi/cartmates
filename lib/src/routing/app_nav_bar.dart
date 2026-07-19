import 'package:cartmates/src/imports/imports.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.currentRoute,
  });

  final String currentRoute;

  static const List<_NavTab> _tabs = [
    _NavTab(
      route: AppRoutes.create,
      label: 'Create',
      icon: Icons.add_circle_outline,
      selectedIcon: Icons.add_circle,
    ),
    _NavTab(
      route: AppRoutes.cart,
      label: 'Cart',
      icon: Icons.shopping_cart_outlined,
      selectedIcon: Icons.shopping_cart,
    ),
    _NavTab(
      route: AppRoutes.deals,
      label: 'Deals',
      icon: Icons.local_offer_outlined,
      selectedIcon: Icons.local_offer,
    ),
    _NavTab(
      route: AppRoutes.campaigns,
      label: 'Campaigns',
      icon: Icons.campaign_outlined,
      selectedIcon: Icons.campaign,
    ),
    _NavTab(
      route: AppRoutes.profile,
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];

  int get _currentIndex {
    for (var i = 0; i < _tabs.length; i++) {
      if (currentRoute.startsWith(_tabs[i].route)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return SafeArea(
      top: false,
      child: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => context.go(_tabs[index].route),
        height: kBottomNavigationBarHeight,
        indicatorColor: cs.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.route,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String route;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
