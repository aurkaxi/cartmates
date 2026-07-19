import 'package:cartmates/src/imports/imports.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.currentRoute,
  });

  final String currentRoute;

  static const _tabs = [
    _TabItem(
      route: AppRoutes.create,
      label: 'Create',
      filledIcon: Icons.add_circle,
      outlinedIcon: Icons.add_circle_outline,
    ),
    _TabItem(
      route: AppRoutes.cart,
      label: 'Cart',
      filledIcon: Icons.shopping_cart,
      outlinedIcon: Icons.shopping_cart_outlined,
    ),
    _TabItem(
      route: AppRoutes.deals,
      label: 'Deals',
      filledIcon: Icons.local_offer,
      outlinedIcon: Icons.local_offer_outlined,
    ),
    _TabItem(
      route: AppRoutes.campaigns,
      label: 'Campaigns',
      filledIcon: Icons.campaign,
      outlinedIcon: Icons.campaign_outlined,
    ),
    _TabItem(
      route: AppRoutes.profile,
      label: 'Profile',
      filledIcon: Icons.person,
      outlinedIcon: Icons.person_outline,
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
      child: Container(
        height:
            kBottomNavigationBarHeight + MediaQuery.paddingOf(context).bottom,
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(top: BorderSide(color: cs.outlineVariant)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabs.length, (index) {
            final tab = _tabs[index];
            final isActive = index == _currentIndex;
            return _NavItem(
              onTap: () => context.go(tab.route),
              isActive: isActive,
              filledIcon: tab.filledIcon,
              outlinedIcon: tab.outlinedIcon,
              cs: cs,
              label: tab.label,
            );
          }),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.route,
    required this.label,
    required this.filledIcon,
    required this.outlinedIcon,
  });

  final String route;
  final String label;
  final IconData filledIcon;
  final IconData outlinedIcon;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.onTap,
    required this.isActive,
    required this.filledIcon,
    required this.outlinedIcon,
    required this.cs,
    required this.label,
  });

  final VoidCallback onTap;
  final bool isActive;
  final IconData filledIcon;
  final IconData outlinedIcon;
  final ColorScheme cs;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? filledIcon : outlinedIcon,
              size: 24.sp,
              color: isActive ? cs.primary : cs.onSurfaceVariant,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
