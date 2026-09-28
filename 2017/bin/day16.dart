// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day16.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef Step = (String, String, String?);
typedef InputType = List<Step>;

InputType parseInput(String input) {
  return input.split(',').map((line) {
    var parts = line.split('/');
    return (parts[0][0], parts[0].substring(1), parts.elementAtOrNull(1));
  }).toList();
}

String solvePart1(InputType input, [int programCount = 16]) {
  var programs = List.generate(
    programCount,
    (i) => String.fromCharCode('a'.codeUnitAt(0) + i),
  );
  for (var step in input) {
    var (a, b, c) = step;
    switch (a) {
      case 's':
        var count = int.parse(b);
        programs =
            programs.sublist(programs.length - count) +
            programs.sublist(0, programs.length - count);
        break;
      case 'x':
        var posA = int.parse(b);
        var posB = int.parse(c!);
        var temp = programs[posA];
        programs[posA] = programs[posB];
        programs[posB] = temp;
        break;
      case 'p':
        var indexA = programs.indexOf(b);
        var indexB = programs.indexOf(c!);
        var temp = programs[indexA];
        programs[indexA] = programs[indexB];
        programs[indexB] = temp;
        break;
    }
  }
  return programs.join();
}

String solvePart2(InputType input) {
  return "";
}
