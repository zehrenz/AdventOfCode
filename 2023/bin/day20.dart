// ignore_for_file: dead_code

import 'package:utils/dart_utils.dart';
import 'package:utils/data_structures.dart' show Queue;

void main() {
  var rawInput = Utils.readToString("../inputs/day20.txt");
  Utils.runWithTiming(parseInput, solvePart1, solvePart2, rawInput);
}

typedef InputType = Map<String, Module>;

InputType parseInput(String input) {
  var modules = <String, Module>{};
  var conjunctionModules = <ConjunctionModule>[];
  var sendersByTarget = <String, List<String>>{};
  var register = (List<String> targets, String sender) {
    for (var target in targets) {
      sendersByTarget.putIfAbsent(target, () => []).add(sender);
    }
  };
  for (var line in input.splitNewLine()) {
    var parts = line.split(' -> ');
    var targets = parts[1].split(', ');
    switch (parts[0][0]) {
      case 'b':
        modules[parts[0]] = BroadcastModule(parts[0], targets);
        register(targets, parts[0]);
        break;
      case '%':
        modules[parts[0].substring(1)] = FlipModule(
          parts[0].substring(1),
          targets,
        );
        register(targets, parts[0].substring(1));
        break;
      case '&':
        var conjunctionModule = ConjunctionModule(
          parts[0].substring(1),
          targets,
        );
        register(targets, parts[0].substring(1));
        conjunctionModules.add(conjunctionModule);
        modules[conjunctionModule.name] = conjunctionModule;
        break;
      default:
        throw ArgumentError('Unknown module type in line: ${line}');
    }
  }
  for (var con in conjunctionModules) {
    var senders = sendersByTarget[con.name] ?? [];
    for (var sender in senders) {
      con.registerSender(sender);
    }
  }
  // Any targets that don't have a corresponding module get a NoOpModule.
  for (var target in sendersByTarget.keys) {
    modules.putIfAbsent(target, () => NoOpModule());
  }
  return modules;
}

String solvePart1(InputType input) {
  var lowTotal = 0;
  var highTotal = 0;
  for (var i = 0; i < 1000; i++) {
    var result = pressButton(input);
    lowTotal += result.lowCount;
    highTotal += result.highCount;
  }
  return (lowTotal * highTotal).toString();
}

String solvePart2(InputType input) {
  return "";
}

({int lowCount, int highCount}) pressButton(Map<String, Module> modules) {
  var q = Queue<Pulse>();
  var lowCount = 1; // First pulse is always low
  var highCount = 0;
  q.pushAll(modules['broadcaster']!.acceptPulse('', false));
  while (q.isNotEmpty) {
    var pulse = q.pop();
    if (pulse.pulseHigh) {
      highCount++;
    } else {
      lowCount++;
    }
    var module = modules[pulse.target];
    if (module == null)
      throw ArgumentError('Module not found for target: ${pulse.target}');
    var nextPulses = module.acceptPulse(pulse.sender, pulse.pulseHigh);
    q.pushAll(nextPulses);
  }
  return (lowCount: lowCount, highCount: highCount);
}

typedef Pulse = ({String target, String sender, bool pulseHigh});

abstract class Module {
  final String name;
  final List<String> targets;

  Module(this.name, this.targets);

  List<Pulse> acceptPulse(String sender, bool pulseHigh);
}

class BroadcastModule extends Module {
  // Relay module that simply broadcasts any received pulse to all its targets.
  BroadcastModule(String name, List<String> targets) : super(name, targets);

  @override
  List<Pulse> acceptPulse(String sender, bool pulseHigh) {
    return targets
        .map((target) => (target: target, sender: name, pulseHigh: pulseHigh))
        .toList();
  }
}

class FlipModule extends Module {
  // The flip module toggles its state whenever it receives a low pulse and sents its new state
  // A high pulse is ignored
  bool isOn = false;

  FlipModule(String name, List<String> targets) : super(name, targets);

  @override
  List<Pulse> acceptPulse(String sender, bool pulseHigh) {
    if (pulseHigh) return [];
    isOn = !isOn;
    return targets
        .map((target) => (target: target, sender: name, pulseHigh: isOn))
        .toList();
  }
}

class ConjunctionModule extends Module {
  // If all incoming pulses are high, the conjunction module will send a low pulse to its targets.
  // Otherwise, it will send a high pulse.
  final Map<String, bool> pulseStates = {};

  ConjunctionModule(String name, List<String> targets) : super(name, targets);

  void registerSender(String sender) {
    pulseStates[sender] = false;
  }

  @override
  List<Pulse> acceptPulse(String sender, bool pulseHigh) {
    pulseStates[sender] = pulseHigh;
    var sendLow = pulseStates.values.every((v) => v);
    return targets
        .map((target) => (target: target, sender: name, pulseHigh: !sendLow))
        .toList();
  }
}

class NoOpModule extends Module {
  // Output is a no-op
  NoOpModule() : super('output', []);

  @override
  List<Pulse> acceptPulse(String sender, bool pulseHigh) {
    return [];
  }
}
