// ignore_for_file: dead_code

import 'package:utils/algorithms.dart' show floodFill;
import 'package:utils/data_structures.dart' show Grid;

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
  List<List<bool>> arrayGrid = List.generate(128, (i) => generateRow(input, i));
  var grid = Grid.fromArrays(arrayGrid);
  int regionCount = 0;
  for (int row = 0; row < 128; row++) {
    for (int col = 0; col < 128; col++) {
      if (grid.get(col, row)) {
        regionCount++;
        floodFill(grid, col, row, false, (val) => !val);
      }
    }
  }
  return regionCount.toString();
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
