// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day01.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<int>;

InputType parseInput(String input) {
  return input.characters.map((char) => int.parse(char)).toList();
}

String solvePart1(InputType input) {
  int sum = 0;
  for (var i = 0; i < input.length; i++) {
    if (input[i] == input[(i + 1) % input.length]) {
      sum += input[i];
    }
  }
  return sum.toString();
}

String solvePart2(InputType input) {
  return "";
}
