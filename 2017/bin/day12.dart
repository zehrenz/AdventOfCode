// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart' show UnionFindInt;

void main() {
  var rawInput = Utils.readToString("../inputs/day12.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = Map<int, List<int>>;

InputType parseInput(String input) {
  var map = <int, List<int>>{};
  for (var line in input.splitNewLine()) {
    var parts = line.split(' <-> ');
    var key = int.parse(parts[0]);
    var values = parts[1].split(', ').map(int.parse).toList();
    map[key] = values;
  }
  return map;
}

String solvePart1(InputType input) {
  UnionFindInt uf = UnionFindInt(input.length);
  for (var key in input.keys) {
    for (var value in input[key]!) {
      uf.union(key, value);
    }
  }
  return uf.sizeOf(0).toString();
}

String solvePart2(InputType input) {
  return "";
}
