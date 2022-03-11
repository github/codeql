import javascript

query predicate test_SystemCommandExecution_getAnArgumentForCommand(
  CommandExecution cmd, DataFlow::Node res
) {
  res = cmd.getArgumentList()
}
