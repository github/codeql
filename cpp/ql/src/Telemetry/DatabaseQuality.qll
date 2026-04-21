import cpp
import codeql.util.ReportStats

/** A file that is included in the quality statistics. */
private class RelevantFile extends File {
  RelevantFile() { this.fromSource() and exists(this.getRelativePath()) }
}

module CallTargetStats implements StatsSig {
  private class RelevantCall extends Call {
    RelevantCall() { this.getFile() instanceof RelevantFile }
  }

  // We assume that calls with an implicit target are calls that could not be
  // resolved. This is accurate in the vast majority of cases, but is inaccurate
  // for calls that deliberately rely on implicitly declared functions.
  private predicate hasImplicitTarget(RelevantCall call) {
    call.getTarget().getADeclarationEntry().isImplicit()
  }

  int getNumberOfOk() { result = count(RelevantCall call | not hasImplicitTarget(call)) }

  int getNumberOfNotOk() { result = count(RelevantCall call | hasImplicitTarget(call)) }

  string getOkText() { result = "calls with call target" }

  string getNotOkText() { result = "calls with missing call target" }
}

private class SourceExpr extends Expr {
  SourceExpr() { this.getFile() instanceof RelevantFile }
}

private predicate hasGoodType(Expr e) { not e.getType() instanceof ErroneousType }

module ExprTypeStats implements StatsSig {
  int getNumberOfOk() { result = count(SourceExpr e | hasGoodType(e)) }

  int getNumberOfNotOk() { result = count(SourceExpr e | not hasGoodType(e)) }

  string getOkText() { result = "expressions with known type" }

  string getNotOkText() { result = "expressions with unknown type" }
}

module CallTargetStatsReport = ReportStats<CallTargetStats>;

module ExprTypeStatsReport = ReportStats<ExprTypeStats>;
