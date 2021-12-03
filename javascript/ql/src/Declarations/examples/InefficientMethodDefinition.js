function Point(x, y) {
  this.x = x;
  this.y = y;
  this.move = function(dx, dy) {
    this.x += dx;
    this.y += dy;
  };
}

var p = new Point(2, 3),
    q = new Point(3, 4);
