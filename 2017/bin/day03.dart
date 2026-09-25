// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures/growables.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day03.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = int;

InputType parseInput(String input) {
  return int.parse(input);
}

String solvePart1(InputType input) {
  var ring = getRingSideLengthForPosition(input);
  var offset = getOffsetFromMiddle(input, ring);
  return ((ring ~/ 2) + offset).toString();
}

String solvePart2(InputType input) {
  var grid = GrowableGrid((_, __) => 0, -5, 5, -5, 5);
  var position = Point(0, 0);
  var index = 1;
  var value = 1;
  grid.setPoint(position, value);
  var direction = Point.right;
  // Walk the circle and fill in values according to the spiral sum rule
  while (value <= input) {
    var ringSide = getRingSideLengthForPosition(index);
    var maxInRing = ringSide * ringSide;
    var minInRing = (ringSide - 2) * (ringSide - 2) + 1;
    // Last position in a ring is technically a corner, so we just move in the current direction instead
    if (index == maxInRing) {
      position += direction;
    }
    // The first step in a new ring we need to curl
    else if (index == minInRing) {
      direction = direction.rotateCounterClockwise();
      position += direction;
    }
    // Every (ringSide - 1) steps after the minimum in the ring, we rotate for the corner
    else if ((index - minInRing + 1) % (ringSide - 1) == 0) {
      direction = direction.rotateCounterClockwise();
      position += direction;
    } else {
      position += direction;
    }
    value = Point.directions
        .map((direction) => grid.getPoint(position + direction))
        .fold(0, (sum, val) => sum + val);
    grid.setPoint(position, value);
    index++;
  }
  return value.toString();
}

int getRingSideLengthForPosition(int position) {
  if (position == 1) return 1;
  int ring = 1;
  while (pow(ring, 2) < position) {
    ring += 2;
  }
  return ring;
}

// Assumes position is within the ring defined by ringSideLength
int getOffsetFromMiddle(int position, int ringSideLength) {
  if (position == 1) return 0;
  int stepInRing = position - pow(ringSideLength - 2, 2).toInt();
  int stepsSincePreceedingCorder = stepInRing % (ringSideLength - 1);

  return ((ringSideLength) ~/ 2 - stepsSincePreceedingCorder).abs();
}
