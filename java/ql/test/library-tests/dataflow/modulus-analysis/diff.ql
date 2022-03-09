import java
import semmle.code.java.semantic.analysis.ModulusAnalysis
import semmle.code.java.semantic.SemanticBound
import semmle.code.java.semantic.SemanticExpr
import semmle.code.java.semantic.SemanticExprSpecific
import semmle.code.java.semantic.SemanticSSA
import semmle.code.java.dataflow.ModulusAnalysis
import semmle.code.java.dataflow.Bound
import semmle.code.java.dataflow.SSA
import semmle.code.java.dataflow.internal.rangeanalysis.SsaReadPositionCommon
import semmle.code.java.dataflow.RangeUtils as RU

predicate interestingLocation(Location loc) {
  //  loc.getFile().getBaseName() = "Utf8Test.java" and
  //  loc.getStartLine() in [164 .. 164] and
  any()
}

query predicate diff_exprModulus(Expr e, string c, Bound b, int delta, int mod, string message) {
  interestingLocation(e.getLocation()) and
  c = concat(e.getAQlClass(), ", ") and
  (
    semExprModulus(getSemanticExpr(e), getSemanticBound(b), delta, mod) and
    not exprModulus(e, b, delta, mod) and
    message = "semantic only"
    or
    not semExprModulus(getSemanticExpr(e), getSemanticBound(b), delta, mod) and
    exprModulus(e, getJavaBound(b), delta, mod) and
    message = "AST only"
  )
}
