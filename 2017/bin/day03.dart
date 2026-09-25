// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/dart_utils.dart';

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
  return "";
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
