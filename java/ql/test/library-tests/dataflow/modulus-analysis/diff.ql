import java
import semmle.code.java.semantic.analysis.ModulusAnalysis
import semmle.code.java.semantic.SemanticBound
import semmle.code.java.semantic.SemanticExpr
import semmle.code.java.dataflow.ModulusAnalysis
import semmle.code.java.dataflow.Bound

from Expr e, Bound b, int delta, int mod, string message
where
  semExprModulus(getSemanticExpr(e), getSemanticBound(b), delta, mod) and
  not exprModulus(e, b, delta, mod) and
  message = "semantic only"
  or
  not semExprModulus(getSemanticExpr(e), getSemanticBound(b), delta, mod) and
  exprModulus(e, b, delta, mod) and
  message = "AST only"
select e, b.toString(), delta, mod
