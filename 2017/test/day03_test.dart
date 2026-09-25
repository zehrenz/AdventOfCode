import '../bin/day03.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

enum Part { ONE, TWO }

const String DAY = '03';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (part, file, expected) in [
    (Part.ONE, 'A', "31"),
    (Part.TWO, 'A', "1968"),
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
    const part1Answer = "438";
    const part2Answer = "266330";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });

  group("Check getRingSideLengthForPosition function", () {
    for (var (position, expected) in [(1, 1), (2, 3), (9, 3), (10, 5)]) {
      test("Position $position returns $expected", () {
        expect(getRingSideLengthForPosition(position), expected);
      });
    }
  });

  group("Check getOffsetFromMiddle function", () {
    for (var (position, ringSideLength, expected) in [
      (1, 1, 0),
      (2, 3, 0),
      (3, 3, 1),
      (4, 3, 0),
      (9, 3, 1),
      (10, 5, 1),
      (11, 5, 0),
      (13, 5, 2),
      (25, 5, 2),
    ]) {
      test(
        "Position $position with ring side length $ringSideLength returns $expected",
        () {
          expect(getOffsetFromMiddle(position, ringSideLength), expected);
        },
      );
    }
  });
}
