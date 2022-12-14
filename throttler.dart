import 'dart:async';

class Throttler {
  final int seconds;

  late int reducingSeconds;

  Timer? timer;

  int count = 1;

  Stream<Duration>? stream;

  Throttler({required this.seconds}) {
    reducingSeconds = seconds;
    timer = Timer(Duration(seconds: seconds), () {});
    stream = Stream.periodic(const Duration(seconds: 1), (time) {
      if (reducingSeconds > 0) {
        reducingSeconds -= 1;
      }
      return Duration(seconds: reducingSeconds);
    });
  }

  void run(void Function() action) {
    if (timer?.isActive ?? false) {
      return;
    }
    timer?.cancel();

    action();
    count += 1;
    reducingSeconds = seconds * count;
    stream = Stream.periodic(const Duration(seconds: 1), (time) {
      if (reducingSeconds > 0) {
        reducingSeconds -= 1;
      }
      return Duration(seconds: reducingSeconds);
    });

    timer = Timer(Duration(seconds: seconds * count), () {});
  }

  void dispose() {
    timer?.cancel();
  }
}
