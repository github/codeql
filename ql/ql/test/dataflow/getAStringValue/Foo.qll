predicate isLeft(string s) { none() }

predicate isRight(string s) { none() }

predicate disjunct() {
  exists(string x |
    x = "left_1" and
    isLeft(x) // $ getAStringValue=left_1
    or
    x = "right_1" and
    isRight(x) // $ getAStringValue=right_1
  )
}

string sourceLeft2() { result = "left_2" }

predicate sinkLeft2(string x) {
  isLeft(x) // $ getAStringValue=left_2
}

string sourceRight2() { result = "right_2" }

predicate sinkRight2(string x) {
  isRight(x) // $ getAStringValue=right_2
}

predicate disjunctViaCall() {
  exists(string x |
    x = sourceLeft2() and
    sinkLeft2(x) // $ getAStringValue=left_2
    or
    x = sourceRight2() and
    sinkRight2(x) // $ getAStringValue=right_2
  )
}

predicate distribute() {
  exists(string x |
    x = "left_3"
    or
    x = "right_3"
  |
    isLeft(x) // $ getAStringValue=left_3 getAStringValue=right_3
    or
    isRight(x) // $ getAStringValue=left_3 getAStringValue=right_3
  )
}

predicate distributeSet() {
  exists(string x | x = ["left_4", "right_4"] |
    isLeft(x) // $ getAStringValue=left_4 getAStringValue=right_4
    or
    isRight(x) // $ getAStringValue=left_4 getAStringValue=right_4
  )
}

predicate noFlowBackOut() {
  exists(string x |
    isLeft(x) // no value
  )
}

class StringClass extends string {
  StringClass() { this = "StringClass" }
}

class FieldClass extends int {
  StringClass field;

  FieldClass() { this = 0 }

  StringClass getField() { result = field }
}

predicate isStringClass(string s) { none() }

predicate test() {
  isStringClass(any(FieldClass f).getField()) // $ getAStringValue=StringClass
}
