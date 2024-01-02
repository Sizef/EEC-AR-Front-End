import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class ThreeDViewer extends StatelessWidget {
  final String modelPath;

  const ThreeDViewer({super.key, required this.modelPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Viewer'),
      ),
      body: Center(
        child: Cube(
          onSceneCreated: (Scene scene) {
            scene.world.add(Object(fileName: 'assets/$modelPath'));
          },
        ),
      ),
    );
  }
}
