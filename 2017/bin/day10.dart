// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day10.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = String;

InputType parseInput(String input) {
  return input;
}

String solvePart1(InputType input, [int length = 256]) {
  var list = List<int>.generate(length, (i) => i);
  var lengths = input.split(',').map(int.parse).toList();
  runLengths(list, lengths);

  return (list[0] * list[1]).toString();
}

String solvePart2(InputType input) {
  return getFullHash(input);
}

void reverse(List<int> list, int start, int length) {
  int left = start;
  int right = (start + length - 1) % list.length;
  for (int i = 0; i < length ~/ 2; i++) {
    int temp = list[left];
    list[left] = list[right];
    list[right] = temp;
    left = (left + 1) % list.length;
    right = (right - 1 + list.length) % list.length;
  }
}

void runLengths(List<int> list, List<int> lengths, [int repetitions = 1]) {
  int currentPosition = 0;
  int skipSize = 0;
  for (int r = 0; r < repetitions; r++) {
    for (var length in lengths) {
      reverse(list, currentPosition, length);
      currentPosition = (currentPosition + length + skipSize) % list.length;
      skipSize++;
    }
  }
}

String getFullHash(String input) {
  var list = List<int>.generate(256, (i) => i);
  var lengths = getExtendedLengths(input);
  runLengths(list, lengths, 64);
  var denseHash = getDenseHash(list);
  return toHexString(denseHash);
}

List<int> getExtendedLengths(String input) {
  var lengths = input.codeUnits.toList();
  lengths.addAll([17, 31, 73, 47, 23]);
  return lengths;
}

List<int> getDenseHash(List<int> sparseHash) {
  var denseHash = <int>[];
  for (int i = 0; i < sparseHash.length; i += 16) {
    denseHash.add(sparseHash.sublist(i, i + 16).reduce((a, b) => a ^ b));
  }
  return denseHash;
}

String toHexString(List<int> denseHash) {
  return denseHash.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
