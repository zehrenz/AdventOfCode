import 'package:utils/data_structures/grid_base.dart';

class SparseGrid<T> extends GridBase<T> {
  final _grid = <int, Map<int, T>>{};
  final T defaultValue;
  int? minX;
  int? maxX;
  int? minY;
  int? maxY;

  SparseGrid(this.defaultValue);
  @override
  T get(int x, int y) {
    if (!_grid.containsKey(x)) return defaultValue;
    return _grid[x]![y] ?? defaultValue;
  }

  @override
  void set(int x, int y, T value) {
    if (!_grid.containsKey(x)) _grid[x] = {};
    _grid[x]![y] = value;
    if (minX == null || x < minX!) minX = x;
    if (maxX == null || x > maxX!) maxX = x;
    if (minY == null || y < minY!) minY = y;
    if (maxY == null || y > maxY!) maxY = y;
  }

  bool isInBounds(int x, int y) {
    if (_grid.isEmpty) return false;
    return x >= minX! && x <= maxX! && y >= minY! && y <= maxY!;
  }

  @override
  int get width {
    if (_grid.isEmpty) return 0;
    return maxX! - minX! + 1;
  }

  @override
  int get height {
    if (_grid.isEmpty) return 0;
    return maxY! - minY! + 1;
  }
}
