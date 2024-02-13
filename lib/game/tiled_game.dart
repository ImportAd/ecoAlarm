import 'package:ecoalarm/game/tile_info.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class TiledGame extends FlameGame with ScaleDetector, TapDetector {
  late TiledComponent mapComponent;

  static const double _minZoom = 0.1;
  static const double _maxZoom = 2.5;
  double _startZoom = _minZoom;

  @override
  Future<void> onLoad() async {
    camera.viewfinder
      ..zoom = _startZoom
      ..anchor = Anchor.topLeft;

    mapComponent = await TiledComponent.load(
      'testMap.tmx',
      Vector2(73, 55), //31, 27
    );
    world.add(mapComponent);
  }

  @override
  Color backgroundColor() {
    var bg = const Color.fromARGB(255, 11, 88, 158);
    return bg;
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    camera.viewfinder.anchor = Anchor.center;
    _startZoom = camera.viewfinder.zoom;
  }

  void _processDrag(ScaleUpdateInfo info) {
    final delta = info.delta.global;
    final zoomDragFactor = 1.0 / _startZoom;
    final currentPosition = camera.viewfinder.position;

    camera.viewfinder.position = currentPosition.translated(
      -delta.x * zoomDragFactor,
      -delta.y * zoomDragFactor,
    );
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;

    if (currentScale.isIdentity()) {
      _processDrag(info);
    } else {
      _processScale(info, currentScale);
    }
  }

  void _processScale(ScaleUpdateInfo info, Vector2 currentScale) {
    final newZoom = _startZoom * ((currentScale.y + currentScale.x) / 2.0);
    camera.viewfinder.zoom = newZoom.clamp(_minZoom, _maxZoom);
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    _checkScaleBorders();
    _checkDragBorders();
  }

  void _checkScaleBorders() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(_minZoom, _maxZoom);
  }

  void _checkDragBorders() {
    final worldRect = camera.visibleWorldRect;

    final currentPosition = camera.viewfinder.position;

    final mapSize = Offset(mapComponent.width, mapComponent.height);

    var xTranslate = 0.0;
    var yTranslate = 0.0;

    // var xTranslate = mapComponent.width / 2;
    // var yTranslate = mapComponent.height / 2;

    // исправить приближение
    if (worldRect.topLeft.dx < 0.0) {
      xTranslate = -worldRect.topLeft.dx;
    } else if (worldRect.bottomRight.dx > mapSize.dx) {
      xTranslate = mapSize.dx - worldRect.bottomRight.dx;
    }

    if (worldRect.topLeft.dy < 0.0) {
      yTranslate = -worldRect.topLeft.dy;
    } else if (worldRect.bottomRight.dy > mapSize.dy) {
      yTranslate = mapSize.dy - worldRect.bottomRight.dy;
    }

    camera.viewfinder.position =
        currentPosition.translated(xTranslate, yTranslate);
  }

  @override
  Future<void> onTapUp(TapUpInfo info) async {
    final tappedCel = _getTappedCell(info);

    final spriteComponent = SpriteComponent(
      size: Vector2.all(200.0),
      sprite: await Sprite.load('circle.png'),
    )
      ..anchor = Anchor.center
      ..position = Vector2(tappedCel.center.dx, tappedCel.center.dy)
      ..priority = 1;
    mapComponent.add(spriteComponent);

    // estimateCallTime<TileInfo>(
    //   () {
    //     return _getTappedCell(info);
    //   },
    // );
  }

  TileInfo _getTappedCell(TapUpInfo info) {
    final clickOnMapPoint = camera.globalToLocal(info.eventPosition.global);

    final rows = mapComponent.tileMap.map.width;
    final cols = mapComponent.tileMap.map.height;

    final tileSize = mapComponent.tileMap.destTileSize;

    var targetRow = 0;
    var targetCol = 0;
    var minDistance = double.maxFinite;
    var targetCenter = Offset.zero;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final xCenter = col * tileSize.x +
            tileSize.x / 2 +
            (row.isEven ? 0 : tileSize.x / 2);
        final yCenter =
            row * tileSize.y - (row * tileSize.y / 4) + tileSize.y / 2;

        final distance = math.sqrt(math.pow(xCenter - clickOnMapPoint.x, 2) +
            math.pow(yCenter - clickOnMapPoint.y, 2));

        if (distance < minDistance) {
          minDistance = distance;
          targetRow = row;
          targetCol = col;
          targetCenter = Offset(xCenter, yCenter);
        }
      }
    }

    return TileInfo(center: targetCenter, row: targetRow, col: targetCol);
  }
}
