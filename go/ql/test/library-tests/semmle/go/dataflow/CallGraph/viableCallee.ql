import go
import semmle.go.dataflow.internal.DataFlowDispatch

/**
 * Gets a string `val` such that there is a comment on the same line as `l`
 * that contains the substring `key: val`.
 */
string metadata(Locatable l, string key) {
  exists(string f, int line, Comment c, string kv |
    l.hasLocationInfo(f, line, _, _, _) and
    c.hasLocationInfo(f, line, _, _, _) and
    kv = c.getText().regexpFind("\\b(\\w+: \\S+)", _, _) and
    key = kv.regexpCapture("(\\w+): (\\S+)", 1) and
    result = kv.regexpCapture("(\\w+): (\\S+)", 2)
  )
}

query predicate missingCallee(DataFlow::CallNode call, FuncDef callee) {
  metadata(call.asExpr(), "callee") = metadata(callee, "name") and
  not viableCallable(call.asExpr()).getFuncDef() = callee
}

query predicate spuriousCallee(DataFlow::CallNode call, FuncDef callee) {
  viableCallable(call.asExpr()).getFuncDef() = callee and
  not metadata(call.asExpr(), "callee") = metadata(callee, "name")
}
