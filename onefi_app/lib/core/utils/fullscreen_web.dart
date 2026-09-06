// Web fullscreen implementation using the browser Fullscreen API.
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' as web;

bool get isFullscreen => web.document.fullscreenElement != null;

void requestFullscreen() {
  web.document.documentElement?.requestFullscreen();
}

void exitFullscreen() {
  web.document.exitFullscreen();
}

void toggleFullscreen() {
  if (isFullscreen) {
    exitFullscreen();
  } else {
    requestFullscreen();
  }
}
