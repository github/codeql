function Rectangle(x, y, width, height) {
  this.x = x;
  this.y = y;
  this.width = width;
  this.height = height;
}

Rectangle.prototype.contains = function(x, y) {
  return (this.x <= x &&
          x < this.x+this.width) &&
         (y <= y &&
          y < this.y+this.height);
};
