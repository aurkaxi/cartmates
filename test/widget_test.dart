import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cartmates/src/app.dart';

void main() {
  testWidgets('App should build', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(
      const ProviderScope(child: App())
    );

    // Verify that our base app builds successfully.
    expect(find.byType(App), findsOneWidget);
  });
}
