import 'package:test/test.dart';
import 'package:utils/algorithms/flood_fill.dart';
import 'package:utils/data_structures.dart' show Grid;

void main() {
  const wall = '#';
  const empty = '.';

  Grid<String> gridFromRows(List<String> rows) =>
      Grid.fromArrays(rows.map((row) => row.split('')).toList());

  group('floodFill', () {
    test('counts the start cell exactly once', () {
      final grid = gridFromRows(['.']);

      final filled = floodFill(grid, 0, 0, wall, (value) => value == wall);

      expect(filled, 1);
      expect(grid.get(0, 0), wall);
    });

    test('returns zero for an out-of-bounds start', () {
      final grid = gridFromRows(['..', '..']);

      for (final (startX, startY) in [(-1, 0), (0, -1), (2, 0), (0, 2)]) {
        expect(
          floodFill(grid, startX, startY, wall, (value) => value == wall),
          0,
        );
      }
      expect(grid.count((value, _) => value == empty), 4);
    });

    test('fills every reachable non-wall cell', () {
      final grid = gridFromRows(['....', '.##.', '....']);

      final filled = floodFill(grid, 0, 0, wall, (value) => value == wall);

      expect(filled, 10);
      expect(grid.count((value, _) => value == wall), 12);
    });

    test('does not fill a wall start cell', () {
      final grid = gridFromRows(['.#', '..']);

      final filled = floodFill(grid, 1, 0, wall, (value) => value == wall);

      expect(filled, 0);
      expect(grid.get(1, 0), wall);
    });

    test('does not cross walls into disconnected regions', () {
      final grid = gridFromRows(['.#.', '.#.', '.#.']);

      final filled = floodFill(grid, 0, 1, wall, (value) => value == wall);

      expect(filled, 3);
      expect(grid.get(0, 0), wall);
      expect(grid.get(0, 2), wall);
      expect(grid.get(2, 1), empty);
    });

    test('rejects a replacement value that is not a wall', () {
      final grid = gridFromRows(['.']);

      expect(
        () => floodFill(grid, 0, 0, 'X', (value) => value == wall),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
