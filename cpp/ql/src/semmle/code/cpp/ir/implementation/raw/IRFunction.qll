private import internal.IRInternal
import Instruction

private newtype TIRFunction =
  MkIRFunction(Language::Function func) { Construction::functionHasIR(func) }

/**
 * Represents the IR for a function.
 */
class IRFunction extends TIRFunction {
  Language::Function func;

  IRFunction() { this = MkIRFunction(func) }

  final string toString() { result = "IR: " + func.toString() }

  /**
   * Gets the function whose IR is represented.
   */
  final Language::Function getFunction() { result = func }

  /**
   * Gets the location of the function.
   */
  final Language::Location getLocation() { result = func.getLocation() }

  /**
   * Gets the entry point for this function.
   */
  pragma[noinline]
  final EnterFunctionInstruction getEnterFunctionInstruction() {
    result.getEnclosingIRFunction() = this
  }

  /**
   * Gets the exit point for this function.
   */
  pragma[noinline]
  final ExitFunctionInstruction getExitFunctionInstruction() {
    result.getEnclosingIRFunction() = this
  }

  /**
   * Gets the single return instruction for this function.
   */
  pragma[noinline]
  final ReturnInstruction getReturnInstruction() { result.getEnclosingIRFunction() = this }

  /**
   * Gets the variable used to hold the return value of this function. If this
   * function does not return a value, this predicate does not hold.
   */
  pragma[noinline]
  final IRReturnVariable getReturnVariable() { result.getEnclosingIRFunction() = this }

  /**
   * Gets the block containing the entry point of this function.
   */
  pragma[noinline]
  final IRBlock getEntryBlock() { result.getFirstInstruction() = getEnterFunctionInstruction() }

  /**
   * Gets all instructions in this function.
   */
  final Instruction getAnInstruction() { result.getEnclosingIRFunction() = this }

  /**
   * Gets all blocks in this function.
   */
  final IRBlock getABlock() { result.getEnclosingIRFunction() = this }
}
