/**
 * @name Low C# analysis quality
 * @description Low C# analysis quality
 * @kind diagnostic
 * @id csharp/diagnostic/database-quality
 */

import csharp
import DatabaseQuality

private predicate diagnostic(string msg, float value, float threshold) {
  CallTargetStatsReport::percentageOfOk(msg, value) and
  threshold = 85
  or
  ExprTypeStatsReport::percentageOfOk(msg, value) and
  threshold = 85
}

private newtype TDbQualityDiagnostic =
  TTheDbQualityDiagnostic() {
    exists(float percentageGood, float threshold |
      diagnostic(_, percentageGood, threshold) and
      percentageGood < threshold
    )
  }

private string getDbHealth() {
  result =
    strictconcat(string msg, float value, float threshold |
      diagnostic(msg, value, threshold)
    |
      msg + ": " + value.floor() + " % (threshold " + threshold.floor() + " %)", ". "
    )
}

class DbQualityDiagnostic extends TDbQualityDiagnostic {
  string toString() {
    result =
      "Scanning C# code completed successfully, but the scan encountered issues. " +
        "This may be caused by problems identifying dependencies or use of generated source code. " +
        "Some metrics of the database quality are: " + getDbHealth() + ". " +
        "Ideally these metrics should be above their thresholds. " +
        "Addressing these issues is advisable to avoid false-positives or missing results. If they cannot be addressed, consider scanning C# "
        +
        "using either the `autobuild` or `manual` [build modes](https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/codeql-code-scanning-for-compiled-languages#comparison-of-the-build-modes)."
  }
}

query predicate diagnosticAttributes(DbQualityDiagnostic e, string key, string value) {
  exists(e) and // Quieten warning about unconstrained 'e'
  key = ["visibilityCliSummaryTable", "visibilityTelemetry", "visibilityStatusPage"] and
  value = "true"
}

from DbQualityDiagnostic d
select d, d.toString(), 1
/* Warning severity */
