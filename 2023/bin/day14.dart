// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day14.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = Grid<int>;

InputType parseInput(String input) {
  return Grid.fromStringGrid(
    input,
    (line) => line.characters,
    (char) => switch (char) {
      'O' => 1,
      '#' => -1,
      _ => 0,
    },
  );
}

String solvePart1(InputType input) {
  tilt(input, Point.up);
  return calulateLoad(input).toString();
}

String solvePart2(InputType input) {
  return "";
}

void tilt(Grid<int> grid, Point direction) {
  // If a direction axis is 0 it means we are tilting purely along the other axis, so we start from the beginning of that axis.
  var startRow = direction.y == 0
      ? 0
      : direction.y > 0
      ? grid.height - 1
      : 0;
  var endRow = direction.y == 0
      ? grid.height
      : direction.y > 0
      ? -1
      : grid.height;
  var startCol = direction.x == 0
      ? 0
      : direction.x > 0
      ? grid.width - 1
      : 0;
  var endCol = direction.x == 0
      ? grid.width
      : direction.x > 0
      ? -1
      : grid.width;
  // Walk away from the starting point in the direction opposite to the tilt
  var rowStep = direction.y == 0 ? 1 : direction.y * -1;
  var colStep = direction.x == 0 ? 1 : direction.x * -1;
  for (int row = startRow; row != endRow; row += rowStep) {
    for (int col = startCol; col != endCol; col += colStep) {
      if (grid.get(col, row) != 1) continue;
      var currentPoint = Point(col, row);
      // Walk until we find a non-empty spot that is in bounds
      while (grid.isPointInBounds(currentPoint + direction) &&
          grid.getPoint(currentPoint + direction) == 0) {
        currentPoint += direction;
      }
      // Place the rock in the new space and clear the old space
      grid.set(col, row, 0);
      grid.setPoint(currentPoint, 1);
    }
  }
}

int calulateLoad(Grid<int> grid) {
  int load = 0;
  for (int row = 0; row < grid.height; row++) {
    for (int col = 0; col < grid.width; col++) {
      if (grid.get(col, row) == 1) load += grid.height - row;
    }
  }
  return load;
}
