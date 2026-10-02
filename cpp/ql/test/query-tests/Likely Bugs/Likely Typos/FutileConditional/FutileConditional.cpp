void emptyIfs(int value) {
  if (value) {} // $ Alert[cpp/empty-if]

  if (value > 1) {
  } // $ Alert[cpp/empty-if]

  if (value) { // GOOD
    ++value;
  }

  if (value) { // GOOD
  } else {
    ++value;
  }

  if (value) { // $ MISSING: Alert[cpp/empty-if]
  } else {
  }
}
