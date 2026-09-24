// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures/right_polygon.dart' show RightPolygon;

void main() {
  var rawInput = Utils.readToString("../inputs/day18.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Instruction>;
typedef Instruction = ({Point direction, int length, String rgb});
final instRegex = RegExp(r'^([LRUD]) (\d+) \(#(.+)\)$');

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var match = instRegex.firstMatch(line);
    if (match == null) throw Exception("Invalid instruction format");
    var parts = match.groups([1, 2, 3]);
    return (
      direction: switch (parts[0]) {
        'L' => Point.left,
        'R' => Point.right,
        'U' => Point.up,
        'D' => Point.down,
        _ => throw Exception("Invalid direction"),
      },
      length: int.parse(parts[1]!),
      rgb: parts[2]!,
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
  var points = <Point>[];
  var current = Point(0, 0);
  points.add(current);
  // Dig the trench
  for (var instruction in input) {
    var (direction, length) = decodeInstruction(instruction.rgb);
    current += direction * length;
    points.add(current);
  }
  if (points[0] != points.last)
    throw Exception("Path does not return to starting point");
  points.removeLast();
  // Make a shape from the trench
  var shape = RightPolygon(points);
  return shape.latticeArea.toString();
}

(Point, int) decodeInstruction(String rgb) {
  var length = int.parse(rgb.substring(0, rgb.length - 1), radix: 16);
  var direction = switch (rgb[5]) {
    '0' => Point.right,
    '1' => Point.down,
    '2' => Point.left,
    '3' => Point.up,
    _ => throw Exception("Invalid direction"),
  };
  return (direction, length);
}
