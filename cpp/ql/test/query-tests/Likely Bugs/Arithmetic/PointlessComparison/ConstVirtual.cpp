struct C {
  virtual int get() const {
    return -1;
  }
};

int f(C *c, int i) {
  if (i >= 0 && c->get() == -1) {
    return -1;
  }

  if (i > 0) { // GOOD: a subclass of `C` may have overridden `get`
    return 1;
  } else {
    return 0;
  }
}

int g(C *c, int i) {
  if (i >= 0 && c->C::get() == -1) { // note: non-virtual call
    return -1;
  }

  if (i > 0) { // BAD
    return 1;
  } else {
    return 0;
  }
}
