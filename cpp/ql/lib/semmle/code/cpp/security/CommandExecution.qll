/** Provides definitions related to execution of commands */

import cpp
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.CommandExecution

/**
 * A function for running a command using a command interpreter.
 */
class SystemFunction extends FunctionWithWrappers instanceof CommandExecutionFunction {
  override predicate interestingArg(int arg) {
    exists(FunctionInput input |
      this.(CommandExecutionFunction).hasCommandArgument(input) and
      (
        input.isParameterDerefOrQualifierObject(arg) or
        input.isParameterOrQualifierAddress(arg)
      )
    )
  }
}

/**
 * A function for running a command via varargs. Note that, at the time
 * of writing, FunctionWithWrappers doesn't really support varargs
 * arguments, because it requires a finite version of interestingArg().
 */
class VarargsExecFunctionCall extends FunctionCall {
  VarargsExecFunctionCall() {
    this.getTarget()
        .hasGlobalName([
            "execl", "execle", "execlp",
            // Windows
            "_execl", "_execle", "_execlp", "_execlpe", "_spawnl", "_spawnle", "_spawnlp",
            "_spawnlpe", "_wexecl", "_wexecle", "_wexeclp", "_wexeclpe", "_wspawnl", "_wspawnle",
            "_wspawnlp", "_wspawnlpe"
          ])
  }

  /** Whether the last argument to the function is an environment pointer */
  predicate hasEnvironmentArgument() {
    this.getTarget().hasGlobalName(["execle", "_execle", "_execlpe", "_wexecle", "_wexeclpe"])
  }

  /**
   * The arguments passed to the command. The 0th such argument is conventionally
   *  the name of the command.
   */
  Expr getCommandArgument(int idx) {
    exists(int underlyingIdx |
      result = this.getArgument(underlyingIdx) and
      underlyingIdx > this.getCommandIdx() and
      (
        underlyingIdx < this.getNumberOfArguments() - 1 or
        not this.hasEnvironmentArgument()
      ) and
      idx = underlyingIdx - this.getCommandIdx() - 1
    )
  }

  /** The expression denoting the program to execute */
  Expr getCommand() { result = this.getArgument(this.getCommandIdx()) }

  /**
   * The index of the command. The spawn variants start with a mode, whereas
   * all the other ones start with the command.
   */
  private int getCommandIdx() {
    if this.getTarget().getName().matches(["\\_spawn%", "\\_wspawn%"])
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
    this.getTarget()
        .hasGlobalName([
            "execv", "execvp", "execvpe", "execve", "fexecve",
            // Windows variants
            "_execv", "_execve", "_execvp", "_execvpe", "_spawnv", "_spawnve", "_spawnvp",
            "_spawnvpe", "_wexecv", "_wexecve", "_wexecvp", "_wexecvpe", "_wspawnv", "_wspawnve",
            "_wspawnvp", "_wspawnvpe"
          ])
  }

  /** The argument with the array of command arguments */
  Expr getArrayArgument() { result = this.getArgument(this.getCommandIdx() + 1) }

  /** The expression denoting the program to execute */
  Expr getCommand() { result = this.getArgument(this.getCommandIdx()) }

  /**
   * The index of the command. The spawn variants start with a mode, whereas
   * all the other ones start with the command.
   */
  private int getCommandIdx() {
    if this.getTarget().getName().matches(["\\_spawn%", "\\_wspawn%"])
    then result = 1
    else result = 0
  }
}

/**
 * The name of a shell and the flag used to preface a command that should be parsed. Public
 *  for testing purposes.
 */
predicate shellCommandPreface(string cmd, string flag) {
  cmd = ["sh", "/bin/sh", "bash", "/bin/bash"] and
  flag = "-c"
  or
  cmd =
    [
      "cmd", "cmd.exe", "CMD", "CMD.EXE", "%WINDIR%\\system32\\cmd.exe" // used in Juliet tests
    ] and
  flag = ["/c", "/C"]
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
