import go

query predicate missingCall(DeclaredFunction f, DataFlow::CallNode call) {
  call.getACallee() = f.getFuncDecl() and
  not call = f.getACall()
}

query predicate spuriousCall(DeclaredFunction f, DataFlow::CallNode call) {
  call = f.getACall() and
  exists(FuncDecl fd | fd = f.getFuncDecl() | not call.getACallee() = fd)
}
