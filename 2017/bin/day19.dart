// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day19.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (List<String>, Point);

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  var startX = lines.first.indexOf('|');
  if (startX < 0) {
    throw Exception("No starting point found in the input.");
  }
  var start = Point(startX, 0);
  return (lines, start);
}

extension on List<String> {
  String get(Point p) {
    return this[p.y][p.x];
  }

  bool isValid(Point p) {
    return p.y >= 0 &&
        p.y < length &&
        p.x >= 0 &&
        p.x < this[p.y].length &&
        this[p.y][p.x] != ' ';
  }
}

String solvePart1(InputType input) {
  var (map, start) = input;
  Point? currentPos = start;
  var currentDirection = Point.down;
  var seenLetters = <String>[];
  while (currentPos != null) {
    var (nextPos, nextDirection, seenLetter) = step(
      currentPos,
      currentDirection,
      map,
    );
    if (seenLetter != null) {
      seenLetters.add(seenLetter);
    }
    currentPos = nextPos;
    currentDirection = nextDirection;
  }
  return seenLetters.join();
}

String solvePart2(InputType input) {
  var (map, start) = input;
  Point currentPos = start;
  var currentDirection = Point.down;
  var steps = 0; // Start at 0 to negate the last overstep
  while (true) {
    var (nextPos, nextDirection, seenLetter) = step(
      currentPos,
      currentDirection,
      map,
    );
    if (nextPos == null) break;
    steps++;
    currentPos = nextPos;
    currentDirection = nextDirection;
  }
  return steps.toString();
}

(Point?, Point, String?) step(
  Point currentPos,
  Point currentDirection,
  List<String> map,
) {
  if (!map.isValid(currentPos)) {
    return (null, currentPos, "");
  }
  String? seenLetter;
  if (map.get(currentPos) == '+') {
    var isVertical =
        currentDirection == Point.up || currentDirection == Point.down;
    var lookLeft = currentPos + currentDirection.rotateCounterClockwise();
    if (!map.isValid(lookLeft)) {
      // If left is invalid we must turn right
      currentDirection = currentDirection.rotateClockwise();
    } else {
      if (
      // If we are vertical and turn left, we can't be on a vertical pipe
      (isVertical && map.get(lookLeft) != '|') ||
          // If we are horizontal and turn left, we can't be on a horizontal pipe
          (!isVertical && map.get(lookLeft) != '-')) {
        currentDirection = currentDirection.rotateCounterClockwise();
      } else {
        currentDirection = currentDirection.rotateClockwise();
      }
    }
  } else if (map.get(currentPos) != '|' && map.get(currentPos) != '-') {
    seenLetter = map.get(currentPos);
  }
  currentPos += currentDirection;
  return (currentPos, currentDirection, seenLetter);
}
