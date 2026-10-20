// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day20.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

final particleRegex = RegExp(
  r'p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>',
);

typedef Particle = (Vector3 position, Vector3 velocity, Vector3 acceleration);

class Vector3 {
  final int x;
  final int y;
  final int z;

  Vector3(this.x, this.y, this.z);
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
    return (position, velocity, acceleration);
  }).toList();
}

String solvePart1(InputType input) {
  int minDistance = getManhattanDistance(input[0].$1, input[0].$2, input[0].$3);
  var closestParticle = 0;
  for (var i = 1; i < input.length; i++) {
    var (position, velocity, acceleration) = input[i];
    var distance = getManhattanDistance(position, velocity, acceleration);
    if (distance < minDistance) {
      minDistance = distance;
      closestParticle = i;
    }
  }
  return closestParticle.toString();
}

String solvePart2(InputType input) {
  return "";
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
