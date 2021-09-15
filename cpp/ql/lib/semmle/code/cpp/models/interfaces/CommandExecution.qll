import cpp
import FunctionInputsAndOutputs
import semmle.code.cpp.models.Models

abstract class CommandExecutionFunction extends Function {
  abstract predicate hasCommandArgument(FunctionInput input);
}