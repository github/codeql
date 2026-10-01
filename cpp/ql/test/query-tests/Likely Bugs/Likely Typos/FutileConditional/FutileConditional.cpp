void emptyIfs(int value) {
  if (value) {} // $ Alert

  if (value > 1) {
  } // $ Alert

  if (value) {
    ++value;
  }

  if (value) {
  } else {
    ++value;
  }
}
