// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day09.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<List<int>>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) => Utils.ParseIntList(line)).toList();
}

String solvePart1(InputType input) {
  var total = 0;
  for (var layer in input) {
    total += calculateNext(layer);
  }
  return total.toString();
}

int calculateNext(List<int> layer) {
  if (layer.every((val) => val == 0)) {
    return 0;
  }
  var diffs = <int>[];
  for (var i = 1; i < layer.length; i++) {
    diffs.add(layer[i] - layer[i - 1]);
  }
  return layer.last + calculateNext(diffs);
}

String solvePart2(InputType input) {
  var total = 0;
  for (var layer in input) {
    total += calculatePrev(layer);
  }
  return total.toString();
}

int calculatePrev(List<int> layer) {
  if (layer.every((val) => val == 0)) {
    return 0;
  }
  var diffs = <int>[];
  for (var i = 1; i < layer.length; i++) {
    diffs.add(layer[i] - layer[i - 1]);
  }
  return layer.first - calculatePrev(diffs);
}
