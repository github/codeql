void allocate_and_draw_good() {
  Shape* shape = new Circle;
  // ...
  // GOOD: Dynamically checks if shape is a Square
  Square* square = dynamic_cast<Square*>(shape);
  if(square) {
    int length = square->getLength();
  } else {
    // handle error
  }
}