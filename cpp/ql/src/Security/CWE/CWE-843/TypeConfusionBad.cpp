void allocate_and_draw_bad() {
  Shape* shape = new Circle;
  // ...
  // BAD: Assumes that shape is always a Square
  Square* square = static_cast<Square*>(shape);
  int length = square->getLength();
}