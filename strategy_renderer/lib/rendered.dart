import 'package:flutter/material.dart';

abstract class Renderer {
  Widget render();
}

class ImageRendere extends Renderer {
  @override
  Widget render() {
    return Image.asset('assets/simple-image.jpg');
  }
}

class TextRenderer extends Renderer {
  @override
  Widget render() {
    return const Text('Hello World!');
  }
}

class RectangleRenderer extends Renderer {
  @override
  Widget render() {
    return Container(width: 100, height: 100, color: Colors.blue);
  }
}
