import javascript

query predicate test_SystemCommandExecution(SystemCommandExecution cmd, DataFlow::Node res) {
  res = cmd.getACommandArgument()
}

query predicate test_SystemCommandExecution_getOptionsArg(
  SystemCommandExecution cmd, DataFlow::Node res
) {
  res = cmd.getOptionsArg()
}
