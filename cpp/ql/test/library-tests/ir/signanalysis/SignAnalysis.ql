private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.ir.rangeanalysis.SignAnalysis
private import TestUtilities.InlineExpectationsTest
private import semmle.code.cpp.ir.rangeanalysis.internal.SignAnalysisSpecific::Private as Private
private import semmle.code.cpp.ir.rangeanalysis.internal.SsaReadPositionSpecific as SsaReadSpecific
private import semmle.code.cpp.ir.rangeanalysis.internal.SsaReadPositionCommon as SsaRead
private import semmle.code.cpp.ir.rangeanalysis.internal.SignAnalysisCommon as SignCommon
private import semmle.code.cpp.ir.rangeanalysis.internal.Sign as Sign

class SignTest extends InlineExpectationsTest {
  SignTest() { this = "SignTest" }

  override string getARelevantTag() {
    result in ["positive", "strictlyPositive", "negative", "strictlyNegative"]
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(PositionalArgumentOperand operand |
      operand.getUse().(CallInstruction).getStaticCallTarget().hasName("test") and
      operand.getIndex() = 0 and
      tag = getASignString(operand) and
      element = operand.toString() and
      value = "" and
      location = operand.getLocation()
    )
  }
}

string getASignString(Operand e) {
  positive(e) and
  not strictlyPositive(e) and
  result = "positive"
  or
  negative(e) and
  not strictlyNegative(e) and
  result = "negative"
  or
  strictlyPositive(e) and
  result = "strictlyPositive"
  or
  strictlyNegative(e) and
  result = "strictlyNegative"
}

query predicate debug(string sign) {
  exists(ArgumentOperand arg | arg.getLocation().getStartLine() = 42 | sign = getASignString(arg))
}

query predicate debug_step1(string t0) {
  exists(ArgumentOperand e, string sign |
    e.getLocation().getStartLine() = 15 and
    sign = t0 and
    t0 = getASignString(e)
  )
}

query string getASignString_step(Operand e) {
  exists(ArgumentOperand s0_e, string s0_sign |
    s0_e.getLocation().getStartLine() = 15 and
    s0_sign = result and
    e = s0_e
  ) and
  (
    positive(e) and
    not strictlyPositive(e) and
    result = "positive"
    or
    negative(e) and
    not strictlyNegative(e) and
    result = "negative"
    or
    strictlyPositive(e) and
    result = "strictlyPositive"
    or
    strictlyNegative(e) and
    result = "strictlyNegative"
  )
}

query predicate operands(ArgumentOperand e) { e.getLocation().getStartLine() = 42 }
