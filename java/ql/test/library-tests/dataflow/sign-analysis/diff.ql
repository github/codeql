import java
import semmle.code.java.dataflow.SignAnalysis
import semmle.code.java.semantic.analysis.SignAnalysisCommon
import semmle.code.java.semantic.SemanticExpr

string getSemanticSign(Expr e) {
  result = concat(string s | s = semExprSign(getSemanticExpr(e)).toString() | s, "")
}

string getASTSign(Expr e) { result = concat(string s | s = exprSign(e).toString() | s, "") }

from Expr e, string semSign, string astSign
where
  e.getEnclosingCallable().fromSource() and
  semSign = getSemanticSign(e) and
  astSign = getASTSign(e) and
  semSign != astSign
select e, "AST sign was '" + astSign + "', but semantic sign was '" + semSign + "'."
