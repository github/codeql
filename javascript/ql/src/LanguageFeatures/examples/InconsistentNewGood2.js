function Point(x, y) {
  if (!(this instanceof Point))
    return new Point(x, y);
  this.x = x;
  this.y = y;
}

var p = new Point(23, 42),
    q = Point(56, 72);
