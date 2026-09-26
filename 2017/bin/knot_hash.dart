String getKnotHash(String input) {
  var list = List<int>.generate(256, (i) => i);
  var lengths = getExtendedLengths(input);
  runLengths(list, lengths, 64);
  var denseHash = getDenseHash(list);
  return toHexString(denseHash);
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
