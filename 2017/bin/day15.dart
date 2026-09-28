// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day15.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (int, int);
final intMatch = RegExp(r'\d+');
const factorA = 16807;
const factorB = 48271;
const divisor = 2147483647;
const mask16 = 0xFFFF;

InputType parseInput(String input) {
  var numbers = intMatch
      .allMatches(input)
      .map((m) => int.parse(m[0]!))
      .toList();
  if (numbers.length != 2)
    throw Exception("Expected exactly 2 numbers in input");
  return (numbers[0], numbers[1]);
}

String solvePart1(InputType input) {
  var (a, b) = input;
  var count = 0;
  for (var i = 0; i < 40000000; i++) {
    (a, b) = nextPair(a, b);
    if (checkLow16(a, b)) count++;
  }
  return count.toString();
}

String solvePart2(InputType input) {
  return "";
}

(int, int) nextPair(int a, int b) {
  a = (a * factorA) % divisor;
  b = (b * factorB) % divisor;
  return (a, b);
}

bool checkLow16(int a, int b) {
  return (a & mask16) == (b & mask16);
}
