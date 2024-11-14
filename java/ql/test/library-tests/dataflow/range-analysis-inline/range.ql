/**
 * Inline range analysis tests for Java.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

import java
import semmle.code.java.dataflow.RangeAnalysis
private import codeql.util.test.InlineExpectationsTest
private import TestUtilities.internal.InlineExpectationsTestImpl
private import Make<Impl> as IET

module RangeTest implements IET::TestSig {
  string getARelevantTag() { result = "bound" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "bound" and
    exists(Expr e, int lower, int upper |
      constrained(e, lower, upper) and
      e instanceof VarRead and
      e.getCompilationUnit().fromSource()
    |
      location = e.getLocation() and
      element = e.toString() and
      if lower = upper
      then value = "\"" + e.toString() + " = " + lower.toString() + "\""
      else
        value = "\"" + e.toString() + " in [" + lower.toString() + ".." + upper.toString() + "]\""
    )
  }

  private predicate constrained(Expr e, int lower, int upper) {
    lower = min(int delta | bounded(e, any(ZeroBound z), delta, false, _)) and
    upper = min(int delta | bounded(e, any(ZeroBound z), delta, true, _))
  }
}

import IET::MakeTest<RangeTest>
