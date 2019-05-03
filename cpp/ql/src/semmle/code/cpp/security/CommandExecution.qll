/* Definitions related to execution of commands */

import cpp

import semmle.code.cpp.security.FunctionWithWrappers

/**
 * A function for running a command using a command interpreter.
 */
class SystemFunction extends FunctionWithWrappers {
  SystemFunction() {
    hasQualifiedName("system")
    or hasQualifiedName("popen")

    // Windows variants
    or hasQualifiedName("_popen")
    or hasQualifiedName("_wpopen")
    or hasQualifiedName("_wsystem")
  }

  override predicate interestingArg(int arg) {
    arg = 0
  }
}


/**
 * A function for running a command via varargs. Note that, at the time
 * of writing, FunctionWithWrappers doesn't really support varargs
 * arguments, because it requires a finite version of interestingArg().
 */
class VarargsExecFunctionCall extends FunctionCall {
  VarargsExecFunctionCall() {
    getTarget().hasQualifiedName("execl")
    or getTarget().hasQualifiedName("execle")
    or getTarget().hasQualifiedName("execlp")

    // Windows
    or getTarget().hasQualifiedName("_execl")
    or getTarget().hasQualifiedName("_execle")
    or getTarget().hasQualifiedName("_execlp")
    or getTarget().hasQualifiedName("_execlpe")
    or getTarget().hasQualifiedName("_spawnl")
    or getTarget().hasQualifiedName("_spawnle")
    or getTarget().hasQualifiedName("_spawnlp")
    or getTarget().hasQualifiedName("_spawnlpe")
    or getTarget().hasQualifiedName("_wexecl")
    or getTarget().hasQualifiedName("_wexecle")
    or getTarget().hasQualifiedName("_wexeclp")
    or getTarget().hasQualifiedName("_wexeclpe")
    or getTarget().hasQualifiedName("_wspawnl")
    or getTarget().hasQualifiedName("_wspawnle")
    or getTarget().hasQualifiedName("_wspawnlp")
    or getTarget().hasQualifiedName("_wspawnlpe")
  }

  /** Whether the last argument to the function is an environment pointer */
  predicate hasEnvironmentArgument() {
    getTarget().hasQualifiedName("execle")
    or getTarget().hasQualifiedName("_execle")
    or getTarget().hasQualifiedName("_execlpe")
    or getTarget().hasQualifiedName("_wexecle")
    or getTarget().hasQualifiedName("_wexeclpe")
  }

  /** The arguments passed to the command. The 0th such argument is conventionally
   *  the name of the command. */
  Expr getCommandArgument(int idx) {
    exists (int underlyingIdx |
      result = getArgument(underlyingIdx)
      and underlyingIdx > getCommandIdx()
      and (
        underlyingIdx < getNumberOfArguments() - 1
        or not hasEnvironmentArgument()
      )
      and idx = underlyingIdx - getCommandIdx() - 1)
  }

  /** The expression denoting the program to execute */
  Expr getCommand() {
    result = getArgument(getCommandIdx())
  }
  
  /** The index of the command. The spawn variants start with a mode, whereas
   * all the other ones start with the command. */
  private int getCommandIdx() {
    if (
      getTarget().getName().matches("\\_spawn%")
      or getTarget().getName().matches("\\_wspawn%"))
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
    getTarget().hasQualifiedName("execv")
    or getTarget().hasQualifiedName("execvp")
    or getTarget().hasQualifiedName("execvpe")

    // Windows variants
    or getTarget().hasQualifiedName("_execv")
    or getTarget().hasQualifiedName("_execve")
    or getTarget().hasQualifiedName("_execvp")
    or getTarget().hasQualifiedName("_execvpe")
    or getTarget().hasQualifiedName("_spawnv")
    or getTarget().hasQualifiedName("_spawnve")
    or getTarget().hasQualifiedName("_spawnvp")
    or getTarget().hasQualifiedName("_spawnvpe")
    or getTarget().hasQualifiedName("_wexecv")
    or getTarget().hasQualifiedName("_wexecve")
    or getTarget().hasQualifiedName("_wexecvp")
    or getTarget().hasQualifiedName("_wexecvpe")
    or getTarget().hasQualifiedName("_wspawnv")
    or getTarget().hasQualifiedName("_wspawnve")
    or getTarget().hasQualifiedName("_wspawnvp")
    or getTarget().hasQualifiedName("_wspawnvpe")
  }
  
  /** The argument with the array of command arguments */
  Expr getArrayArgument() {
    result = getArgument(getCommandIdx() + 1)
  }

  /** The expression denoting the program to execute */
  Expr getCommand() {
    result = getArgument(getCommandIdx())
  }
  
  /** The index of the command. The spawn variants start with a mode, whereas
   * all the other ones start with the command. */
  private int getCommandIdx() {
    if (
      getTarget().getName().matches("\\_spawn%")
      or getTarget().getName().matches("\\_wspawn%"))
    then result = 1
    else result = 0
  }
}


/** The name of a shell and the flag used to preface a command that should be parsed. Public
 *  for testing purposes. */
predicate shellCommandPreface(string cmd, string flag) {
  (
    (cmd = "sh" or cmd = "/bin/sh" or cmd = "bash" or cmd = "/bin/bash")
    and (flag = "-c")
  ) or (
    (cmd = "cmd" or cmd = "cmd.exe" or cmd = "CMD" or cmd = "CMD.EXE"
     or cmd = "%WINDIR%\\system32\\cmd.exe" // used in Juliet tests
    )
    and (flag = "/c" or flag = "/C")
  )
}

/**
 * A command that is used as a command, or component of a command,
 * that will be executed by a general-purpose command interpreter
 * such as sh or cmd.exe.
 */
predicate shellCommand(Expr command, string callChain) {
  // A call to a function like system()
  exists (SystemFunction systemFunction |
    systemFunction.outermostWrapperFunctionCall(command, callChain))
    
  // A call to a function like execl(), passing "sh", then "-c", and then a command.
  or exists (VarargsExecFunctionCall execCall, StringLiteral commandInterpreter, StringLiteral flag, int commandIdx |
    callChain = execCall.getTarget().getName()
    and execCall.getCommand() = commandInterpreter
    and execCall.getCommandArgument(1) = flag
    and execCall.getCommandArgument(commandIdx) = command
    and commandIdx > 1
    and shellCommandPreface(commandInterpreter.getValue(), flag.getValue()))

  // A call to a function like execv(), where the array being passed is
  // initialized to an array literal
  or exists(
    ArrayExecFunctionCall execCall, StringLiteral commandInterpreter, Variable arrayVariable,
    AggregateLiteral arrayInitializer, StringLiteral flag, int idx
  |
    callChain = execCall.getTarget().getName()
    and execCall.getCommand() = commandInterpreter
    and execCall.getArrayArgument() = arrayVariable.getAnAccess()
    and arrayVariable.getInitializer().getExpr() = arrayInitializer
    and arrayInitializer.getChild(1) = flag
    and arrayInitializer.getChild(idx) = command
    and shellCommandPreface(commandInterpreter.getValue(), flag.getValue())
    and idx > 1)
}

