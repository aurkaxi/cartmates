import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/deals/domain/entities/same_product_deal_detail.dart';

class BroadcastSection extends StatefulWidget {
  const BroadcastSection({
    super.key,
    required this.updates,
    this.onBroadcast,
  });

  final List<SameProductDealUpdate> updates;
  final ValueChanged<String>? onBroadcast;

  @override
  State<BroadcastSection> createState() => _BroadcastSectionState();
}

class _BroadcastSectionState extends State<BroadcastSection> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Updates',
      subtitle: 'Broadcast to all members',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BroadcastInput(
            controller: _controller,
            focusNode: _focusNode,
            onSend: () {
              if (_controller.text.trim().isNotEmpty) {
                widget.onBroadcast?.call(_controller.text.trim());
                _controller.clear();
                _focusNode.unfocus();
              }
            },
          ),
          if (widget.updates.isNotEmpty) ...[
            SizedBox(height: 12.h),
            ...widget.updates.map(
              (update) => _UpdateItem(update: update),
            ),
          ],
        ],
      ),
    );
  }
}

class _BroadcastInput extends StatelessWidget {
  const _BroadcastInput({
    required this.controller,
    required this.focusNode,
    this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: null,
              style: context.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Type an update for members...',
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
              ),
              onSubmitted: (_) => onSend?.call(),
            ),
          ),
          IconButton(
            onPressed: onSend,
            icon: Icon(
              Icons.send,
              color: cs.primary,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateItem extends StatelessWidget {
  const _UpdateItem({required this.update});

  final SameProductDealUpdate update;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.campaign_outlined,
                  size: 14.sp,
                  color: cs.primary,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Host',
                  style: tt.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTimestamp(update.timestamp),
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              update.message,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${timestamp.month}/${timestamp.day}';
  }
}
