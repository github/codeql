import javascript

query predicate test_SystemCommandExecution(CommandExecution cmd, DataFlow::Node res) {
  res = cmd.getACommandArgument()
}
