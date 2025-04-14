/**
 * Inline range analysis tests for Java.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

import java
import semmle.code.java.dataflow.RangeAnalysis
private import utils.test.InlineExpectationsTest as IET

module RangeTest implements IET::TestSig {
  string getARelevantTag() { result = "bound" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "bound" and
    (
      // simple integer bounds (`ZeroBound`s)
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
      or
      // advanced bounds
      exists(Expr e, int delta, string deltaStr, boolean upper, string cmp, Expr boundExpr |
        annotatedBound(e, _, boundExpr, delta, upper) and
        e instanceof VarRead and
        e.getCompilationUnit().fromSource() and
        (
          if delta = 0
          then deltaStr = ""
          else
            if delta > 0
            then deltaStr = " + " + delta.toString()
            else deltaStr = " - " + delta.abs().toString()
        ) and
        if upper = true then cmp = "<=" else cmp = ">="
      |
        location = e.getLocation() and
        element = e.toString() and
        value = "\"" + e.toString() + " " + cmp + " " + boundExpr.toString() + deltaStr + "\""
      )
    )
  }

  private predicate constrained(Expr e, int lower, int upper) {
    bounded(e, any(ZeroBound z), lower, false, _) and
    bounded(e, any(ZeroBound z), upper, true, _)
  }

  private predicate annotatedBound(Expr e, Bound b, Expr boundExpr, int delta, boolean upper) {
    bounded(e, b, delta, upper, _) and
    // the expression for the bound is explicitly requested as being annotated
    // via a call such as
    // ```java
    //  bound(expr);
    // ```
    boundExpr = b.getExpr() and
    exists(Call c | c.getCallee().getName() = "bound" and c.getArgument(0) = boundExpr) and
    // non-trivial bound
    not e = b.getExpr()
  }
}

import IET::MakeTest<RangeTest>
