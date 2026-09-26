// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'knot_hash.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day10.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = String;

InputType parseInput(String input) {
  return input;
}

String solvePart1(InputType input, [int length = 256]) {
  var list = List<int>.generate(length, (i) => i);
  var lengths = input.split(',').map(int.parse).toList();
  runLengths(list, lengths);

  return (list[0] * list[1]).toString();
}

String solvePart2(InputType input) {
  return getKnotHash(input);
}
