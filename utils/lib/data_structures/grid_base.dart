import 'package:utils/dart_utils.dart';

abstract class GridBase<T> {
  T get(int x, int y);
  T getPoint(Point p) => get(p.x, p.y);
  void set(int x, int y, T value);
  void setPoint(Point p, T value) => set(p.x, p.y, value);
  bool isInBounds(int x, int y);
  bool isPointInBounds(Point p) => isInBounds(p.x, p.y);
  int get width;
  int get height;
}
