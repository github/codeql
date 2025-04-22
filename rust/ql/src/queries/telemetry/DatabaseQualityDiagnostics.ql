/**
 * @name Low Rust analysis quality
 * @description Low Rust analysis quality
 * @kind diagnostic
 * @id rust/diagnostic/database-quality
 */

import rust
import DatabaseQuality
import codeql.util.Unit

class DbQualityDiagnostic extends Unit {
  DbQualityDiagnostic() {
    exists(float percentageGood |
      CallTargetStatsReport::percentageOfOk(_, percentageGood)
      or
      MacroCallTargetStatsReport::percentageOfOk(_, percentageGood)
    |
      percentageGood < 95
    )
  }

  string toString() {
    result =
      "Scanning Rust code completed successfully, but the scan encountered issues. " +
        "This may be caused by problems identifying dependencies or use of generated source code, among other reasons -- "
        +
        "see other CodeQL diagnostics reported on the CodeQL status page for more details of possible causes. "
        + "Addressing these warnings is advisable to avoid false-positive or missing results."
  }
}

query predicate diagnosticAttributes(DbQualityDiagnostic e, string key, string value) {
  exists(e) and // Quieten warning about unconstrained 'e'
  key = ["visibilityCliSummaryTable", "visibilityTelemetry", "visibilityStatusPage"] and
  value = "true"
}

from DbQualityDiagnostic d
select d, d.toString(), 1
/* 1 = Warning severity */
