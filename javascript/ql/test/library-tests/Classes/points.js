class Point {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  get dist() {
    return Math.sqrt(this.x*this.x+this.y*this.y);
  }

  toString() {
    return "(" + this.x + ", " + this.y + ")";
  }

  static className() {
    return "Point";
  }
}

class ColouredPoint extends Point {
  constructor(x, y, colour) {
    super(x, y);
    this.colour = c;
  }

  toString() {
    return super.toString() + " in " + this.colour;
  }

  static className() {
    return "ColouredPoint";
  }
}
