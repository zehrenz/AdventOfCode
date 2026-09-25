// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day04.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<List<String>>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) => line.splitWhitespace()).toList();
}

String solvePart1(InputType input) {
  return input.where((line) => !hasDuplicateWords(line)).length.toString();
}

String solvePart2(InputType input) {
  return input.where((line) => !hasAnagram(line)).length.toString();
}

bool hasAnagram(List<String> phrases) {
  var seen = <String>{};
  for (var phrase in phrases) {
    var sorted = (phrase.split('')..sort()).join();
    if (!seen.add(sorted)) return true;
  }
  return false;
}

bool hasDuplicateWords(List<String> phrases) {
  var seen = <String>{};
  for (var phrase in phrases) {
    if (!seen.add(phrase)) return true;
  }
  return false;
}
