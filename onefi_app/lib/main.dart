import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';

// Conditional import — web uses dart:js_interop, others use a no-op stub
import 'core/utils/fullscreen_stub.dart'
    if (dart.library.js_interop) 'core/utils/fullscreen_web.dart'
    as fs;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(const ProviderScope(child: OneFiApp()));
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
      builder: (context, child) =>
          _ResponsiveContainer(child: child ?? const SizedBox.shrink()),
    );
  }
}

// ─── Responsive container with fullscreen button ──────────────────────────────

class _ResponsiveContainer extends StatefulWidget {
  final Widget child;
  const _ResponsiveContainer({required this.child});

  @override
  State<_ResponsiveContainer> createState() => _ResponsiveContainerState();
}

class _ResponsiveContainerState extends State<_ResponsiveContainer> {
  bool _fullscreen = false;

  void _toggle() {
    fs.toggleFullscreen();
    setState(() => _fullscreen = !_fullscreen);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // On narrow screens (phones/small tablets) — render full width, no button
    if (screenWidth <= 500) return widget.child;

    // Fullscreen mode — fill the entire browser window
    if (_fullscreen) {
      return Stack(
        children: [
          widget.child,
          Positioned(
            top: 12,
            right: 12,
            child: _FullscreenButton(
              isFullscreen: true,
              onTap: _toggle,
            ),
          ),
        ],
      );
    }

    // Normal mode — centered 420px phone frame
    return ColoredBox(
      color: const Color(0xFFE5E7EB),
      child: Stack(
        children: [
          // Background pattern — subtle grid dots
          Positioned.fill(child: _WebBackground()),

          // Phone frame
          Center(
            child: Container(
              width: 420,
              constraints: const BoxConstraints(maxWidth: 420),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ClipRect(child: widget.child),
            ),
          ),

          // Fullscreen button — top-right corner
          Positioned(
            top: 16,
            right: 16,
            child: _FullscreenButton(
              isFullscreen: false,
              onTap: _toggle,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Fullscreen button ────────────────────────────────────────────────────────

class _FullscreenButton extends StatefulWidget {
  final bool isFullscreen;
  final VoidCallback onTap;
  const _FullscreenButton({
    required this.isFullscreen,
    required this.onTap,
  });

  @override
  State<_FullscreenButton> createState() => _FullscreenButtonState();
}

class _FullscreenButtonState extends State<_FullscreenButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    lowerBound: 0.9,
    upperBound: 1.0,
    value: 1.0,
  );

  bool _hovered = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.reverse(),
        onTapUp: (_) {
          _ctrl.forward();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.forward(),
        child: ScaleTransition(
          scale: _ctrl,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.primary
                  : Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _hovered
                    ? AppColors.primaryLight
                    : Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isFullscreen
                      ? Icons.fullscreen_exit_rounded
                      : Icons.fullscreen_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.isFullscreen ? 'Exit Fullscreen' : 'Fullscreen',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Web background ───────────────────────────────────────────────────────────

class _WebBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotGridPainter(),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeCap = StrokeCap.round;

    const spacing = 24.0;
    const radius  = 1.2;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => false;
}
