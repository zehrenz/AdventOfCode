// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day19.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = ({
  Map<String, Workflow> workflows,
  List<Map<String, int>> parts,
});

InputType parseInput(String input) {
  var sections = input.splitDoubleNewLine();
  var workflows = Map.fromEntries(
    sections[0].splitNewLine().map((line) {
      var workflow = parseWorkflow(line);
      return MapEntry(workflow.name, workflow);
    }),
  );
  var parts = sections[1]
      .splitNewLine()
      .map((line) => parsePart(line))
      .toList();
  return (workflows: workflows, parts: parts);
}

Workflow parseWorkflow(String line) {
  var openParenIndex = line.indexOf('{');
  var name = line.substring(0, openParenIndex).trim();
  var parts = line.substring(openParenIndex + 1, line.length - 1).split(',');
  var defaultValue = parts.removeLast().trim();
  var rules = parts.map(parseRule).toList();
  return Workflow(name: name, rules: rules, defaultRoute: defaultValue);
}

final ruleRegExp = RegExp(r'(.)(>|<)(\d+):(\w+)');
Rule parseRule(String ruleString) {
  var match = ruleRegExp.firstMatch(ruleString);
  if (match == null) {
    throw FormatException("Invalid rule format: $ruleString");
  }
  var aspect = match.group(1)!;
  var greaterThan = match.group(2) == '>';
  var value = int.parse(match.group(3)!);
  var route = match.group(4)!;
  return Rule(
    aspect: aspect,
    greaterThan: greaterThan,
    value: value,
    route: route,
  );
}

Map<String, int> parsePart(String line) {
  var inner = line.substring(1, line.length - 1);
  var entries = inner.split(',');
  return Map.fromIterable(
    entries.map((entry) => entry.split('=')),
    key: (entry) => entry[0],
    value: (entry) => int.parse(entry[1]),
  );
}

String solvePart1(InputType input) {
  var (workflows: workflows, parts: parts) = input;
  return parts
      .where((part) => checkPart(part, workflows))
      .fold(0, (sum, part) => sum + scorePart(part))
      .toString();
}

String solvePart2(InputType input) {
  return "";
}

bool checkPart(Map<String, int> part, Map<String, Workflow> workflows) {
  Workflow current = workflows['in']!;
  while (true) {
    var route = current.runWorkflow(part);
    if (route == 'A') {
      return true;
    } else if (route == 'R')
      return false;
    current = workflows[route]!;
  }
}

int scorePart(Map<String, int> part) {
  return part.values.reduce((a, b) => a + b);
}

class Workflow {
  final String name;
  final List<Rule> rules;
  final String defaultRoute;

  const Workflow({
    required this.name,
    required this.rules,
    required this.defaultRoute,
  });

  String runWorkflow(Map<String, int> part) {
    for (var rule in rules) {
      var result = rule.run(part);
      if (result != null) {
        return result;
      }
    }
    return defaultRoute;
  }
}

class Rule {
  final String aspect;
  final bool greaterThan;
  final int value;
  final String route;
  const Rule({
    required this.aspect,
    required this.greaterThan,
    required this.value,
    required this.route,
  });

  String? run(Map<String, int> part) {
    if (greaterThan) {
      if (part[aspect]! > value) {
        return route;
      }
    } else {
      if (part[aspect]! < value) {
        return route;
      }
    }
    return null;
  }
}
