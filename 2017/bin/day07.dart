// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day07.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = ({
  Map<String, int> weights,
  Map<String, List<String>> children,
});

InputType parseInput(String input) {
  var weights = <String, int>{};
  var children = <String, List<String>>{};
  for (var line in input.splitNewLine()) {
    var (name, weight, childList) = parseLine(line);
    weights[name] = weight;
    if (childList != null) {
      children[name] = childList;
    }
  }
  return (weights: weights, children: children);
}

(String, int, List<String>?) parseLine(String line) {
  var halves = line.split(" -> ");
  var record = halves[0].split(' ');
  var list = halves.elementAtOrNull(1)?.split(", ");
  return (
    record[0],
    int.parse(record[1].substring(1, record[1].length - 1)),
    list,
  );
}

String solvePart1(InputType input) {
  var (weights: weights, children: children) = input;
  var allChildren = children.values.expand((x) => x).toSet();
  for (var name in weights.keys) {
    if (!allChildren.contains(name)) {
      return name;
    }
  }
  throw Exception("No root found");
}

String solvePart2(InputType input) {
  return "";
}
