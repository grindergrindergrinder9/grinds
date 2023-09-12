import 'package:flutter/material.dart' hide ExpansionTile;
import 'expansion_tile.dart';

void main() {
  runApp(const ExpansionTileGrindApp());
}

class ExpansionTileGrindApp extends StatelessWidget {
  const ExpansionTileGrindApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // body:const  _AlignmentExample()
        body: ExpansionTile(
          title: Text('ExpansionTile'),
        ),
      ),
    );
  }
}

class _AlignmentExample extends StatelessWidget {
  const _AlignmentExample();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        ColoredBox(
          color: Colors.red,
          child: SizedBox.expand(),
        ),
        ColoredBox(
          color: Colors.black12,
          child: FractionallySizedBox(
            heightFactor: 0.5,
            widthFactor: 0.5,
            child: Align(
              alignment: Alignment.topCenter,
              child: ColoredBox(
                color: Colors.blue,
                child: SizedBox.square(dimension: 25),
              ),
            ),
          ),
        )
      ],
    );
  }
}
