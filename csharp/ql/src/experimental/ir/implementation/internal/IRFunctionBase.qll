/**
 * Provides a base class, `IRFunctionBase`, for the stage-independent portions of `IRFunction`.
 */

private import IRFunctionBaseInternal

private newtype TIRFunction =
  MkIRFunction(Language::Function func) { IRConstruction::Raw::functionHasIR(func) }

/**
 * The IR for a function. This base class contains only the predicates that are the same between all
 * phases of the IR. Each instantiation of `IRFunction` extends this class.
 */
class IRFunctionBase extends TIRFunction {
  Language::Function func;

  IRFunctionBase() { this = MkIRFunction(func) }

  /** Gets a textual representation of this element. */
  final string toString() { result = "IR: " + func.toString() }

  /** Gets the function whose IR is represented. */
  final Language::Function getFunction() { result = func }

  /** Gets the location of the function. */
  final Language::Location getLocation() { result = func.getLocation() }
}
