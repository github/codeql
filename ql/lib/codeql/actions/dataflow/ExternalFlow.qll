private import internal.ExternalFlowExtensions as Extensions
import codeql.actions.DataFlow
import actions

/**
 * MaD sources
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - output arg: To node (prefixed with either `env.` or `output.`)
 *    - trigger: Triggering event under which this model introduces tainted data. Use `*` for any event.
 */
predicate sourceModel(string action, string version, string output, string trigger, string kind) {
  Extensions::sourceModel(action, version, output, trigger, kind)
}

/**
 * MaD summaries
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - input arg: From node (prefixed with either `env.` or `input.`)
 *    - output arg: To node (prefixed with either `env.` or `output.`)
 *    - kind: Either 'Taint' or 'Value'
 */
predicate summaryModel(string action, string version, string input, string output, string kind) {
  Extensions::summaryModel(action, version, input, output, kind)
}

/**
 * MaD sinks
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - input: sink node (prefixed with either `env.` or `input.`)
 *    - kind: sink kind
 */
predicate sinkModel(string action, string version, string input, string kind) {
  Extensions::sinkModel(action, version, input, kind)
}

predicate externallyDefinedSource(DataFlow::Node source, string sourceType, string fieldName) {
  exists(UsesExpr uses, string action, string version, string trigger, string kind |
    sourceModel(action, version, fieldName, trigger, kind) and
    uses.getCallee() = action.toLowerCase() and
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    ) and
    (
      if fieldName.trim().matches("env.%")
      then source.asExpr() = uses.getEnvExpr(fieldName.trim().replaceAll("env\\.", ""))
      else
        if fieldName.trim().matches("output.%")
        then
          // 'output.' is the default qualifier
          source.asExpr() = uses
        else none()
    ) and
    sourceType = kind
  )
}

predicate externallyDefinedSummary(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(UsesExpr uses, string action, string version, string input, string output |
    c = any(DataFlow::FieldContent ct | ct.getName() = output.replaceAll("output\\.", "")) and
    summaryModel(action, version, input, output, "taint") and
    uses.getCallee() = action.toLowerCase() and
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    ) and
    (
      if input.trim().matches("env.%")
      then pred.asExpr() = uses.getEnvExpr(input.trim().replaceAll("env\\.", ""))
      else
        // 'input.' is the default qualifier
        pred.asExpr() = uses.getArgumentExpr(input.trim().replaceAll("input\\.", ""))
    ) and
    succ.asExpr() = uses
  )
}

predicate externallyDefinedSink(DataFlow::ExprNode sink, string kind) {
  exists(UsesExpr uses, string action, string version, string input |
    (
      if input.trim().matches("env.%")
      then sink.asExpr() = uses.getEnvExpr(input.trim().replaceAll("input\\.", ""))
      else sink.asExpr() = uses.getArgumentExpr(input.trim())
    ) and
    sinkModel(action, version, input, kind) and
    uses.getCallee() = action.toLowerCase() and
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    )
  )
}
