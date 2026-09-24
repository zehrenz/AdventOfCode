import '../bin/day18.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

enum Part { ONE, TWO }

const String DAY = '18';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (part, file, expected) in [
    (Part.ONE, 'A', "62"),
    (Part.TWO, 'A', "952408144115"),
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
    const part1Answer = "44436";
    const part2Answer = "106941819907437";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });
}
