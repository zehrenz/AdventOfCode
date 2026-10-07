// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day18.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Instruction>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.split(' ');
    var x = int.tryParse(parts[1]) ?? parts[1];
    var y = parts.length > 2 ? (int.tryParse(parts[2]) ?? parts[2]) : null;
    return (parts[0], x, y);
  }).toList();
}

String solvePart1(InputType input) {
  var engine = DuetEngine(input);
  var result = engine.run();
  return result?.toString() ?? "";
}

String solvePart2(InputType input) {
  return "";
}

typedef Instruction = (String, Object, dynamic);

class DuetEngine {
  int currentIndex = 0;
  List<Instruction> instructions;
  int? lastPlayedSound;
  Map<String, int> registers = <String, int>{};
  DuetEngine(this.instructions);

  int? run() {
    while (currentIndex >= 0 && currentIndex < instructions.length) {
      var currentInstruction = instructions[currentIndex];
      var xValue = currentInstruction.$2 is int
          ? currentInstruction.$2 as int
          : registers[currentInstruction.$2 as String] ?? 0;
      var yValue = currentInstruction.$3 is int
          ? currentInstruction.$3 as int
          : currentInstruction.$3 is String
          ? registers[currentInstruction.$3 as String] ?? 0
          : 0;
      switch (currentInstruction.$1) {
        case "snd":
          lastPlayedSound = xValue;
          break;
        case "set":
          registers[currentInstruction.$2 as String] = yValue;
          break;
        case "add":
          registers[currentInstruction.$2 as String] = xValue + yValue;
          break;
        case "mul":
          registers[currentInstruction.$2 as String] = xValue * yValue;
          break;
        case "mod":
          registers[currentInstruction.$2 as String] = xValue % yValue;
          break;
        case "jgz":
          if (xValue > 0) {
            currentIndex += yValue - 1;
          }
          break;
        case "rcv":
          if (xValue != 0) {
            return lastPlayedSound;
          }
          break;
      }
      currentIndex++;
    }
  }
}
