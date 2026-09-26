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
  var root = solvePart1(input);
  var (weights: weights, children: children) = input;
  try {
    var tree = TreeNode(root, weights, children);
    tree.childWeightSum;
  } catch (e) {
    return (e as int).toString();
  }
  throw Exception("No imbalance found");
}

class TreeNode {
  final String name;
  final int weight;
  final List<TreeNode> children;
  int? _childWeightSum;
  int get childWeightSum {
    // Find the weight of all children. If one child has a different total weight, identify it and calculate the adjustment needed.
    // Throw to short circuit if an imbalance is found.
    if (_childWeightSum != null) {
      return _childWeightSum!;
    }
    // Find the weight of each child.
    var childWeights = children.map((c) => c.totalWeight).toList();
    _childWeightSum = children.map((c) => c.totalWeight).sum();
    if (childWeights.every((weight) => weight == childWeights.first)) {
      // All good
      return _childWeightSum!;
    }
    // Imbalance detected, calculate the adjustment needed.
    Map<int, int> weightCounts = {};
    // Count the occurrences of each child weight to identify the wrong one.
    for (var w in childWeights) {
      weightCounts.increment(w);
    }
    var wrongWeight = weightCounts.entries
        .firstWhere((entry) => entry.value == 1)
        .key;
    var oddDuck = children.firstWhere((c) => c.totalWeight == wrongWeight);
    var correctWeight = childWeights.firstWhere(
      (weight) => weight != wrongWeight,
    );
    var expectedWeightOfOddDuck = correctWeight - oddDuck.childWeightSum;
    throw expectedWeightOfOddDuck;
  }

  int get totalWeight => weight + childWeightSum;

  TreeNode(
    this.name,
    Map<String, int> weights,
    Map<String, List<String>> children,
  ) : weight = weights[name]!,
      children = (children[name] ?? [])
          .map((name) => TreeNode(name, weights, children))
          .toList();
}
