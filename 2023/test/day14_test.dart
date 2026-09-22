import 'package:utils/data_structures/grid.dart' show Grid;

import '../bin/day14.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

enum Part { ONE, TWO }

const String DAY = '14';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (part, file, expected) in [
    (Part.ONE, 'A', "136"),
    (Part.TWO, 'A', "64"),
  ])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day$DAY-$file.txt'),
        );
      });
      test(part == Part.ONE ? "1" : "2", () {
        if (part == Part.ONE)
          expect(solvePart1(input), expected.toString());
        else
          expect(solvePart2(input), expected.toString());
      });
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day$DAY.txt'));
    });
    const part1Answer = "108826";
    const part2Answer = "99291";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });

  group("Test tilt going", () {
    for (var (direction, expectedEnd) in [
      (Point.up, Point(1, 0)),
      (Point.down, Point(1, 2)),
      (Point.left, Point(0, 1)),
      (Point.right, Point(2, 1)),
    ]) {
      test("Tilt $direction", () {
        var grid = Grid<int>((_, _) => 0, 3, 3);
        grid.set(1, 1, 1);
        tilt(grid, direction);
        // The rock should move to the edge in the given direction
        expect(grid.getPoint(expectedEnd), 1);
      });
    }
  });

  group("Test calculateLoadFromHash", () {
    for (var (hash, expectedLoad) in [
      ("R1E1R1", 2),
      ("E2R1", 1),
      ("R11E2R1", 12),
      ("E1R1E1|R1E2", 3),
    ]) {
      test("Hash $hash", () {
        expect(calculateLoadFromHash(hash), expectedLoad);
      });
    }
  });
}
