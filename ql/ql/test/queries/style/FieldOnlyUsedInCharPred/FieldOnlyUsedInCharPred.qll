class C1 extends int {
  int field; // BAD

  C1() {
    this = field and
    this = 0
  }
}

class C2 extends C1 {
  int field2; // GOOD

  C2() {
    this = field2 and
    this = 0
  }

  int getField() { result = field2 }
}

class C3 extends int {
  C1 field; // GOOD (overridden)

  C3() { this = field }
}

class C4 extends C3 {
  override C2 field; // GOOD (overriding)
}
