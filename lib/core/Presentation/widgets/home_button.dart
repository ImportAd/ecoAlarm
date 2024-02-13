import 'package:ecoalarm/game/tiled_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String text;
  const HomeButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => TextButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameWidget(game: TiledGame()),
          ),
        ),
        child: Container(
          height: 200,
          width: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: Color.fromARGB(255, 64, 163, 244),
          ),
          child: Center(
              child: Text(
            text,
            style: const TextStyle(fontSize: 32, color: Colors.white),
          )),
        ),
      ),
    );
  }
}
