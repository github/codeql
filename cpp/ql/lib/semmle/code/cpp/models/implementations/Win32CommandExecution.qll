private import semmle.code.cpp.models.interfaces.CommandExecution

/** The `ShellExecute` family of functions from Win32. */
class ShellExecute extends Function {
  ShellExecute() { this.hasGlobalName("ShellExecute" + ["", "A", "W"]) }
}

private class ShellExecuteModel extends ShellExecute, CommandExecutionFunction {
  override predicate hasCommandArgument(FunctionInput input) { input.isParameterDeref(2) }
}

/** The `WinExec` function from Win32. */
class WinExec extends Function {
  WinExec() { this.hasGlobalName("WinExec") }
}

private class WinExecModel extends WinExec, CommandExecutionFunction {
  override predicate hasCommandArgument(FunctionInput input) { input.isParameterDeref(0) }
}

/** The `CreateProcess` family of functions from Win32. */
class CreateProcess extends Function {
  CreateProcess() { this.hasGlobalName("CreateProcess" + ["", "A", "W"]) }
}

private class CreateProcessModel extends CreateProcess, CommandExecutionFunction {
  override predicate hasCommandArgument(FunctionInput input) { input.isParameterDeref(0) }
}

/** The `CreateProcessAsUser` family of functions from Win32. */
class CreateProcessAsUser extends Function {
  CreateProcessAsUser() { this.hasGlobalName("CreateProcessAsUser" + ["", "A", "W"]) }
}

private class CreateProcessAsUserModel extends CreateProcessAsUser, CommandExecutionFunction {
  override predicate hasCommandArgument(FunctionInput input) { input.isParameterDeref(1) }
}

/** The `CreateProcessWithLogonW` function from Win32. */
class CreateProcessWithLogonW extends Function {
  CreateProcessWithLogonW() { this.hasGlobalName("CreateProcessWithLogonW") }
}

private class CreateProcessWithLogonModel extends CreateProcessWithLogonW, CommandExecutionFunction {
  override predicate hasCommandArgument(FunctionInput input) { input.isParameterDeref(4) }
}

/** The `CreateProcessWithTokenW` function from Win32. */
class CreateProcessWithTokenW extends Function {
  CreateProcessWithTokenW() { this.hasGlobalName("CreateProcessWithTokenW") }
}

private class CreateProcessWithTokenWModel extends CreateProcessWithTokenW, CommandExecutionFunction
{
  override predicate hasCommandArgument(FunctionInput input) { input.isParameterDeref(2) }
}
