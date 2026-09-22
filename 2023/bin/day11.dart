// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day11.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = (List<List<int>> map, List<Point> galaxies);

typedef Expansions = ({List<int> row, List<int> col});

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  var galaxies = <Point>{};
  var map = List.generate(
    lines.length,
    (row) => List.generate(lines[0].length, (col) {
      if (lines[row][col] == '#') {
        galaxies.add(Point(col, row));
        return 1;
      } else {
        return 0;
      }
    }),
  );
  return (map, galaxies.toList());
}

String solvePart1(InputType input) {
  var (map, galaxies) = input;
  var expansions = getExpansions(map);
  var totalDistance = 0;
  for (int i = 0; i < galaxies.length - 1; i++) {
    var a = galaxies[i];
    for (int j = i + 1; j < galaxies.length; j++) {
      var b = galaxies[j];
      totalDistance += getDistance(a, b, expansions, 1);
    }
  }
  return totalDistance.toString();
}

String solvePart2(InputType input) {
  var (map, galaxies) = input;
  var expansions = getExpansions(map);
  var totalDistance = 0;
  for (int i = 0; i < galaxies.length - 1; i++) {
    var a = galaxies[i];
    for (int j = i + 1; j < galaxies.length; j++) {
      var b = galaxies[j];
      totalDistance += getDistance(a, b, expansions, 999999);
    }
  }
  return totalDistance.toString();
}

Expansions getExpansions(List<List<int>> map) {
  var rowExpansion = List<int>.generate(
    map.length,
    (int index) => map[index].any((cell) => cell == 1) ? 0 : 1,
  );
  var colExpansion = List<int>.generate(
    map[0].length,
    (int index) => map.any((row) => row[index] == 1) ? 0 : 1,
  );
  return (row: rowExpansion, col: colExpansion);
}

int getDistance(Point a, Point b, Expansions expansions, int extraSteps) {
  var minX = a.x < b.x ? a.x : b.x;
  var minY = a.y < b.y ? a.y : b.y;
  var maxX = a.x > b.x ? a.x : b.x;
  var maxY = a.y > b.y ? a.y : b.y;

  var distance = 0;
  // Account for single step scenarios
  distance += (maxY - minY).abs();
  distance += (maxX - minX).abs();
  // Get steps between galaxies
  for (var y = minY; y < maxY; y++) {
    distance += (expansions.row[y] * extraSteps);
  }
  for (var x = minX; x < maxX; x++) {
    distance += (expansions.col[x] * extraSteps);
  }
  return distance;
}
