// ignore_for_file: dead_code

import 'knot_hash.dart';
import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day14.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = String;

InputType parseInput(String input) {
  return input;
}

String solvePart1(InputType input) {
  List<List<bool>> grid = List.generate(128, (i) => generateRow(input, i));
  int usedSquares = grid.fold(
    0,
    (sum, row) => sum + row.where((bit) => bit).length,
  );
  return usedSquares.toString();
}

String solvePart2(InputType input) {
  return "";
}

List<bool> generateRow(String input, int rowIndex) {
  var hash = getKnotHash("$input-$rowIndex");
  return hash.characters.expand((char) {
    var value = int.parse(char, radix: 16);
    return [
      (value & 8) != 0,
      (value & 4) != 0,
      (value & 2) != 0,
      (value & 1) != 0,
    ];
  }).toList();
}
