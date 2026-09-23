// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day15.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

InputType parseInput(String input) {
  return input.split(',');
}

String solvePart1(InputType input) {
  return input
      .map((item) => generateHash(item))
      .fold(0, (a, b) => a + b)
      .toString();
}

String solvePart2(InputType input) {
  return "";
}

int generateHash(String input) {
  var current = 0;
  for (var i = 0; i < input.length; i++) {
    current = ((current + input.codeUnitAt(i)) * 17) % 256;
  }
  return current;
}
