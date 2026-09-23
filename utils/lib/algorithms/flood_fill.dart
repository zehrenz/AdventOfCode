import 'package:utils/data_structures/grid_base.dart';

/**
Flood fill algorithm for a grid.

Must start from a cell that is not a wall.
The [isValueWall] is used to determine which cells are considered walls by returning true for walls.
The [replacementValue] must be a wall according to the [isValueWall].

Returns the number of cells filled.
*/
int floodFill<T>(
  GridBase<T> grid,
  int startX,
  int startY,
  T replacementValue,
  bool Function(T value) isValueWall,
) {
  if (!isValueWall(replacementValue))
    throw ArgumentError('Replacement value must be a wall.');
  if (!grid.isInBounds(startX, startY) || isValueWall(grid.get(startX, startY)))
    return 0;
  var stack = <List<int>>[
    [startX, startY],
  ];
  var filled = 0;
  while (stack.isNotEmpty) {
    var [x, y] = stack.removeLast();
    if (!grid.isInBounds(x, y)) continue;
    if (isValueWall(grid.get(x, y))) continue;
    grid.set(x, y, replacementValue);
    filled++;
    stack.addAll([
      [x + 1, y],
      [x - 1, y],
      [x, y + 1],
      [x, y - 1],
    ]);
  }
  return filled;
}
