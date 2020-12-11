import javascript

query Angular2::PipeRefExpr pipeRef() { any() }

query CallExpr pipeCall() {
  result.getCallee() instanceof Angular2::PipeRefExpr
}

query CallExpr pipeCallArg(int i, Expr arg) {
  result.getCallee() instanceof Angular2::PipeRefExpr and
  result.getArgument(i) = arg
}
