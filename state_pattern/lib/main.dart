import 'package:flutter/material.dart';

abstract interface class LightState {
  LightState switchLight();
  Color getColor();
}

class GreenLightState implements LightState {
  GreenLightState._();
  static final GreenLightState instance = GreenLightState._();

  @override
  Color getColor() {
    return Colors.green;
  }

  @override
  LightState switchLight() {
    return OrangeLightState.instance;
  }
}

class OrangeLightState implements LightState {
  OrangeLightState._();
  static final OrangeLightState instance = OrangeLightState._();

  @override
  Color getColor() {
    return Colors.orange;
  }

  @override
  LightState switchLight() {
    return RedLightState.instance;
  }
}

class RedLightState implements LightState {
  RedLightState._();
  static final RedLightState instance = RedLightState._();

  @override
  Color getColor() {
    return Colors.red;
  }

  @override
  LightState switchLight() {
    return GreenLightState.instance;
  }
}

class LightController {
  LightController._();
  static final LightController instance = LightController._();

  LightState _lightState = GreenLightState.instance;

  LightState get state => _lightState;

  void switchLight() {
    _lightState = _lightState.switchLight();
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final LightController controller = LightController.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: .min,
            children: [
              Container(
                width: 100,
                height: 100,
                color: controller.state.getColor(),
              ),
              SizedBox(height: 24),
              MaterialButton(
                onPressed: () {
                  controller.switchLight();
                  setState(() {});
                },
                child: Text("Switch Light "),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
