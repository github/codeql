/**
 * Provides the class `IRFunction`, which represents the Intermediate Representation for the
 * definition of a function.
 */

private import internal.IRInternal
private import internal.IRFunctionImports as Imports
import Imports::IRFunctionBase
import Instruction

/**
 * The IR for a function.
 */
class IRFunction extends IRFunctionBase {
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
  final IRBlock getEntryBlock() {
    result.getFirstInstruction() = this.getEnterFunctionInstruction()
  }

  /**
   * Gets all instructions in this function.
   */
  final Instruction getAnInstruction() { result.getEnclosingIRFunction() = this }

  /**
   * Gets all blocks in this function.
   */
  final IRBlock getABlock() { result.getEnclosingIRFunction() = this }
}
