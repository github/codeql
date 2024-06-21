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
      "There were significant issues scanning Java code. " +
        "This may be caused by problems identifying dependencies or use of generated source code, among other reasons -- "
        + "see other CodeQL diagnostics reported here for more details of possible causes. " +
        "This may lead to false-positive or missing results. Consider analysing Java using the `autobuild` or `manual` build modes."
  }
}

query predicate diagnosticAttributes(DbQualityDiagnostic e, string key, string value) {
  e = e and // Quieten warning about unconstrained 'e'
  key = ["visibilityCliSummaryTable", "visibilityTelemetry", "visibilityStatusPage"] and
  value = "true"
}

from DbQualityDiagnostic d
select d, d.toString(), 1
/* Warning severity */
