private import actions
private import internal.ExternalFlowExtensions as Extensions
private import codeql.actions.DataFlow
private import codeql.actions.security.ArtifactPoisoningQuery

/**
 * MaD sources
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - output arg: To node (prefixed with either `env.` or `output.`)
 *    - provenance: verification of the model
 */
predicate actionsSourceModel(
  string action, string version, string output, string kind, string provenance
) {
  Extensions::actionsSourceModel(action, version, output, kind, provenance)
}

/**
 * MaD summaries
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - input arg: From node (prefixed with either `env.` or `input.`)
 *    - output arg: To node (prefixed with either `env.` or `output.`)
 *    - kind: Either 'Taint' or 'Value'
 *    - provenance: verification of the model
 */
predicate actionsSummaryModel(
  string action, string version, string input, string output, string kind, string provenance
) {
  Extensions::actionsSummaryModel(action, version, input, output, kind, provenance)
}

/**
 * MaD sinks
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - input: sink node (prefixed with either `env.` or `input.`)
 *    - kind: sink kind
 *    - provenance: verification of the model
 */
predicate actionsSinkModel(
  string action, string version, string input, string kind, string provenance
) {
  Extensions::actionsSinkModel(action, version, input, kind, provenance)
}

/**
 * Holds if source.fieldName is a MaD-defined source of a given taint kind.
 */
predicate madSource(DataFlow::Node source, string kind, string fieldName) {
  exists(Uses uses, string action, string version |
    actionsSourceModel(action, version, fieldName, kind, _) and
    uses.getCallee() = action.toLowerCase() and
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    ) and
    (
      if fieldName.trim().matches("env.%")
      then source.asExpr() = uses.getInScopeEnvVarExpr(fieldName.trim().replaceAll("env.", ""))
      else
        if fieldName.trim().matches("output.%")
        then source.asExpr() = uses
        else none()
    )
  )
}

/**
 * Holds if the data flow from `pred` to `succ` is a MaD store step.
 */
predicate madStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Uses uses, string action, string version, string input, string output |
    actionsSummaryModel(action, version, input, output, "taint", _) and
    c = any(DataFlow::FieldContent ct | ct.getName() = output.replaceAll("output.", "")) and
    uses.getCallee() = action.toLowerCase() and
    // version check
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    ) and
    // pred provenance
    (
      input.trim().matches("env.%") and
      pred.asExpr() = uses.getInScopeEnvVarExpr(input.trim().replaceAll("env.", ""))
      or
      input.trim().matches("input.%") and
      pred.asExpr() = uses.getArgumentExpr(input.trim().replaceAll("input.", ""))
      or
      input.trim() = "artifact" and
      exists(UntrustedArtifactDownloadStep download |
        pred.asExpr() = download and
        download.getAFollowingStep() = uses
      )
    ) and
    succ.asExpr() = uses
  )
}

/**
 * Holds if sink is a MaD-defined sink for a given taint kind.
 */
predicate madSink(DataFlow::Node sink, string kind) {
  exists(Uses uses, string action, string version, string input |
    actionsSinkModel(action, version, input, kind, _) and
    uses.getCallee() = action.toLowerCase() and
    // version check
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    ) and
    // pred provenance
    (
      input.trim().matches("env.%") and
      sink.asExpr() = uses.getInScopeEnvVarExpr(input.trim().replaceAll("env.", ""))
      or
      input.trim().matches("input.%") and
      sink.asExpr() = uses.getArgumentExpr(input.trim().replaceAll("input.", ""))
      or
      input.trim() = "artifact" and
      sink.asExpr() = uses
    )
  )
}
