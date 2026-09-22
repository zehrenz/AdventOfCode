// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures/linear_collections.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day10.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = ({Point start, List<String> map});

InputType parseInput(String input) {
  var lines = input.splitNewLine();
  for (int i = 0; i < lines.length; i++) {
    var index = lines[i].indexOf("S");
    if (index != -1) {
      var start = Point(index, i);
      var startPipe = getStartActual(start, lines);
      lines[i] = lines[i].replaceFirst("S", startPipe);
      return (start: start, map: lines);
    }
  }
  throw Exception("Start point 'S' not found in input.");
}

String solvePart1(InputType input) {
  Point start = input.start;
  List<String> map = input.map;
  var startPipe = map[start.y][start.x];
  Point currentDirection = getStartDirection(startPipe);
  int pipeLen = 1;
  Point currentPoint = start;

  while (true) {
    currentPoint = currentPoint + currentDirection;
    if (currentPoint == start) break;
    pipeLen++;
    currentDirection = getNextDirection(
      currentDirection,
      map[currentPoint.y][currentPoint.x],
    );
  }

  return (pipeLen ~/ 2).toString();
}

String solvePart2(InputType input) {
  Point start = input.start;
  List<String> map = input.map;
  var startPipe = map[start.y][start.x];
  Point currentDirection = getStartDirection(startPipe);
  int pipeLen = 0;
  Point currentPoint = start;
  List<List<int>> typeMap = List.generate(
    map.length,
    ((index) => List.filled(map[0].length, 0)),
  );

  do {
    currentPoint = currentPoint + currentDirection;
    currentDirection = getNextDirection(
      currentDirection,
      map[currentPoint.y][currentPoint.x],
    );
    typeMap[currentPoint.y][currentPoint.x] = 2;
    pipeLen++;
  } while (currentPoint != start);

  var totalFill = 0;
  // *all mentions of normal refer to one turn clockwise
  do {
    var normal = currentDirection.rotateClockwise();
    var normalPoint = currentPoint + normal; // Get point in that direction
    if (typeMap[normalPoint.y][normalPoint.x] == 0)
      totalFill += fillSpace(
        typeMap,
        normalPoint,
      ); // If it isn't pipe, fill that space with 1s
    currentPoint =
        currentPoint + currentDirection; // Get the next point on the pipe
    var newPipe = map[currentPoint.y][currentPoint.x];
    if (!(newPipe == "|" || newPipe == "-")) {
      // If it's an angle, we need to check the normal before and after changing direction
      normal = currentDirection.rotateClockwise(); // Get normal direciton
      normalPoint = currentPoint + normal; // Get point in that direction
      if (typeMap[normalPoint.y][normalPoint.x] == 0)
        totalFill += fillSpace(
          typeMap,
          normalPoint,
        ); // If it isn't pipe, fill that space with 1s
    }
    currentDirection = getNextDirection(
      currentDirection,
      map[currentPoint.y][currentPoint.x],
    ); // Get the next direciton
  } while (currentPoint != start);

  var printMap = false;
  if (printMap) {
    for (int i = 0; i < map.length; i++) {
      StringBuffer s = StringBuffer();
      for (int j = 0; j < map[0].length; j++) {
        s.write(typeMap[i][j] == 2 ? letterToAngle(map[i][j]) : typeMap[i][j]);
      }
      print(s.toString());
    }
  }

  // If the first line has a 0 then 1s are inside and we reutrn the amount we filled
  // otherwise we return the total area minus the pipe and the amound we filled
  return (typeMap[0].contains(1)
          ? (typeMap.length * typeMap[0].length) - pipeLen - totalFill
          : totalFill)
      .toString();
}

int fillSpace(List<List<int>> map, Point point) {
  Queue<Point> toSee = Queue()..push(point);
  map[point.y][point.x] = 1;
  int filled = 1;
  while (!toSee.isEmpty) {
    var current = toSee.pop();
    List<Point> toCheck = [];
    if (current.y > 0) toCheck.add(Point(current.x, current.y - 1)); // Up
    if (current.y < map.length - 1)
      toCheck.add(Point(current.x, current.y + 1)); // Down
    if (current.x > 0) toCheck.add(Point(current.x - 1, current.y)); // Left
    if (current.x < map[0].length - 1)
      toCheck.add(Point(current.x + 1, current.y)); // Right
    for (var check in toCheck) {
      if (map[check.y][check.x] == 0) {
        map[check.y][check.x] = 1;
        toSee.push(check);
        filled++;
      }
    }
  }
  return filled;
}

Point getNextDirection(Point current, String pipe) {
  switch (pipe) {
    case "F":
      return current == Point.up ? Point.right : Point.down;
    case "7":
      return current == Point.up ? Point.left : Point.down;
    case "L":
      return current == Point.down ? Point.right : Point.up;
    case "J":
      return current == Point.down ? Point.left : Point.up;
    default:
      return current;
  }
}

Point getStartDirection(String startPipe) {
  return startPipe == "F" || startPipe == "7" ? Point.down : Point.up;
}

String getStartActual(Point start, List<String> map) {
  var up = map[start.y == 0 ? 0 : start.y - 1][start.x];
  var down = map[start.y == map.length ? map.length : start.y + 1][start.x];
  var left = map[start.y][start.x == 0 ? 0 : start.x - 1];
  var checkUp = "|F7".contains(up);
  var checkDown = "|JL".contains(down);
  var checkLeft = "-FL".contains(left);
  if (checkUp) {
    return checkDown
        ? "|"
        : checkLeft
        ? "J"
        : "L";
  } else {
    return checkDown
        ? checkLeft
              ? "7"
              : "F"
        : "-";
  }
}

String letterToAngle(String letter) {
  switch (letter) {
    case "F":
      return "┌";
    case "7":
      return "┐";
    case "J":
      return "┘";
    case "L":
      return "└";
    default:
      return letter;
  }
}
