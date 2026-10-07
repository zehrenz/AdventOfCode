// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';

void main() {
  var rawInput = Utils.readToString("../inputs/day18.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = List<Instruction>;

InputType parseInput(String input) {
  return input.splitNewLine().map((line) {
    var parts = line.split(' ');
    var x = int.tryParse(parts[1]) ?? parts[1];
    var y = parts.length > 2 ? (int.tryParse(parts[2]) ?? parts[2]) : null;
    return (parts[0], x, y);
  }).toList();
}

String solvePart1(InputType input) {
  var engine = DuetEngine(input);
  var result = engine.run();
  return result?.toString() ?? "";
}

String solvePart2(InputType input) {
  var aToBQueue = <int>[];
  var bToAQueue = <int>[];
  var progamA = DuetEngine(
    input,
    sendQueue: aToBQueue,
    receiveQueue: bToAQueue,
  );
  var progamB = DuetEngine(
    input,
    programId: 1,
    sendQueue: bToAQueue,
    receiveQueue: aToBQueue,
  );
  while (!progamA.stalled || !progamB.stalled) {
    progamA.run();
    progamB.run();
  }
  return progamB.sentCount.toString();
}

typedef Instruction = (String, Object, dynamic);

class DuetEngine {
  int currentIndex = 0;
  Map<String, int> registers = <String, int>{};
  List<Instruction> instructions;
  int? lastPlayedSound;
  List<int> _sendQueue;
  List<int> _receiveQueue;
  bool revision2;
  int sentCount = 0;
  bool stalled = false;
  bool _waitingForReceive = false;

  DuetEngine(
    this.instructions, {
    int programId = 0,
    List<int>? sendQueue,
    List<int>? receiveQueue,
  }) : _sendQueue = sendQueue ?? [],
       _receiveQueue = receiveQueue ?? [],
       revision2 = sendQueue != null && receiveQueue != null {
    if (revision2) {
      registers['p'] = programId;
    }
  }

  int? run() {
    stalled = false;
    if (_waitingForReceive && _receiveQueue.isEmpty) {
      stalled = true;
      return null;
    }
    _waitingForReceive = false;
    while (currentIndex >= 0 && currentIndex < instructions.length) {
      var currentInstruction = instructions[currentIndex];
      var xValue = currentInstruction.$2 is int
          ? currentInstruction.$2 as int
          : registers[currentInstruction.$2 as String] ?? 0;
      var yValue = currentInstruction.$3 is int
          ? currentInstruction.$3 as int
          : currentInstruction.$3 is String
          ? registers[currentInstruction.$3 as String] ?? 0
          : 0;
      switch (currentInstruction.$1) {
        case "snd":
          if (revision2) {
            _sendQueue.add(xValue);
            sentCount++;
          } else {
            lastPlayedSound = xValue;
          }
          break;
        case "set":
          registers[currentInstruction.$2 as String] = yValue;
          break;
        case "add":
          registers[currentInstruction.$2 as String] = xValue + yValue;
          break;
        case "mul":
          registers[currentInstruction.$2 as String] = xValue * yValue;
          break;
        case "mod":
          registers[currentInstruction.$2 as String] = xValue % yValue;
          break;
        case "jgz":
          if (xValue > 0) {
            currentIndex += yValue - 1;
          }
          break;
        case "rcv":
          if (revision2) {
            if (_receiveQueue.isEmpty) {
              _waitingForReceive = true;
              return null;
            }
            registers[currentInstruction.$2 as String] = _receiveQueue.removeAt(
              0,
            );
          } else if (xValue != 0) {
            return lastPlayedSound;
          }
          break;
      }
      currentIndex++;
    }
    stalled = true;
    return null;
  }
}
