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
    const part2Answer = "23234babdc6afa036749cfa9b597de1b";
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

  group("Check getExtendedLengths function", () {
    test("basic extension", () {
      var input = "1,2,3";
      var extended = getExtendedLengths(input);
      expect(extended, [49, 44, 50, 44, 51, 17, 31, 73, 47, 23]);
    });
  });

  group("Check getDenseHash function", () {
    test("basic dense hash", () {
      var sparseHash = [65, 27, 9, 1, 4, 3, 40, 50, 91, 7, 6, 0, 2, 5, 68, 22];
      var dense = getDenseHash(sparseHash);
      expect(dense, [64]);
    });
  });

  group("Check toHexString function", () {
    test("basic hex conversion", () {
      var denseHash = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
      var hex = toHexString(denseHash);
      expect(hex, "000102030405060708090a0b0c0d0e0f");
    });
  });

  group("Check getFullHash function", () {
    for (var (given, expected) in [
      ("", "a2582a3a0e66e6e86e3812dcb672a272"),
      ("AoC 2017", "33efeb34ea91902bb2f59c9920caa6cd"),
      ("1,2,3", "3efbe78a8d82f29979031a4aa0b16a9d"),
      ("1,2,4", "63960835bcdc130f0b66d7ff4f6a5a8e"),
    ]) {
      test("full hash for $given", () {
        expect(getFullHash(given), expected);
      });
    }
  });
}
