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
  var points = <Point>[];
  var current = Point(0, 0);
  points.add(current);
  // Dig the trench
  for (var instruction in input) {
    current += instruction.direction * instruction.length;
    points.add(current);
  }
  if (points[0] != points.last)
    throw Exception("Path does not return to starting point");
  points.removeLast();
  // Make a shape from the trench
  var shape = RightPolygon(points);
  return shape.latticeArea.toString();
}

String solvePart2(InputType input) {
  return "";
}
