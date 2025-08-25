/**
 * @name Low Java analysis quality
 * @description Low Java analysis quality
 * @kind diagnostic
 * @id java/diagnostic/database-quality
 */

import java
import DatabaseQuality

private newtype TDbQualityDiagnostic =
  TTheDbQualityDiagnostic() {
    exists(float percentageGood |
      CallTargetStatsReport::percentageOfOk(_, percentageGood)
      or
      ExprTypeStatsReport::percentageOfOk(_, percentageGood)
    |
      percentageGood < 95
    )
  }

class DbQualityDiagnostic extends TDbQualityDiagnostic {
  string toString() {
    result =
      "Scanning Java code completed successfully, but the scan encountered issues. " +
        "This may be caused by problems identifying dependencies or use of generated source code, among other reasons -- "
        +
        "see other CodeQL diagnostics reported on the CodeQL status page for more details of possible causes. "
        +
        "Addressing these warnings is advisable to avoid false-positive or missing results. If they cannot be addressed, consider scanning Java "
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
