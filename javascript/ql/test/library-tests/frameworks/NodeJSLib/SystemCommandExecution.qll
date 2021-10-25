import javascript

query predicate test_SystemCommandExecution(SystemCommandExecution cmd, DataFlow::Node res) {
  res = cmd.getACommandArgument()
}
