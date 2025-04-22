/**
 * Provides database quality statistics that are reported by
 * `rust/telemetry/extractor-information`
 * and perhaps warned about by `rust/diagnostics/database-quality`.
 */

import rust
import codeql.util.ReportStats

module CallTargetStats implements StatsSig {
  int getNumberOfOk() { result = count(CallExprBase c | exists(c.getStaticTarget())) }

  private predicate isLambdaCall(CallExpr call) {
    exists(Expr receiver | receiver = call.getFunction() |
      // All calls to complex expressions and local variable accesses are lambda calls
      receiver instanceof PathExpr implies receiver = any(Variable v).getAnAccess()
    )
  }

  additional predicate isNotOkCall(CallExprBase c) {
    not exists(c.getStaticTarget()) and
    not isLambdaCall(c)
  }

  int getNumberOfNotOk() { result = count(CallExprBase c | isNotOkCall(c)) }

  string getOkText() { result = "calls with call target" }

  string getNotOkText() { result = "calls with missing call target" }
}

module MacroCallTargetStats implements StatsSig {
  int getNumberOfOk() { result = count(MacroCall c | c.hasExpanded()) }

  additional predicate isNotOkCall(MacroCall c) { not c.hasExpanded() }

  int getNumberOfNotOk() { result = count(MacroCall c | isNotOkCall(c)) }

  string getOkText() { result = "macro calls with call target" }

  string getNotOkText() { result = "macro calls with missing call target" }
}

module CallTargetStatsReport = ReportStats<CallTargetStats>;

module MacroCallTargetStatsReport = ReportStats<MacroCallTargetStats>;
