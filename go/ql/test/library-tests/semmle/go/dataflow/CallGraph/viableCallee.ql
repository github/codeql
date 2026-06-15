import go
import semmle.go.dataflow.internal.DataFlowDispatch

/**
 * Gets a string `val` such that there is a comment on the same line as `l`
 * that contains the substring `key: val`.
 */
string metadata(Locatable l, string key) {
  exists(Comment c, string kv |
    l.getFile() = c.getFile() and
    l.getLocation().getStartLine() = c.getLocation().getStartLine() and
    kv = c.getText().regexpFind("\\b(\\w+: \\S+)", _, _) and
    key = kv.regexpCapture("(\\w+): (\\S+)", 1) and
    result = kv.regexpCapture("(\\w+): (\\S+)", 2)
  )
}

query predicate missingCallee(DataFlow::CallNode call, FuncDef callee) {
  metadata(call.asExpr(), "callee") = metadata(callee, "name") and
  not viableCallable(call.asExpr()).asCallable().getFuncDef() = callee
}

query predicate spuriousCallee(DataFlow::CallNode call, FuncDef callee) {
  viableCallable(call.asExpr()).asCallable().getFuncDef() = callee and
  not metadata(call.asExpr(), "callee") = metadata(callee, "name")
}
