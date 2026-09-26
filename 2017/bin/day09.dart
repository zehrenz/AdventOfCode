// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day09.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = String;

InputType parseInput(String input) {
  return input;
}

String solvePart1(InputType input) {
  int score = 0;
  int groupDepth = 0;
  bool inGarbage = false;
  for (int i = 0; i < input.length; i++) {
    var char = input[i];
    if (inGarbage) {
      if (char == "!") {
        i++; // Skip the next character
      } else if (char == ">") {
        inGarbage = false;
      }
    } else {
      if (char == "<") {
        inGarbage = true;
      } else if (char == "{") {
        groupDepth++;
      } else if (char == "}") {
        score += groupDepth;
        groupDepth--;
      }
    }
  }
  return score.toString();
}

String solvePart2(InputType input) {
  int garbageCount = 0;
  bool inGarbage = false;
  for (int i = 0; i < input.length; i++) {
    var char = input[i];
    if (inGarbage) {
      if (char == "!") {
        i++; // Skip the next character
      } else if (char == ">") {
        inGarbage = false;
      } else {
        garbageCount++;
      }
    } else {
      if (char == "<") {
        inGarbage = true;
      }
    }
  }
  return garbageCount.toString();
}
