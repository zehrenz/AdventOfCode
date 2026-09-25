// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day06.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<int>;

InputType parseInput(String input) {
  return input.splitWhitespace().map((number) => int.parse(number)).toList();
}

String solvePart1(InputType input) {
  var seen = <int>{};
  var highest = input.indexed.reduce((a, b) => a.$2 > b.$2 ? a : b).$1;
  var reallocations = 0;
  while (!seen.contains(getListHash(input))) {
    seen.add(getListHash(input));
    highest = reallocate(input, highest);
    reallocations++;
  }
  return reallocations.toString();
}

String solvePart2(InputType input) {
  var seen = <int>[];
  var highest = input.indexed.reduce((a, b) => a.$2 > b.$2 ? a : b).$1;
  var reallocations = 0;
  while (true) {
    var index = seen.indexOf(getListHash(input));
    if (index != -1) {
      return (reallocations - index).toString();
    }
    seen.add(getListHash(input));
    highest = reallocate(input, highest);
    reallocations++;
  }
  throw Exception("No loop found");
}

int reallocate(List<int> banks, highest) {
  var newHighest = 0;
  var blocks = banks[highest];
  banks[highest] = 0;
  for (int i = 0; i < banks.length; i++) {
    // Get the index relative to the former highest bank
    var indexAfterHighest = (i - highest + banks.length) % banks.length;
    banks[i] +=
        // distribute the evenly divisible blocks
        (blocks ~/ banks.length) +
        // distribute the remainder
        (indexAfterHighest > 0 && indexAfterHighest <= blocks % banks.length
            ? 1
            : 0);
    if (banks[i] > banks[newHighest]) newHighest = i;
  }
  ;
  return newHighest;
}

int getListHash(List<int> list) {
  var hash = 0;
  for (var i = 0; i < list.length; i++) {
    hash += list[i] * pow(100, i).toInt();
  }
  return hash;
}
