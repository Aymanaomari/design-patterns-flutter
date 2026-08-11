import 'dart:async';

class TimerHandler {
  TimerHandler({required this.interval, required this.onTick});

  final Duration interval;
  final void Function() onTick;
  Timer? _timer;

  bool get isRunning => _timer?.isActive ?? false;

  void start() {
    if (isRunning) {
      return;
    }

    _timer = Timer.periodic(interval, (_) => onTick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void toggle() {
    if (isRunning) {
      stop();
      return;
    }

    start();
  }

  void dispose() {
    stop();
  }
}
