class Range extends string {
  Range() { this = "ql" }

  string getAChild() { result = "test" }
}

class Inst extends string {
  // $ Alert
  Range range;

  Inst() { this = range }

  string getAChild() { result = range.getAChild() }
}

class Inst2 extends string {
  // $ Alert
  Inst2() { this instanceof Range }

  string getAChild() { result = this.(Range).getAChild() }
}

class Inst3 extends string {
  // $ Alert
  Range range;

  Inst3() { this = range }

  Range getRange() { result = range }
}

class Inst4 extends string {
  // $ Alert
  Inst4() { this instanceof Range }
}
