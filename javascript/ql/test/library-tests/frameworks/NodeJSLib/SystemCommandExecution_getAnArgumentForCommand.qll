import javascript

query predicate test_SystemCommandExecution_getAnArgumentForCommand(
  SystemCommandExecution cmd, DataFlow::Node res
) {
  res = cmd.getArgumentList()
}
