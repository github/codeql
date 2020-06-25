/** Provides definitions related to execution of commands */

import cpp
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * A function for running a command using a command interpreter.
 */
class SystemFunction extends FunctionWithWrappers, ArrayFunction, AliasFunction, SideEffectFunction {
  SystemFunction() {
    hasGlobalOrStdName("system") or // system(command)
    hasGlobalName("popen") or // popen(command, mode)
    // Windows variants
    hasGlobalName("_popen") or // _popen(command, mode)
    hasGlobalName("_wpopen") or // _wpopen(command, mode)
    hasGlobalName("_wsystem") // _wsystem(command)
  }

  override predicate interestingArg(int arg) { arg = 0 }

  override predicate hasArrayWithNullTerminator(int bufParam) { bufParam = 0 or bufParam = 1 }

  override predicate hasArrayInput(int bufParam) { bufParam = 0 or bufParam = 1 }

  override predicate parameterNeverEscapes(int index) { index = 0 or index = 1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate parameterIsAlwaysReturned(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() {
    hasGlobalOrStdName("system") or
    hasGlobalName("_wsystem")
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    (i = 0 or i = 1) and
    buffer = true
  }
}

/**
 * A function for running a command via varargs. Note that, at the time
 * of writing, FunctionWithWrappers doesn't really support varargs
 * arguments, because it requires a finite version of interestingArg().
 */
class VarargsExecFunctionCall extends FunctionCall {
  VarargsExecFunctionCall() {
    getTarget().hasGlobalName("execl") or
    getTarget().hasGlobalName("execle") or
    getTarget().hasGlobalName("execlp") or
    // Windows
    getTarget().hasGlobalName("_execl") or
    getTarget().hasGlobalName("_execle") or
    getTarget().hasGlobalName("_execlp") or
    getTarget().hasGlobalName("_execlpe") or
    getTarget().hasGlobalName("_spawnl") or
    getTarget().hasGlobalName("_spawnle") or
    getTarget().hasGlobalName("_spawnlp") or
    getTarget().hasGlobalName("_spawnlpe") or
    getTarget().hasGlobalName("_wexecl") or
    getTarget().hasGlobalName("_wexecle") or
    getTarget().hasGlobalName("_wexeclp") or
    getTarget().hasGlobalName("_wexeclpe") or
    getTarget().hasGlobalName("_wspawnl") or
    getTarget().hasGlobalName("_wspawnle") or
    getTarget().hasGlobalName("_wspawnlp") or
    getTarget().hasGlobalName("_wspawnlpe")
  }

  /** Whether the last argument to the function is an environment pointer */
  predicate hasEnvironmentArgument() {
    getTarget().hasGlobalName("execle") or
    getTarget().hasGlobalName("_execle") or
    getTarget().hasGlobalName("_execlpe") or
    getTarget().hasGlobalName("_wexecle") or
    getTarget().hasGlobalName("_wexeclpe")
  }

  /**
   * The arguments passed to the command. The 0th such argument is conventionally
   *  the name of the command.
   */
  Expr getCommandArgument(int idx) {
    exists(int underlyingIdx |
      result = getArgument(underlyingIdx) and
      underlyingIdx > getCommandIdx() and
      (
        underlyingIdx < getNumberOfArguments() - 1 or
        not hasEnvironmentArgument()
      ) and
      idx = underlyingIdx - getCommandIdx() - 1
    )
  }

  /** The expression denoting the program to execute */
  Expr getCommand() { result = getArgument(getCommandIdx()) }

  /**
   * The index of the command. The spawn variants start with a mode, whereas
   * all the other ones start with the command.
   */
  private int getCommandIdx() {
    if
      getTarget().getName().matches("\\_spawn%") or
      getTarget().getName().matches("\\_wspawn%")
    then result = 1
    else result = 0
  }
}

/**
 * A function for running a command using an array of arguments. Note that
 * FunctionWithWrappers does not support tracking multiple interesting
 * arguments all the way to the call site.
 */
class ArrayExecFunctionCall extends FunctionCall {
  ArrayExecFunctionCall() {
    getTarget().hasGlobalName("execv") or
    getTarget().hasGlobalName("execvp") or
    getTarget().hasGlobalName("execvpe") or
    getTarget().hasGlobalName("execve") or
    getTarget().hasGlobalName("fexecve") or
    // Windows variants
    getTarget().hasGlobalName("_execv") or
    getTarget().hasGlobalName("_execve") or
    getTarget().hasGlobalName("_execvp") or
    getTarget().hasGlobalName("_execvpe") or
    getTarget().hasGlobalName("_spawnv") or
    getTarget().hasGlobalName("_spawnve") or
    getTarget().hasGlobalName("_spawnvp") or
    getTarget().hasGlobalName("_spawnvpe") or
    getTarget().hasGlobalName("_wexecv") or
    getTarget().hasGlobalName("_wexecve") or
    getTarget().hasGlobalName("_wexecvp") or
    getTarget().hasGlobalName("_wexecvpe") or
    getTarget().hasGlobalName("_wspawnv") or
    getTarget().hasGlobalName("_wspawnve") or
    getTarget().hasGlobalName("_wspawnvp") or
    getTarget().hasGlobalName("_wspawnvpe")
  }

  /** The argument with the array of command arguments */
  Expr getArrayArgument() { result = getArgument(getCommandIdx() + 1) }

  /** The expression denoting the program to execute */
  Expr getCommand() { result = getArgument(getCommandIdx()) }

  /**
   * The index of the command. The spawn variants start with a mode, whereas
   * all the other ones start with the command.
   */
  private int getCommandIdx() {
    if
      getTarget().getName().matches("\\_spawn%") or
      getTarget().getName().matches("\\_wspawn%")
    then result = 1
    else result = 0
  }
}

/**
 * The name of a shell and the flag used to preface a command that should be parsed. Public
 *  for testing purposes.
 */
predicate shellCommandPreface(string cmd, string flag) {
  (cmd = "sh" or cmd = "/bin/sh" or cmd = "bash" or cmd = "/bin/bash") and
  flag = "-c"
  or
  (
    cmd = "cmd" or
    cmd = "cmd.exe" or
    cmd = "CMD" or
    cmd = "CMD.EXE" or
    cmd = "%WINDIR%\\system32\\cmd.exe" // used in Juliet tests
  ) and
  (flag = "/c" or flag = "/C")
}

/**
 * A command that is used as a command, or component of a command,
 * that will be executed by a general-purpose command interpreter
 * such as sh or cmd.exe.
 */
predicate shellCommand(Expr command, string callChain) {
  // A call to a function like system()
  exists(SystemFunction systemFunction |
    systemFunction.outermostWrapperFunctionCall(command, callChain)
  )
  or
  // A call to a function like execl(), passing "sh", then "-c", and then a command.
  exists(
    VarargsExecFunctionCall execCall, StringLiteral commandInterpreter, StringLiteral flag,
    int commandIdx
  |
    callChain = execCall.getTarget().getName() and
    execCall.getCommand() = commandInterpreter and
    execCall.getCommandArgument(1) = flag and
    execCall.getCommandArgument(commandIdx) = command and
    commandIdx > 1 and
    shellCommandPreface(commandInterpreter.getValue(), flag.getValue())
  )
  or
  // A call to a function like execv(), where the array being passed is
  // initialized to an array literal
  exists(
    ArrayExecFunctionCall execCall, StringLiteral commandInterpreter, Variable arrayVariable,
    AggregateLiteral arrayInitializer, StringLiteral flag, int idx
  |
    callChain = execCall.getTarget().getName() and
    execCall.getCommand() = commandInterpreter and
    execCall.getArrayArgument() = arrayVariable.getAnAccess() and
    arrayVariable.getInitializer().getExpr() = arrayInitializer and
    arrayInitializer.getChild(1) = flag and
    arrayInitializer.getChild(idx) = command and
    shellCommandPreface(commandInterpreter.getValue(), flag.getValue()) and
    idx > 1
  )
}
