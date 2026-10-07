// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day17.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = int;

InputType parseInput(String input) {
  return int.parse(input.splitNewLine().first);
}

String solvePart1(InputType input) {
  var arr = [0];
  var currentPosition = 0;
  while (arr.length <= 2017) {
    currentPosition = (currentPosition + input) % arr.length + 1;
    arr.insert(currentPosition, arr.length);
  }
  return arr[(currentPosition + 1) % arr.length].toString();
}

String solvePart2(InputType input) {
  var len = 1;
  var currentPosition = 0;
  var valueAfterZero = 0;
  for (var i = 1; i <= 50000000; i++) {
    currentPosition = (currentPosition + input) % len + 1;
    if (currentPosition == 1) {
      valueAfterZero = i;
    }
    len++;
  }
  return valueAfterZero.toString();
}
