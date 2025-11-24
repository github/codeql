/**
 * Provides database quality statistics that are reported by
 * `rust/telemetry/extractor-information`
 * and perhaps warned about by `rust/diagnostics/database-quality`.
 */

import rust
import codeql.util.ReportStats
import codeql.rust.internal.TypeInference as TypeInference

/**
 * A file that is included in the quality statistics.
 */
private class RelevantFile extends File {
  RelevantFile() {
    // files that are not skipped by the compilation
    not this.(ExtractedFile).isSkippedByCompilation()
  }
}

module CallTargetStats implements StatsSig {
  int getNumberOfOk() {
    result =
      count(ArgsExpr ae | ae.getFile() instanceof RelevantFile and exists(ae.getResolvedTarget()))
  }

  additional predicate isNotOkCall(ArgsExpr ae) {
    ae.getFile() instanceof RelevantFile and
    not exists(ae.getResolvedTarget()) and
    not ae instanceof ClosureCallExpr and
    not ae = any(Operation o | not o.isOverloaded(_, _, _))
  }

  int getNumberOfNotOk() { result = count(ArgsExpr ae | isNotOkCall(ae)) }

  string getOkText() { result = "calls with call target" }

  string getNotOkText() { result = "calls with missing call target" }
}

module MacroCallTargetStats implements StatsSig {
  int getNumberOfOk() {
    result = count(MacroCall c | c.getFile() instanceof RelevantFile and c.hasMacroCallExpansion())
  }

  additional predicate isNotOkCall(MacroCall c) {
    c.getFile() instanceof RelevantFile and not c.hasMacroCallExpansion()
  }

  int getNumberOfNotOk() { result = count(MacroCall c | isNotOkCall(c)) }

  string getOkText() { result = "macro calls with call target" }

  string getNotOkText() { result = "macro calls with missing call target" }
}

private predicate hasGoodType(Expr e) { exists(TypeInference::inferType(e, _)) }

module ExprTypeStats implements StatsSig {
  int getNumberOfOk() {
    result =
      count(Expr e |
        e.getFile() instanceof RelevantFile and
        e.fromSource() and
        hasGoodType(e)
      )
  }

  int getNumberOfNotOk() {
    result =
      count(Expr e |
        e.getFile() instanceof RelevantFile and
        e.fromSource() and
        not hasGoodType(e)
      )
  }

  string getOkText() { result = "expressions with known type" }

  string getNotOkText() { result = "expressions with unknown type" }
}

module CallTargetStatsReport = ReportStats<CallTargetStats>;

module MacroCallTargetStatsReport = ReportStats<MacroCallTargetStats>;

module ExprTypeStatsReport = ReportStats<ExprTypeStats>;
