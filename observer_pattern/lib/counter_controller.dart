import 'dart:async';

enum EventType { increment, decrement }

class CounterController {
  int count = 0;

  final StreamController<EventType> _eventController =
      StreamController<EventType>();
  StreamSink<EventType> get eventSink => _eventController.sink;
  Stream<EventType> get eventStream =>
      _eventController.stream.asBroadcastStream();

  final StreamController<int> _counterController = StreamController<int>();
  StreamSink<int> get counterSink => _counterController.sink;
  Stream<int> get counterStream =>
      _counterController.stream.asBroadcastStream();

  StreamSubscription<EventType>? _listenerSubscription;

  CounterController() {
    _listenerSubscription = eventStream.listen((EventType event) {
      switch (event) {
        case EventType.increment:
          count += 1;
        case EventType.decrement:
          count -= 1;
      }

      counterSink.add(count);
    });
  }

  void dispose() {
    _listenerSubscription?.cancel();
    _eventController.close();
    _counterController.close();
  }
}
