// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day20.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

final particleRegex = RegExp(
  r'p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>',
);

typedef Particle = ({Vector3 x, Vector3 v, Vector3 a});

class Vector3 {
  final int x;
  final int y;
  final int z;

  Vector3(this.x, this.y, this.z);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vector3 && other.x == x && other.y == y && other.z == z;
  }

  @override
  int get hashCode => Object.hash(x, y, z);
}

typedef InputType = List<Particle>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var match = particleRegex.firstMatch(line)!;
    var position = Vector3(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
    var velocity = Vector3(
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.parse(match.group(6)!),
    );
    var acceleration = Vector3(
      int.parse(match.group(7)!),
      int.parse(match.group(8)!),
      int.parse(match.group(9)!),
    );
    return (x: position, v: velocity, a: acceleration);
  }).toList();
}

String solvePart1(InputType input) {
  int minDistance = getManhattanDistance(input[0].x, input[0].v, input[0].a);
  var closestParticle = 0;
  for (var i = 1; i < input.length; i++) {
    var p = input[i];
    var distance = getManhattanDistance(p.x, p.v, p.a);
    if (distance < minDistance) {
      minDistance = distance;
      closestParticle = i;
    }
  }
  return closestParticle.toString();
}

String solvePart2(InputType input) {
  List<Particle> particles = input;
  int listSize = particles.length;
  while (true) {
    particles = removeCollisions(particles);
    if (particles.length == listSize) break;
    listSize = particles.length;
  }
  return particles.length.toString();
}

const DEFAULT_TIME = 1000000;
int getPosition(int pos, int vel, int acc, [int t = DEFAULT_TIME]) {
  return pos + vel * t + acc * t * (t + 1) ~/ 2;
}

Vector3 getPosition3(
  Vector3 position,
  Vector3 velocity,
  Vector3 acceleration, [
  int t = DEFAULT_TIME,
]) {
  return Vector3(
    getPosition(position.x, velocity.x, acceleration.x, t),
    getPosition(position.y, velocity.y, acceleration.y, t),
    getPosition(position.z, velocity.z, acceleration.z, t),
  );
}

int getManhattanDistance(
  Vector3 position,
  Vector3 velocity,
  Vector3 acceleration, [
  int t = DEFAULT_TIME,
]) {
  var pos = getPosition3(position, velocity, acceleration, t);
  return pos.x.abs() + pos.y.abs() + pos.z.abs();
}

int? findCollision(int x1, int v1, int a1, int x2, int v2, int a2) {
  final times = _findCollisionTimes(x1, v1, a1, x2, v2, a2);
  if (times == null) return 0;
  return times.isEmpty ? null : times.reduce((a, b) => a < b ? a : b);
}

// null means identical trajectories (all times); an empty set means no collision.
Set<int>? _findCollisionTimes(int x1, int v1, int a1, int x2, int v2, int a2) {
  // AoC updates velocity before position: x(t) = x + v*t + a*t*(t+1)/2.
  // Multiply the position-difference equation by 2 to clear the /2
  // in the acceleration term, keeping the quadratic coefficients integer.
  final a = a1 - a2;
  final b = 2 * (v1 - v2) + a;
  final c = 2 * (x1 - x2);

  // Only nonnegative integer ticks count; an initial overlap counts as t = 0.
  if (a == 0) {
    // Acceleration is zero, so the equation is linear: b*t + c = 0.
    if (b == 0) return c == 0 ? null : <int>{};

    // Check divisibility before ~/ so fractional times cannot be truncated.
    if (c % b != 0) return <int>{};
    final t = -c ~/ b;
    return {if (t >= 0) t};
  }

  final discriminant = b * b - 4 * a * c;
  if (discriminant < 0) return <int>{};

  // Integer roots require a perfect-square discriminant. Integer Newton
  // iteration finds its floor square root without floating-point rounding.
  var root = discriminant;
  var nextRoot = (root + 1) ~/ 2;
  while (nextRoot < root) {
    root = nextRoot;
    nextRoot = (root + discriminant ~/ root) ~/ 2;
  }
  if (root * root != discriminant) return <int>{};

  final denominator = 2 * a;
  final times = <int>{};
  for (final numerator in [-b + root, -b - root]) {
    // A square discriminant alone is not enough: division must also be exact.
    if (numerator % denominator != 0) continue;
    final t = numerator ~/ denominator;
    if (t >= 0) times.add(t);
  }
  return times;
}

int? findCollision3D(Particle p1, Particle p2) {
  Set<int>? commonTimes;
  for (final (x1, v1, a1, x2, v2, a2) in [
    (p1.x.x, p1.v.x, p1.a.x, p2.x.x, p2.v.x, p2.a.x), // x path
    (p1.x.y, p1.v.y, p1.a.y, p2.x.y, p2.v.y, p2.a.y), // y path
    (p1.x.z, p1.v.z, p1.a.z, p2.x.z, p2.v.z, p2.a.z), // z path
  ]) {
    final times = _findCollisionTimes(x1, v1, a1, x2, v2, a2);
    // Identical trajectories on this axis impose no constraint on time.
    if (times == null) continue;
    commonTimes = commonTimes == null ? times : commonTimes.intersection(times);
    if (commonTimes.isEmpty) return null;
  }
  // If all axes are identical, the particles already overlap at t = 0.
  return commonTimes == null ? 0 : commonTimes.reduce((a, b) => a < b ? a : b);
}

class PCol {
  int time;
  Particle p;

  PCol(this.p) : time = -1;
}

List<Particle> removeCollisions(List<Particle> particles) {
  final collisions = particles.map((particle) => PCol(particle)).toList();
  for (var i = 0; i < particles.length; i++) {
    for (var j = i + 1; j < particles.length; j++) {
      final t = findCollision3D(particles[i], particles[j]);
      if (t != null) {
        collisions[i].time = t;
        collisions[j].time = t;
      }
    }
  }
  final collisionTimes = collisions.map((e) => e.time).where((t) => t != -1);
  final earliestCollisionTime = collisionTimes.isEmpty
      ? null
      : collisionTimes.reduce((a, b) => a < b ? a : b);

  return collisions
      .where((pair) => pair.time != earliestCollisionTime)
      .map((pair) => pair.p)
      .toList();
}
