import 'package:utils/data_structures/linear_collections.dart' show Queue;

import '../bin/day15.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

enum Part { ONE, TWO }

const String DAY = '15';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (part, file, expected) in [
    (Part.ONE, 'A', "1320"),
    (Part.TWO, 'A', "145"),
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
    const part1Answer = "502139";
    const part2Answer = "284132";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });

  group("Check generateHash function", () {
    for (var (input, expected) in [("rn=1", 30), ("cm-", 253), ("qp=3", 97)]) {
      test("Hash of '$input' is $expected", () {
        expect(generateHash(input), expected);
      });
    }
  });

  test('getFocusingPowerForBox calculates correct focusing power', () {
    final queue = Queue<Lens>();
    queue.push(Lens('a', 2));
    queue.push(Lens('b', 3));
    queue.push(Lens('c', 4));

    final boxNumber = 1;
    final expectedFocusingPower =
        (boxNumber + 1) * 1 * 2 +
        (boxNumber + 1) * 2 * 3 +
        (boxNumber + 1) * 3 * 4;
    expect(getFocusingPowerForBox(queue, boxNumber), expectedFocusingPower);
  });
}
