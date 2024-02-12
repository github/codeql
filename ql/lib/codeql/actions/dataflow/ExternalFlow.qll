private import internal.ExternalFlowExtensions as Extensions
import codeql.actions.DataFlow
import actions

/** Holds if a source model exists for the given parameters. */
predicate sourceModel(string action, string version, string output, string trigger, string kind) {
  Extensions::sourceModel(action, version, output, trigger, kind)
}

/** Holds if a sink model exists for the given parameters. */
predicate summaryModel(string action, string version, string input, string output, string kind) {
  Extensions::summaryModel(action, version, input, output, kind)
}

/** Holds if a sink model exists for the given parameters. */
predicate sinkModel(string action, string version, string input, string kind) {
  Extensions::sinkModel(action, version, input, kind)
}

/**
 * MaD sinks
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - input arg: sink node (prefixed with either `env.` or `input.`)
 *    - kind: sink kind
 */
predicate sinkNode(DataFlow::ExprNode sink, string kind) {
  exists(UsesExpr uses, string action, string version, string input |
    (
      if input.trim().matches("env.%")
      then sink.asExpr() = uses.getEnvExpr(input.trim().replaceAll("input\\.", ""))
      else sink.asExpr() = uses.getArgumentExpr(input.trim())
    ) and
    sinkModel(action, version, input, kind) and
    uses.getCallee() = action and
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    )
  )
}
