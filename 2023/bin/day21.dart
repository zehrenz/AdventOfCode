// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day21.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = ({List<List<int>> grid, Point start});

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  Point? start;
  var grid = lines.indexed
      .map(
        (line) => line.$2.split('').indexed.map((char) {
          switch (char.$2) {
            case 'S':
              start = Point(char.$1, line.$1);
              return -1;
            case '#':
              return -2;
            default:
              return -1;
          }
        }).toList(),
      )
      .toList();
  if (start == null) throw ArgumentError('Start point not found in input.');
  return (grid: grid, start: start!);
}

String solvePart1(InputType input, [int steps = 64]) {
  floodFillSteps(input.grid, input.start);
  return countReachablePoints(input.grid, steps).toString();
}

String solvePart2(InputType input, [int steps = 26501365]) {
  return "";
}

int countReachablePoints(List<List<int>> input, int steps) {
  var count = 0;
  for (var row in input) {
    for (var cell in row) {
      if (cell != -2 && cell <= steps) {
        // If we can get there in X steps, we can get back there in 2Y steps where Y is any number
        if ((steps - cell) % 2 == 0) {
          count++;
        }
      }
    }
  }
  return count;
}

void floodFillSteps(List<List<int>> input, Point start) {
  var queue = <(Point, int)>[(start, 0)];
  input[start.y][start.x] = 0;
  while (queue.isNotEmpty) {
    var (current, steps) = queue.removeAt(0);
    for (var dir in Point.cardinals) {
      var newPoint = current + dir;
      if (newPoint.y >= 0 &&
          newPoint.y < input.length &&
          newPoint.x >= 0 &&
          newPoint.x < input[0].length &&
          input[newPoint.y][newPoint.x] == -1) {
        input[newPoint.y][newPoint.x] = steps + 1;
        queue.add((newPoint, steps + 1));
      }
    }
  }
}
