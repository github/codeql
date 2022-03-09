import java
import semmle.code.java.dataflow.SignAnalysis
import semmle.code.java.semantic.analysis.SignAnalysisCommon
import semmle.code.java.semantic.SemanticCFG
import semmle.code.java.semantic.SemanticExpr
import semmle.code.java.semantic.SemanticExprSpecific
import semmle.code.java.semantic.SemanticSSA
import semmle.code.java.semantic.SemanticType
import semmle.code.java.dataflow.SSA
import semmle.code.java.dataflow.internal.rangeanalysis.SsaReadPositionCommon
import SignAnalysisCommonTest

predicate interestingLocation(Location loc) {
  //  loc.getFile().getBaseName() = "ReplyMessage.java" and
  //  loc.getStartLine() in [266 .. 266] and
  any()
}

query predicate diff_exprSign(SemExpr e, string astSign, string semSign) {
  getJavaExpr(e).getEnclosingCallable().fromSource() and
  interestingLocation(e.getLocation()) and
  semSign = concat(semExprSign(e).toString(), "") and
  astSign = concat(exprSign(getJavaExpr(e)).toString(), "") and
  astSign != semSign
}

query predicate diff_ssaDefSign(SemSsaVariable v, string astSign, string semSign) {
  getJavaBasicBlock(v.getBasicBlock()).getEnclosingCallable().fromSource() and
  interestingLocation(v.getBasicBlock().getLocation()) and
  semSign = concat(semSsaDefSign(v).toString(), "") and
  astSign = concat(testSsaDefSign(getJavaSsaVariable(v)).toString(), "") and
  astSign != semSign
}
