import '../bin/day20.dart' hide main;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'package:utils/dart_utils.dart';

enum Part { ONE, TWO }

const String DAY = '20';
void main() {
  if (DAY.isEmpty) {
    throw Exception("Please set the DAY constant to the day being tested.");
  }
  for (var (part, file, expected) in [
    (Part.ONE, 'A', "0"),
    (Part.TWO, 'B', "1"),
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
    const part1Answer = "125";
    const part2Answer = "461";
    test("1", () {
      expect(solvePart1(input), part1Answer);
    }, skip: part1Answer.isEmpty);
    test("2", () {
      expect(solvePart2(input), part2Answer);
    }, skip: part2Answer.isEmpty);
  });

  group("findCollision", () {
    test("Collision when a, b, c are all zero", () {
      expect(findCollision(0, 0, 0, 0, 0, 0), 0);
    });
    test("No collision when a and b are zero but c is non-zero", () {
      expect(findCollision(1, 0, 0, 0, 0, 0), null);
    });
    test("Linear collision", () {
      expect(findCollision(4, 1, 0, 2, 2, 0), 2);
    });
    test("Linear no collision", () {
      expect(findCollision(4, 1, 0, 2, 7, 0), null);
    });
    test("Linear collision only in the past", () {
      expect(findCollision(0, 1, 0, -1, 0, 0), null);
    });
    test("Linear negative fractional time is not truncated to zero", () {
      expect(findCollision(1, 2, 0, 0, 0, 0), null);
    });
    test("Quadratic collision", () {
      expect(findCollision(0, 0, 1, 3, -2, 0), 1);
    });
    test("Acceleration changes velocity before position", () {
      expect(findCollision(0, 0, 1, 3, 0, 0), 2);
    });
    test("Negative discriminant", () {
      expect(findCollision(1, 0, 1, 0, 0, 0), null);
    });
    test("Non-square discriminant", () {
      expect(findCollision(0, 0, 1, 2, 0, 0), null);
    });
    test("Square discriminant with only fractional roots", () {
      expect(findCollision(-1, 0, 8, 0, 0, 0), null);
    });
    test("One fractional root and one integer root", () {
      expect(findCollision(-1, -3, 4, 0, 0, 0), 1);
    });
    test("Repeated integer root", () {
      expect(findCollision(1, -3, 2, 0, 0, 0), 1);
    });
    test("Earliest of two nonnegative roots", () {
      // Would collide at t = 1 and t = 2, but the earliest nonnegative root is t = 1.
      expect(findCollision(3, -5, 2, 0, 0, 0), 1);
    });
    test("Reversing particles preserves the earliest collision", () {
      expect(findCollision(0, 0, 0, 3, -5, 2), 1);
    });
    test("Quadratic collision only in the past", () {
      expect(findCollision(2, 2, 2, 0, 0, 0), null);
    });
    test("Initial overlap with different accelerations", () {
      expect(findCollision(0, -4, 2, 0, 0, 0), 0);
    });
  });

  group("findCollision3D", () {
    final origin = (
      x: Vector3(0, 0, 0),
      v: Vector3(0, 0, 0),
      a: Vector3(0, 0, 0),
    );

    test("Identical trajectories on all axes collide initially", () {
      final p = (x: Vector3(1, 2, 3), v: Vector3(4, 5, 6), a: Vector3(7, 8, 9));
      expect(findCollision3D(p, p), 0);
    });
    test("Only one constrained axis determines the collision time", () {
      for (final direction in [
        Vector3(1, 0, 0),
        Vector3(0, 1, 0),
        Vector3(0, 0, 1),
      ]) {
        final p = (
          x: Vector3(-2 * direction.x, -2 * direction.y, -2 * direction.z),
          v: direction,
          a: Vector3(0, 0, 0),
        );
        expect(findCollision3D(p, origin), 2);
      }
    });
    test("Identical moving axis imposes no time constraint", () {
      final p1 = (
        x: Vector3(5, -2, -4),
        v: Vector3(3, 1, 2),
        a: Vector3(1, 0, 0),
      );
      final p2 = (
        x: Vector3(5, 0, 0),
        v: Vector3(3, 0, 0),
        a: Vector3(1, 0, 0),
      );
      expect(findCollision3D(p1, p2), 2);
    });
    test("A parallel separated axis prevents collision", () {
      final p = (
        x: Vector3(-2, 1, 0),
        v: Vector3(1, 0, 0),
        a: Vector3(0, 0, 0),
      );
      expect(findCollision3D(p, origin), null);
    });
    test("Different collision times across axes do not collide", () {
      final p = (
        x: Vector3(-2, -3, 0),
        v: Vector3(1, 1, 0),
        a: Vector3(0, 0, 0),
      );
      expect(findCollision3D(p, origin), null);
    });
    test("A later quadratic root can be the shared collision time", () {
      final p = (
        x: Vector3(3, -3, 0),
        v: Vector3(-5, 1, 0),
        a: Vector3(2, 0, 0),
      );
      expect(findCollision3D(p, origin), 3);
      expect(findCollision3D(origin, p), 3);
    });
    test("All constrained axes must share a time", () {
      final p = (
        x: Vector3(-2, -4, -6),
        v: Vector3(1, 2, 3),
        a: Vector3(0, 0, 0),
      );
      expect(findCollision3D(p, origin), 2);
    });
    test("Collision in 3D", () {
      final p1 = (
        x: Vector3(-6, 0, 0),
        v: Vector3(3, 0, 0),
        a: Vector3(0, 0, 0),
      );
      final p2 = (
        x: Vector3(-4, 0, 0),
        v: Vector3(2, 0, 0),
        a: Vector3(0, 0, 0),
      );
      expect(findCollision3D(p1, p2), 2);
    });
  });
}
