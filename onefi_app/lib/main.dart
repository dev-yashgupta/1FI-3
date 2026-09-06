import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Portrait lock only on mobile — allow all orientations on web/desktop
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(
    const ProviderScope(child: OneFiApp()),
  );
}

class OneFiApp extends StatelessWidget {
  const OneFiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '1Fi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
      builder: (context, child) {
        // On web/large screens, center the app in a max-width container
        // to mimic a mobile app rendered in a browser
        return _ResponsiveContainer(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

/// Constrains the app to a max width of 480px on wide screens,
/// centers it, and adds a subtle border — mimicking 1Fi's web preview.
class _ResponsiveContainer extends StatelessWidget {
  final Widget child;
  const _ResponsiveContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // On narrow screens (phones), render full width
    if (screenWidth <= 500) return child;

    // On wide screens (web/tablet), center with max width + shadow
    return ColoredBox(
      color: const Color(0xFFE5E7EB),
      child: Center(
        child: Container(
          width: 420,
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipRect(child: child),
        ),
      ),
    );
  }
}
