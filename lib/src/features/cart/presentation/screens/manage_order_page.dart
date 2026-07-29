import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/presentation/providers/manage_order_provider.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/manage/deal_header_card.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/manage/manage_action_banner.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/manage/member_list_section.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/manage/deal_status_actions.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/manage/broadcast_section.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/manage/manage_deal_timeline.dart';

class ManageOrderPage extends ConsumerStatefulWidget {
  const ManageOrderPage({super.key, required this.dealId});

  final String dealId;

  @override
  ConsumerState<ManageOrderPage> createState() => _ManageOrderPageState();
}

class _ManageOrderPageState extends ConsumerState<ManageOrderPage> {
  ParticipantStatus? _activeTab;

  @override
  Widget build(BuildContext context) {
    final itemAsync = ref.watch(manageOrderItemProvider(widget.dealId));
    final dealDetail = getMockManageDealDetail(widget.dealId);
    final members = getMockMembers(widget.dealId);

    return Scaffold(
      appBar: AppTopBar(title: dealDetail.deal.name),
      body: itemAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Deal not found'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ManageActionBanner(
                  members: members,
                  dealStatus: item.dealStatus,
                  onResolveDisputes: () {
                    context.showTypedSnackBar(
                      'Review disputes',
                      type: SnackBarType.info,
                    );
                  },
                ),
                SizedBox(height: AppSpacing.md),
                DealHeaderCard(
                  item: item,
                  dealDetail: dealDetail,
                ),
                SizedBox(height: AppSpacing.md),
                MemberListSection(
                  members: members,
                  activeTab: _activeTab,
                  onTabChanged: (tab) => setState(() => _activeTab = tab),
                  onMemberAction: (member) {
                    _showMemberActions(context, member);
                  },
                ),
                SizedBox(height: AppSpacing.md),
                DealStatusActions(
                  item: item,
                  onAction: () {
                    _showStatusChangeConfirmation(context, item);
                  },
                  onTrackingUpdate: () {
                    _showTrackingUpdateDialog(context, item);
                  },
                ),
                SizedBox(height: AppSpacing.md),
                BroadcastSection(
                  updates: dealDetail.updates,
                  onBroadcast: (message) {
                    context.showTypedSnackBar(
                      'Broadcast sent: $message',
                      type: SnackBarType.success,
                    );
                  },
                ),
                SizedBox(height: AppSpacing.md),
                ManageDealTimeline(
                  events: item.timelineEvents,
                  dealStatus: item.dealStatus,
                ),
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showMemberActions(BuildContext context, CartItemMember member) {
    final cs = context.colors;
    final tt = context.textTheme;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h),
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              member.name,
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${member.quantity} items • \$${member.totalPaid.toStringAsFixed(0)}',
              style: tt.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 16.h),
            if (member.status == ParticipantStatus.hold) ...[
              ListTile(
                leading: Icon(Icons.check_circle, color: cs.primary),
                title: Text(
                  'Confirm Payment',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.showTypedSnackBar(
                    'Payment confirmed for ${member.name}',
                    type: SnackBarType.success,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: cs.error),
                title: Text(
                  'Reject Payment',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.showTypedSnackBar(
                    'Payment rejected for ${member.name}',
                    type: SnackBarType.error,
                  );
                },
              ),
            ] else if (member.status == ParticipantStatus.denied) ...[
              ListTile(
                leading: Icon(Icons.info_outline, color: cs.error),
                title: Text(
                  'View Rejection Reason',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.showTypedSnackBar(
                    'Payment rejected - review pending',
                    type: SnackBarType.info,
                  );
                },
              ),
            ] else if (member.status == ParticipantStatus.disputed) ...[
              ListTile(
                leading: Icon(Icons.gavel, color: cs.tertiary),
                title: Text(
                  'View Dispute',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.showTypedSnackBar(
                    'Viewing dispute for ${member.name}',
                    type: SnackBarType.info,
                  );
                },
              ),
            ] else if (member.status == ParticipantStatus.confirmed) ...[
              ListTile(
                leading: Icon(Icons.info_outline, color: cs.primary),
                title: Text(
                  'View Details',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.showTypedSnackBar(
                    'Viewing details for ${member.name}',
                    type: SnackBarType.info,
                  );
                },
              ),
            ],
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  void _showStatusChangeConfirmation(BuildContext context, dynamic item) {
    final cs = context.colors;
    final tt = context.textTheme;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cs.surfaceContainerLow,
        titleTextStyle: tt.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
        contentTextStyle: tt.bodyMedium?.copyWith(color: cs.onSurface),
        title: const Text('Confirm Status Change'),
        content: Text(
          'Are you sure you want to mark this deal as ${_getNextStatus(item.dealStatus)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: cs.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.showTypedSnackBar(
                'Deal status updated to ${_getNextStatus(item.dealStatus)}',
                type: SnackBarType.success,
              );
            },
            child: Text('Confirm', style: TextStyle(color: cs.primary)),
          ),
        ],
      ),
    );
  }

  void _showTrackingUpdateDialog(BuildContext context, dynamic item) {
    final numberController = TextEditingController(
      text: item.trackingNumber ?? '',
    );
    final urlController = TextEditingController(
      text: item.trackingUrl ?? '',
    );
    final cs = context.colors;
    final tt = context.textTheme;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cs.surfaceContainerLow,
        titleTextStyle: tt.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
        contentTextStyle: tt.bodyMedium?.copyWith(color: cs.onSurface),
        title: const Text('Update Tracking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              style: tt.bodyMedium?.copyWith(color: cs.onSurface),
              decoration: InputDecoration(
                labelText: 'Tracking Number',
                hintText: 'Enter tracking number',
                labelStyle: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                hintStyle: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: urlController,
              style: tt.bodyMedium?.copyWith(color: cs.onSurface),
              decoration: InputDecoration(
                labelText: 'Tracking URL',
                hintText: 'https://carrier.com/track/...',
                labelStyle: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                hintStyle: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: cs.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.showTypedSnackBar(
                'Tracking updated',
                type: SnackBarType.success,
              );
            },
            child: Text('Save', style: TextStyle(color: cs.primary)),
          ),
        ],
      ),
    );
  }

  String _getNextStatus(DealStatus current) {
    return switch (current) {
      DealStatus.recruiting => 'Ready',
      DealStatus.ready => 'Ordered',
      DealStatus.ordered => 'Arrived',
      DealStatus.arrived => 'Completed',
      _ => current.label,
    };
  }
}
