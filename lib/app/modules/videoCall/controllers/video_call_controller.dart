import 'dart:async';
import 'package:get/get.dart';

class VideoCallController extends GetxController {
  var showingControls = true.obs; // Reactive boolean for control visibility
  Timer? _hideControlsTimer;

  // Function to show controls and start the timer to hide them
  void showControls() {
    showingControls.value = true;

    // Cancel any previous timer and start a new one
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 1), () {
      showingControls.value = false;
    });
  }

  @override
  void onClose() {
    _hideControlsTimer
        ?.cancel(); // Cancel the timer when the controller is destroyed
    super.onClose();
  }
}
