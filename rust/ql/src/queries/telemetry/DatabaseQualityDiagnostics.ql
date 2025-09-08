/**
 * @name Low Rust analysis quality
 * @description Low Rust analysis quality
 * @kind diagnostic
 * @id rust/diagnostic/database-quality
 */

import rust
import DatabaseQuality
import codeql.util.Unit

private predicate diagnostic(string msg, float value, float threshold) {
  CallTargetStatsReport::percentageOfOk(msg, value) and threshold = 50
  or
  MacroCallTargetStatsReport::percentageOfOk(msg, value) and threshold = 50
}

private string getDbHealth() {
  result =
    strictconcat(string msg, float value, float threshold |
      diagnostic(msg, value, threshold)
    |
      msg + ": " + value.floor() + " % (threshold " + threshold.floor() + " %)", ". "
    )
}

class DbQualityDiagnostic extends Unit {
  DbQualityDiagnostic() {
    exists(float percentageGood, float threshold |
      diagnostic(_, percentageGood, threshold) and
      percentageGood < threshold
    )
  }

  string toString() {
    result =
      "Scanning Rust code completed successfully, but the scan encountered issues. " +
        "This may be caused by problems identifying dependencies or use of generated source code. " +
        "Some metrics of the database quality are: " + getDbHealth() + ". " +
        "Ideally these metrics should be above their thresholds. " +
        "Addressing these issues is advisable to avoid false-positives or missing results."
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
