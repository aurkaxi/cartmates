import 'dart:io';
import 'package:cartmates/src/imports/imports.dart';

class ImageUploadSection extends StatelessWidget {
  final File? imageFile;
  final ValueChanged<File?> onImageChanged;

  const ImageUploadSection({
    super.key,
    required this.imageFile,
    required this.onImageChanged,
  });

  Future<void> _pickImage(BuildContext context) async {
    final result = await MediaService.instance.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    result.fold(
      (failure) =>
          showToast(context, message: failure.message, status: 'error'),
      (file) {
        if (file != null) onImageChanged(file);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    if (imageFile != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: AppBorders.lg,
            child: Image.file(
              imageFile!,
              width: double.infinity,
              height: 180.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: AppSpacing.sm.h,
            right: AppSpacing.sm.w,
            child: GestureDetector(
              onTap: () => onImageChanged(null),
              child: Container(
                padding: EdgeInsets.all(AppSpacing.xs.r),
                decoration: BoxDecoration(
                  color: cs.error,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 16.r,
                  color: cs.onError,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        width: double.infinity,
        height: 140.h,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: AppBorders.lg,
          border: Border.all(
            color: cs.outlineVariant,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.md.r),
              decoration: BoxDecoration(
                color: cs.surface,
                shape: BoxShape.circle,
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Icon(
                Icons.add_a_photo_outlined,
                size: 28.r,
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              '+ Upload Image',
              style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
            SizedBox(height: AppSpacing.xxs.h),
            Text(
              'JPG, PNG (Max 5MB)',
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
