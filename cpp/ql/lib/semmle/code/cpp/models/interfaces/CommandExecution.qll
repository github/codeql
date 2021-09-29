/**
 * Provides classes for modeling functions that execute new programs by
 * interpreting string data as shell commands. To use this QL library, create
 * a QL class extending `CommandExecutionFunction` with a characteristic
 * predicate that selects the function or set of functions you are modeling.
 * Within that class, override the `hasCommandArgument` predicate to indicate
 * which parameters are interpreted as shell commands.
 */

import cpp
import FunctionInputsAndOutputs
import semmle.code.cpp.models.Models

/**
 * A function, such as `exec` or `popen` that starts a new process by
 * interpreting a string as a shell command.
 */
abstract class CommandExecutionFunction extends Function {
  /**
   * Holds if `input` is interpreted as a shell command.
   */
  abstract predicate hasCommandArgument(FunctionInput input);
}
