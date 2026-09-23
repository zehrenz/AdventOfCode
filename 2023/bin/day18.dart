// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/algorithms.dart' show floodFill;
import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures/growables.dart' show GrowableGrid;
import 'package:utils/data_structures/right_polygon.dart' show RightPolygon;

void main() {
  var rawInput = Utils.readToString("../inputs/day18.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Instruction>;
typedef Instruction = ({Point direction, int length, List<int> rgb});
final instRegex = RegExp(r'^([LRUD]) (\d+) \(#(..)(..)(..)\)$');

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var match = instRegex.firstMatch(line);
    if (match == null) throw Exception("Invalid instruction format");
    var parts = match.groups([1, 2, 3, 4, 5]);
    return (
      direction: switch (parts[0]) {
        'L' => Point.left,
        'R' => Point.right,
        'U' => Point.up,
        'D' => Point.down,
        _ => throw Exception("Invalid direction"),
      },
      length: int.parse(parts[1]!),
      rgb: parts.sublist(2).map((s) => int.parse(s!, radix: 16)).toList(),
    );
  }).toList();
}

String solvePart1(InputType input) {
  var volume = 0;
  var grid = GrowableGrid<bool>(((_, _) => false));
  var points = <Point>[];
  // Mark starting hole
  var current = Point(0, 0);
  grid.setPoint(current, true);
  points.add(current);
  // Dig the trench
  for (var instruction in input) {
    for (var i = 0; i < instruction.length; i++) {
      current += instruction.direction;
      grid.setPoint(current, true);
      volume++;
    }
    points.add(current);
  }
  if (points[0] != points.last)
    throw Exception("Path does not return to starting point");
  points.removeLast();
  // Make a shape from the trench
  var shape = RightPolygon(points);
  // Find a point inside the shape
  Point? inside;
  var width = shape.maxX - shape.minX + 1;
  var height = shape.maxY - shape.minY + 1;
  var farthest = min(width, height) - 1;
  for (var index = 0; index < farthest; index++) {
    var p = Point(shape.minX + index, shape.minY + index);
    if (!grid.getPoint(p) && shape.containsPoint(p)) {
      inside = p;
      break;
    }
  }
  if (inside == null) throw Exception("No inside point found");
  // Flood fill the grid
  var flooded = floodFill(grid, inside.x, inside.y, true, (value) => value);
  return (volume + flooded).toString();
}

String solvePart2(InputType input) {
  return "";
}
