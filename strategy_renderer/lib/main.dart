import 'package:flutter/material.dart';
import 'package:strategy_renderer/rendered.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  final Renderer _imageRenderer = ImageRendere();
  final Renderer _textRenderer = TextRenderer();
  final Renderer _rectangleRenderer = RectangleRenderer();

  late Renderer renderer = _imageRenderer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Strategy Pattern Renderer')),
        body: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Choose a rendering strategy:'),
              ),
              RadioGroup(
                groupValue: renderer,
                onChanged: (selectedRenderer) => {
                  setState(() {
                    renderer = selectedRenderer!;
                  }),
                },
                child: Column(
                  children: [
                    RadioListTile<Renderer>(
                      title: Text("Image Renderer"),
                      value: _imageRenderer,
                    ),
                    RadioListTile<Renderer>(
                      title: Text("Text Renderer"),
                      value: _textRenderer,
                    ),
                    RadioListTile<Renderer>(
                      title: Text("Rectangle Rendere"),
                      value: _rectangleRenderer,
                    ),
                  ],
                ),
              ),

              const Divider(),
              Expanded(child: Center(child: renderer.render())),
            ],
          ),
        ),
      ),
    );
  }
}
