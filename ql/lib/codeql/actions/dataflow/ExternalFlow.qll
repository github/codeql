private import internal.ExternalFlowExtensions as Extensions
import codeql.actions.DataFlow
import actions

/** Holds if a source model exists for the given parameters. */
predicate sourceModel(string action, string version, string output, string kind) {
  Extensions::sourceModel(action, version, output, kind)
}

/** Holds if a sink model exists for the given parameters. */
predicate summaryModel(string action, string version, string input, string output, string kind) {
  Extensions::summaryModel(action, version, input, output, kind)
}

/** Holds if a sink model exists for the given parameters. */
predicate sinkModel(string action, string version, string input, string kind) {
  Extensions::sinkModel(action, version, input, kind)
}

predicate sinkNode(DataFlow::ExprNode sink, string kind) {
  exists(UsesExpr uses, string action, string version, string input |
    uses.getArgumentExpr(input.splitAt(",").trim()) = sink.asExpr() and
    sinkModel(action, version, input, kind) and
    uses.getCallee() = action and
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.splitAt(",").trim()
    )
  )
}
