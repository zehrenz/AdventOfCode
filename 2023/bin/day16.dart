// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day16.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

class Energy {
  static const int NONE = 0, VERTICAL = 1, HORIZONTAL = 2, BOTH = 3;
}

InputType parseInput(String input) {
  return input.splitNewLine();
}

String solvePart1(InputType input) {
  var energized = Grid<int>(
    ((x, y) => Energy.NONE),
    input[0].length,
    input.length,
  );
  var activeRays = Queue<Ray>();
  var startRay = Ray(Point(0, 0), Point.right);
  // Mark the first spot as energized
  activeRays.push(startRay);
  while (activeRays.isNotEmpty) {
    var ray = activeRays.pop();
    while (moveRay(ray, input, energized, activeRays)) {}
  }
  return energized.count((val, _) => val != Energy.NONE).toString();
}

String solvePart2(InputType input) {
  return "";
}

bool moveRay(
  Ray ray,
  InputType input,
  Grid<int> energized,
  Queue<Ray> activeRays,
) {
  var tile = input[ray.position.y][ray.position.x];
  var currentEnergy = energized.getPoint(ray.position);
  Ray? newRay;
  switch (tile) {
    // Mirrors
    case '\\':
      ray.direction = ray.direction.x == 0
          ? ray.direction.rotateCounterClockwise()
          : ray.direction.rotateClockwise();
      break;
    case '/':
      ray.direction = ray.direction.x == 0
          ? ray.direction.rotateClockwise()
          : ray.direction.rotateCounterClockwise();
      break;
    // Splitters
    case '|':
      if (ray.direction.y == 0) {
        // If we have already split here, don't split again
        if (currentEnergy == Energy.HORIZONTAL || currentEnergy == Energy.BOTH)
          return false;
        var newRayDirection = ray.direction.rotateClockwise();
        newRay = Ray(ray.position + newRayDirection, newRayDirection);
        ray.direction = ray.direction.rotateCounterClockwise();
      }
      break;
    case '-':
      if (ray.direction.x == 0) {
        // If we have already split here, don't split again
        if (currentEnergy == Energy.VERTICAL || currentEnergy == Energy.BOTH)
          return false;
        var newRayDirection = ray.direction.rotateClockwise();
        newRay = Ray(ray.position + newRayDirection, newRayDirection);
        ray.direction = ray.direction.rotateCounterClockwise();
      }
      break;
    // Empty space
    default:
      break;
  }
  markSpot(ray, energized);
  // If we made a new ray, check it and mark it's spot
  if (newRay != null) {
    if (isValidContinue(newRay, energized, input)) {
      activeRays.push(newRay);
    }
  }
  ray.position += ray.direction;

  return isValidContinue(ray, energized, input);
}

void markSpot(Ray ray, Grid<int> energized) {
  var currentEnergy = energized.getPoint(ray.position);
  energized.setPoint(
    ray.position,
    currentEnergy +
        (ray.direction.x == 0 ? Energy.VERTICAL : Energy.HORIZONTAL),
  );
}

bool isValidContinue(Ray ray, Grid<int> energized, InputType input) {
  // A ray can continue if it is in bounds and either on a mirror or hasn't been here before
  return isInBounds(ray.position, input) &&
      ('\\/'.contains(input[ray.position.y][ray.position.x]) ||
          !beenHereBefore(ray, energized));
}

bool isInBounds(Point p, InputType input) {
  return p.x >= 0 && p.x < input[0].length && p.y >= 0 && p.y < input.length;
}

bool beenHereBefore(Ray r, Grid<int> energized) {
  var currentEnergy = energized.getPoint(r.position);
  if (currentEnergy == Energy.BOTH) return true;
  if (r.direction.x == 0 && currentEnergy == Energy.VERTICAL) return true;
  if (r.direction.y == 0 && currentEnergy == Energy.HORIZONTAL) return true;
  return false;
}

class Ray {
  Point position;
  Point direction;
  Ray(this.position, this.direction);
}
