import cpp
import semmle.code.cpp.security.InvalidPointerDereference.InvalidPointerToDereference
import utils.test.InlineExpectationsTest
import semmle.code.cpp.ir.IR
import semmle.code.cpp.dataflow.new.DataFlow

string case3(DataFlow::Node derefSource, DataFlow::Node derefSink, DataFlow::Node operation) {
  operationIsOffBy(_, _, derefSource, derefSink, _, operation, _) and
  not exists(case2(_, _, operation)) and
  not exists(case1(_, _, operation)) and
  exists(int derefSourceLine, int derefSinkLine, int operationLine |
    derefSourceLine = derefSource.getLocation().getStartLine() and
    derefSinkLine = derefSink.getLocation().getStartLine() and
    operationLine = operation.getLocation().getStartLine() and
    derefSourceLine != derefSinkLine and
    derefSinkLine != operationLine and
    result = "L" + derefSourceLine + "->L" + derefSinkLine + "->L" + operationLine
  )
}

string case2(DataFlow::Node derefSource, DataFlow::Node derefSink, DataFlow::Node operation) {
  operationIsOffBy(_, _, derefSource, derefSink, _, operation, _) and
  not exists(case1(_, _, operation)) and
  exists(int derefSourceLine, int derefSinkLine, int operationLine |
    derefSourceLine = derefSource.getLocation().getStartLine() and
    derefSinkLine = derefSink.getLocation().getStartLine() and
    operationLine = operation.getLocation().getStartLine() and
    derefSourceLine = derefSinkLine and
    derefSinkLine != operationLine and
    result = "L" + derefSourceLine + "->L" + operationLine
  )
}

string case1(DataFlow::Node derefSource, DataFlow::Node derefSink, DataFlow::Node operation) {
  operationIsOffBy(_, _, derefSource, derefSink, _, operation, _) and
  exists(int derefSourceLine, int derefSinkLine, int operationLine |
    derefSourceLine = derefSource.getLocation().getStartLine() and
    derefSinkLine = derefSink.getLocation().getStartLine() and
    operationLine = operation.getLocation().getStartLine() and
    derefSourceLine = derefSinkLine and
    derefSinkLine = operationLine and
    result = "L" + derefSourceLine
  )
}

module InvalidPointerToDereferenceTest implements TestSig {
  string getARelevantTag() { result = "deref" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(
      DataFlow::Node derefSource, DataFlow::Node derefSink, DataFlow::Node operation, int delta,
      string value1, string value2
    |
      operationIsOffBy(_, _, derefSource, derefSink, _, operation, delta) and
      location = operation.getLocation() and
      element = operation.toString() and
      tag = "deref" and
      value = value1 + value2
    |
      (
        value1 = case3(derefSource, derefSink, operation)
        or
        value1 = case2(derefSource, derefSink, operation)
        or
        value1 = case1(derefSource, derefSink, operation)
      ) and
      (
        delta > 0 and
        value2 = "+" + delta
        or
        delta = 0 and
        value2 = ""
        or
        delta < 0 and
        value2 = "-" + (-delta)
      )
    )
  }
}

import MakeTest<InvalidPointerToDereferenceTest>
