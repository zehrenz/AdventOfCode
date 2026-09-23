// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day15.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<String>;

InputType parseInput(String input) {
  return input.split(',');
}

String solvePart1(InputType input) {
  return input
      .map((item) => generateHash(item))
      .fold(0, (a, b) => a + b)
      .toString();
}

String solvePart2(InputType input) {
  List<Queue<Lens>> boxes = List.generate(256, (i) => Queue<Lens>());
  var matcher = RegExp(r'(\w+)([-=])(\d*)');
  for (var item in input) {
    var groups = matcher.firstMatch(item);
    if (groups == null) throw Exception("Invalid input: $item");
    var name = groups.group(1)!;
    var operation = groups.group(2)!;
    var value = groups.group(3) != '' ? int.parse(groups.group(3)!) : 0;
    var index = generateHash(name);

    var q = boxes[index];
    if (operation == '-')
      q.removeWhere((v) => v.name == name);
    else if (operation == '=') {
      var match = q.whereFirst((v) => v.name == name);
      if (match != null)
        match.focalLength = value;
      else
        q.push(Lens(name, value));
    } else
      throw Exception("Invalid operation: $operation");
  }
  return boxes.indexed
      .map<int>((entry) => getFocusingPowerForBox(entry.$2, entry.$1))
      .fold(0, (a, b) => a + b)
      .toString();
}

int generateHash(String input) {
  var current = 0;
  for (var i = 0; i < input.length; i++) {
    current = ((current + input.codeUnitAt(i)) * 17) % 256;
  }
  return current;
}

int getFocusingPowerForBox(Queue<Lens> q, int boxNumber) {
  var totalFocusingPower = 0;
  var boxPower = boxNumber + 1;
  for (var (index, lens) in q.indexed) {
    totalFocusingPower += boxPower * (index + 1) * lens.focalLength;
  }
  return totalFocusingPower;
}

class Lens {
  final String name;
  int focalLength;
  Lens(this.name, this.focalLength);
}
