// ignore_for_file: dead_code

import 'dart:math';

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart' show Grid;

void main() {
  var rawInput = Utils.readToString("../inputs/day13.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Grid<bool>>;

InputType parseInput(String input) {
  return input.splitDoubleNewLine().map((single) {
    var lines = single.splitNewLine();
    var grid = Grid<bool>(
      (col, row) {
        return lines[row][col] == '#';
      },
      lines[0].length,
      lines.length,
    );
    return grid;
  }).toList();
}

String solvePart1(InputType input) {
  var score = 0;
  for (var grid in input) {
    score += scoreGrid(grid);
  }

  return score.toString();
}

String solvePart2(InputType input) {
  var score = 0;
  for (var grid in input) {
    score += scoreGrid(grid, 1);
  }

  return score.toString();
}

int scoreGrid(Grid<bool> grid, [int smudges = 0]) {
  for (var col = 1; col < grid.width; col++) {
    if (hasHorizontalReflectionAt(grid, col, smudges)) {
      return col;
    }
  }
  for (var row = 1; row < grid.height; row++) {
    if (hasVerticalReflectionAt(grid, row, smudges)) {
      return row * 100;
    }
  }
  throw Exception("No reflection found for the grid");
}

bool hasHorizontalReflectionAt(
  Grid<bool> grid,
  int reflectionCol, [
  int smudges = 0,
]) {
  var smudgeCount = 0;
  var startCol = max(0, reflectionCol - (grid.width - reflectionCol));
  for (var col = startCol; col < reflectionCol; col++) {
    for (var row = 0; row < grid.height; row++) {
      // Move one left because reflectionCol is between the grid columns
      var reflectedCol = 2 * reflectionCol - col - 1;
      var reflection = grid.get(reflectedCol, row);
      if (grid.get(col, row) != reflection) {
        smudgeCount++;
        if (smudgeCount > smudges) {
          return false;
        }
      }
    }
  }
  return smudgeCount == smudges;
}

bool hasVerticalReflectionAt(
  Grid<bool> grid,
  int reflectionRow, [
  int smudges = 0,
]) {
  var smudgeCount = 0;
  var startRow = max(0, reflectionRow - (grid.height - reflectionRow));
  for (var row = startRow; row < reflectionRow; row++) {
    for (var col = 0; col < grid.width; col++) {
      // Move one up because reflectionRow is between the grid rows
      var reflectedRow = 2 * reflectionRow - row - 1;
      var reflection = grid.get(col, reflectedRow);
      if (grid.get(col, row) != reflection) {
        smudgeCount++;
        if (smudgeCount > smudges) {
          return false;
        }
      }
    }
  }
  return smudgeCount == smudges;
}
