// ignore_for_file: dead_code

import 'dart:math' show max;

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day11.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

class HEX {
  static final North = Point(0, 1);
  static final South = Point(0, -1);
  static final NorthEast = Point(1, 0);
  static final NorthWest = Point(-1, 1);
  static final SouthEast = Point(1, -1);
  static final SouthWest = Point(-1, 0);
}

typedef InputType = List<Point>;

InputType parseInput(String input) {
  return input.split(',').map((direction) {
    switch (direction) {
      case 'n':
        return HEX.North;
      case 's':
        return HEX.South;
      case 'ne':
        return HEX.NorthEast;
      case 'nw':
        return HEX.NorthWest;
      case 'se':
        return HEX.SouthEast;
      case 'sw':
        return HEX.SouthWest;
      default:
        throw Exception("Invalid direction: $direction");
    }
  }).toList();
}

String solvePart1(InputType input) {
  var position = Point(0, 0);
  for (var step in input) {
    position += step;
  }
  return hexDistance(Point(0, 0), position).toString();
}

String solvePart2(InputType input) {
  var start = Point(0, 0);
  var position = start;
  var maxDistance = 0;
  for (var step in input) {
    position += step;
    maxDistance = max(maxDistance, hexDistance(start, position));
  }
  return maxDistance.toString();
}

int hexDistance(Point a, Point b) {
  var dq = (b.x - a.x).abs();
  var dr = (b.y - a.y).abs();
  var ds = (-(b.x + b.y) + (a.x + a.y)).abs();
  return (dq + dr + ds) ~/ 2;
}
