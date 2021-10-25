struct S {
  int val;
  
  // The const has no effect here.
  auto getValIncorrect() -> const int {
    return val;
  }
  
  // Whereas here it does make a semantic difference.
  auto getValCorrect() const -> int {
    return val;
  }
};
