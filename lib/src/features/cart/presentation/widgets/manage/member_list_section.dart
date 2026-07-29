import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/presentation/providers/manage_order_provider.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/manage/member_tile.dart';

class MemberListSection extends StatelessWidget {
  const MemberListSection({
    super.key,
    required this.members,
    required this.activeTab,
    required this.onTabChanged,
    this.onMemberAction,
  });

  final List<CartItemMember> members;
  final ParticipantStatus? activeTab;
  final ValueChanged<ParticipantStatus?> onTabChanged;
  final ValueChanged<CartItemMember>? onMemberAction;

  @override
  Widget build(BuildContext context) {
    final tabs = _getTabsForMemberStatuses();
    final filteredMembers = _getFilteredMembers();

    return AppCard(
      title: 'Members',
      subtitle: '${members.length} total',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TabBar(
            tabs: tabs,
            activeTab: activeTab,
            onTabChanged: onTabChanged,
          ),
          SizedBox(height: 8.h),
          if (filteredMembers.isEmpty)
            _EmptyState(status: activeTab)
          else
            ...filteredMembers.map(
              (member) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: MemberTile(
                  member: member,
                  onAction: onMemberAction != null
                      ? () => onMemberAction!(member)
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<_TabData> _getTabsForMemberStatuses() {
    final statuses = members.map((m) => m.status).toSet();
    final tabs = <_TabData>[];

    if (statuses.contains(ParticipantStatus.confirmed)) {
      tabs.add(_TabData(
        status: ParticipantStatus.confirmed,
        label: 'Confirmed',
        count: members
            .where((m) => m.status == ParticipantStatus.confirmed)
            .length,
      ));
    }
    if (statuses.contains(ParticipantStatus.hold)) {
      tabs.add(_TabData(
        status: ParticipantStatus.hold,
        label: 'Hold',
        count: members.where((m) => m.status == ParticipantStatus.hold).length,
      ));
    }
    if (statuses.contains(ParticipantStatus.denied)) {
      tabs.add(_TabData(
        status: ParticipantStatus.denied,
        label: 'Denied',
        count:
            members.where((m) => m.status == ParticipantStatus.denied).length,
      ));
    }
    if (statuses.contains(ParticipantStatus.disputed)) {
      tabs.add(_TabData(
        status: ParticipantStatus.disputed,
        label: 'Disputed',
        count:
            members.where((m) => m.status == ParticipantStatus.disputed).length,
      ));
    }

    return tabs;
  }

  List<CartItemMember> _getFilteredMembers() {
    if (activeTab == null) return members;
    return members.where((m) => m.status == activeTab).toList();
  }
}

class _TabData {
  final ParticipantStatus status;
  final String label;
  final int count;

  const _TabData({
    required this.status,
    required this.label,
    required this.count,
  });
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabs,
    required this.activeTab,
    required this.onTabChanged,
  });

  final List<_TabData> tabs;
  final ParticipantStatus? activeTab;
  final ValueChanged<ParticipantStatus?> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _TabChip(
            label: 'All',
            count: tabs.fold(0, (sum, t) => sum + t.count),
            isSelected: activeTab == null,
            onTap: () => onTabChanged(null),
          ),
          ...tabs.map(
            (tab) => Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: _TabChip(
                label: tab.label,
                count: tab.count,
                isSelected: activeTab == tab.status,
                onTap: () => onTabChanged(tab.status),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primaryContainer : cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: 1,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: tt.labelMedium?.copyWith(
            color: isSelected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.status});

  final ParticipantStatus? status;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 32.sp,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 8.h),
            Text(
              status == null
                  ? 'No members yet'
                  : 'No ${status!.label.toLowerCase()} members',
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
