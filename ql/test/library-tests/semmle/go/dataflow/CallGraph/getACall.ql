import go

query predicate missingCall(DeclaredFunction f, DataFlow::CallNode call) {
  call.getACallee().asFunction() = f and
  not call = f.getACall()
}

query predicate spuriousCall(DeclaredFunction f, DataFlow::CallNode call) {
  call = f.getACall() and
  not call.getACallee().asFunction() = f
}
