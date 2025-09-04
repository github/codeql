/**
 * @name Low C# analysis quality
 * @description Low C# analysis quality
 * @kind diagnostic
 * @id csharp/diagnostic/database-quality
 */

import csharp
import DatabaseQuality

private int getThreshold() { result = 85 }

private newtype TDbQualityDiagnostic =
  TTheDbQualityDiagnostic(string callMsg, float callTargetOk, string exprMsg, float exprTypeOk) {
    CallTargetStatsReport::percentageOfOk(callMsg, callTargetOk) and
    ExprTypeStatsReport::percentageOfOk(exprMsg, exprTypeOk) and
    [callTargetOk, exprTypeOk] < getThreshold()
  }

class DbQualityDiagnostic extends TDbQualityDiagnostic {
  private string callMsg;
  private float callTargetOk;
  private float exprTypeOk;
  private string exprMsg;

  DbQualityDiagnostic() {
    this = TTheDbQualityDiagnostic(callMsg, callTargetOk, exprMsg, exprTypeOk)
  }

  private string getDbHealth() {
    result =
      callMsg + ": " + callTargetOk.floor() + ". " + exprMsg + ": " + exprTypeOk.floor() + ". "
  }

  string toString() {
    result =
      "Scanning C# code completed successfully, but the scan encountered issues. " +
        "This may be caused by problems identifying dependencies or use of generated source code. " +
        "Some metrics of the database quality are: " + this.getDbHealth() +
        "Both of these metrics should ideally be above " + getThreshold() + ". " +
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
