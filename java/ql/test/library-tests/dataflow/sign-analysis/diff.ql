import java
import semmle.code.java.dataflow.SignAnalysis
import semmle.code.java.semantic.analysis.SignAnalysisCommon
import semmle.code.java.semantic.SemanticExpr

string getSemSignString(Expr e) {
  result =
    concat(string sign |
      exists(SemExpr semExpr | semExpr = getSemanticExpr(e) |
        semPositive(semExpr) and
        not semStrictlyPositive(semExpr) and
        sign = "positive"
        or
        semNegative(semExpr) and
        not semStrictlyNegative(semExpr) and
        sign = "negative"
        or
        semStrictlyPositive(semExpr) and
        sign = "strictlyPositive"
        or
        semStrictlyNegative(semExpr) and
        sign = "strictlyNegative"
      )
    |
      sign, " "
    )
}

string getASTSignString(Expr e) {
  result =
    concat(string sign |
      positive(e) and
      not strictlyPositive(e) and
      sign = "positive"
      or
      negative(e) and
      not strictlyNegative(e) and
      sign = "negative"
      or
      strictlyPositive(e) and
      sign = "strictlyPositive"
      or
      strictlyNegative(e) and
      sign = "strictlyNegative"
    |
      sign, " "
    )
}

from Expr e, string semSign, string astSign
where
  e.getEnclosingCallable().fromSource() and
  semSign = getSemSignString(e) and
  astSign = getASTSignString(e) and
  semSign != astSign
select e, astSign, semSign
