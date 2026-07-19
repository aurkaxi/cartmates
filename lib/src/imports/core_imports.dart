// Flutter SDK
export 'package:flutter/cupertino.dart' hide RefreshCallback;
export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter_native_splash/flutter_native_splash.dart';

// Project Core — everything exported through shared.dart (theme, extensions,
// utils, widgets, enums) plus routing and services.
export '../config/app_config.dart';
export '../features/auth/presentation/screens/forgot_password_screen.dart';
export '../features/auth/presentation/screens/login_screen.dart';
export '../features/auth/presentation/screens/signup_screen.dart';
export '../features/campaigns/presentation/screens/campaigns_page.dart';
export '../features/cart/presentation/screens/cart_page.dart';
export '../features/create/presentation/screens/create_page.dart';
export '../features/deals/presentation/screens/deals_page.dart';
export '../features/onboarding/presentation/screens/onboarding_page.dart';
export '../features/profile/presentation/screens/profile_page.dart';
export '../routing/routing.dart';
export '../services/services.dart';
export '../shared/shared.dart';
