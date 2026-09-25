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
  int sum = 0;
  for (var row in input) {
    sum += divisiblePairQuotient(row);
  }
  return sum.toString();
}

int maxMinDiff(List<int> row) {
  int min = row[0];
  int max = row[0];
  for (var num in row) {
    if (num < min) min = num;
    if (num > max) max = num;
  }
  return max - min;
}

int divisiblePairQuotient(List<int> row) {
  for (var i = 0; i < row.length - 1; i++) {
    for (var j = i + 1; j < row.length; j++) {
      if (i != j && row[i] % row[j] == 0) {
        return row[i] ~/ row[j];
      }
      if (i != j && row[j] % row[i] == 0) {
        return row[j] ~/ row[i];
      }
    }
  }
  throw Exception("No divisible pair found");
}
