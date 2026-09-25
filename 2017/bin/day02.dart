// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day02.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<List<int>>;

InputType parseInput(String input) {
  return input
      .splitNewLine()
      .map((line) => line.splitWhitespace().map(int.parse).toList())
      .toList();
}

String solvePart1(InputType input) {
  int sum = 0;
  for (var row in input) {
    sum += maxMinDiff(row);
  }
  return sum.toString();
}

String solvePart2(InputType input) {
  return "";
}

int maxMinDiff(List<int> row) {
  return row.reduce((a, b) => a > b ? a : b) -
      row.reduce((a, b) => a < b ? a : b);
}
