// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day05.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<int>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) => int.parse(line)).toList();
}

String solvePart1(InputType input) {
  var index = 0;
  var steps = 0;
  while (index >= 0 && index < input.length) {
    var jump = input[index];
    input[index]++;
    index += jump;
    steps++;
  }
  return steps.toString();
}

String solvePart2(InputType input) {
  return "";
}
