// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day13.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<(int, int)>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.split(': ');
    return (int.parse(parts[0]), int.parse(parts[1]));
  }).toList();
}

String solvePart1(InputType input) {
  int totalSeverity = 0;
  for (var (depth, range) in input) {
    if (depth % (2 * (range - 1)) == 0) {
      totalSeverity += depth * range;
    }
  }
  return totalSeverity.toString();
}

String solvePart2(InputType input) {
  int delay = 0;
  while (true) {
    bool caught = false;
    for (var (depth, range) in input) {
      if ((depth + delay) % (2 * (range - 1)) == 0) {
        caught = true;
        break;
      }
    }
    if (!caught) return delay.toString();
    delay++;
  }
}
