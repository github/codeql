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
