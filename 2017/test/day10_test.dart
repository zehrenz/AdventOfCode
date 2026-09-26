import '../bin/day10.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

enum Part { ONE, TWO }

const String DAY = '10';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (part, file, expected) in [(Part.ONE, 'A', "12")])
    group("Check sample input $file passes for part", () {
      late var input;
      setUp(() {
        input = parseInput(
          Utils.readToString('../test_inputs/day$DAY-$file.txt'),
        );
      });
      test(part == Part.ONE ? "1" : "2", () {
        if (part == Part.ONE)
          expect(solvePart1(input, 5), expected.toString());
        else
          expect(solvePart2(input), expected.toString());
      });
    });

  group("Check actual input passes for part", () {
    late var input;
    setUp(() {
      input = parseInput(Utils.readToString('../inputs/day$DAY.txt'));
    });
    const part1Answer = "46600";
    const part2Answer = "";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });

  group("Check reverse function", () {
    test("basic reverse", () {
      var list = [1, 2, 3, 4, 5];
      reverse(list, 1, 3);
      expect(list, [1, 4, 3, 2, 5]);
    });
    test("reverse with wrap-around", () {
      var list = [1, 2, 3, 4, 5];
      reverse(list, 4, 2);
      expect(list, [5, 2, 3, 4, 1]);
    });
  });
}
