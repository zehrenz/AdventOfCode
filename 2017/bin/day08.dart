// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day08.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Instruction>;

InputType parseInput(String input) {
  return input
      .splitNewLine()
      .map((line) => Instruction.fromLine(line))
      .toList();
}

String solvePart1(InputType input) {
  Map<String, int> registers = {};
  for (var instruction in input) {
    instruction.runInstruction(registers);
  }
  return registers.values.max().toString();
}

String solvePart2(InputType input) {
  return "";
}

// Looks like : "b inc 5 if a >= 1"
final instructionRegex = RegExp(
  r"(\w+)\s+(\w+)\s+([+-]?\d+)\s+if\s+(\w+)\s+([><=!]+)\s+([+-]?\d+)",
);

class Instruction {
  late String affected;
  late int change;
  late Comparison comparison;
  late String comparisonRegister;
  late int comparisonValue;

  Instruction.fromLine(String line) {
    var match = instructionRegex.firstMatch(line);
    if (match == null) {
      throw Exception("Invalid instruction format: $line");
    }
    var affected = match.group(1)!;
    var operation = match.group(2)!;
    var change = int.parse(match.group(3)!);
    var comparisonRegister = match.group(4)!;
    var comparisonOperator = match.group(5)!;
    var comparisonValue = int.parse(match.group(6)!);

    Comparison comparison;
    switch (comparisonOperator) {
      case ">":
        comparison = GT();
        break;
      case "<":
        comparison = LT();
        break;
      case "==":
        comparison = EQ();
        break;
      case "!=":
        comparison = NE();
        break;
      case ">=":
        comparison = GE();
        break;
      case "<=":
        comparison = LE();
        break;
      default:
        throw Exception("Unknown comparison operator: $comparisonOperator");
    }

    if (operation == "dec") {
      change = -change;
    }

    this.affected = affected;
    this.change = change;
    this.comparison = comparison;
    this.comparisonRegister = comparisonRegister;
    this.comparisonValue = comparisonValue;
  }

  void runInstruction(Map<String, int> registers) {
    var comparisonRegisterValue = registers[comparisonRegister] ?? 0;
    if (comparison.compare(comparisonRegisterValue, comparisonValue)) {
      registers[affected] = (registers[affected] ?? 0) + change;
    }
  }
}

abstract class Comparison {
  bool compare(int a, int b);
}

class GT implements Comparison {
  @override
  bool compare(int a, int b) {
    return a > b;
  }
}

class LT implements Comparison {
  @override
  bool compare(int a, int b) {
    return a < b;
  }
}

class EQ implements Comparison {
  @override
  bool compare(int a, int b) {
    return a == b;
  }
}

class NE implements Comparison {
  @override
  bool compare(int a, int b) {
    return a != b;
  }
}

class GE implements Comparison {
  @override
  bool compare(int a, int b) {
    return a >= b;
  }
}

class LE implements Comparison {
  @override
  bool compare(int a, int b) {
    return a <= b;
  }
}
