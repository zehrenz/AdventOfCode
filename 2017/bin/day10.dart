// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day10.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

InputType parseInput(String input) {
  return input.splitNewLine();
}

String solvePart1(InputType input, [int length = 256]) {
  var list = List<int>.generate(length, (i) => i);
  var lengths = input.first.split(',').map(int.parse).toList();
  runLengths(list, lengths);

  return (list[0] * list[1]).toString();
}

String solvePart2(InputType input) {
  return "";
}

void reverse(List<int> list, int start, int length) {
  int left = start;
  int right = (start + length - 1) % list.length;
  for (int i = 0; i < length ~/ 2; i++) {
    int temp = list[left];
    list[left] = list[right];
    list[right] = temp;
    left = (left + 1) % list.length;
    right = (right - 1 + list.length) % list.length;
  }
}

void runLengths(List<int> list, List<int> lengths) {
  int currentPosition = 0;
  int skipSize = 0;
  for (var length in lengths) {
    reverse(list, currentPosition, length);
    currentPosition = (currentPosition + length + skipSize) % list.length;
    skipSize++;
  }
}
