/**
 * Provides a base class, `IRFunctionBase`, for the stage-independent portions of `IRFunction`.
 */

private import IRFunctionBaseInternal

private newtype TIRFunction =
  TFunctionIRFunction(Language::Function func) { IRConstruction::Raw::functionHasIR(func) } or
  TVarInitIRFunction(Language::GlobalVariable var) { IRConstruction::Raw::varHasIRFunc(var) }

/**
 * The IR for a function. This base class contains only the predicates that are the same between all
 * phases of the IR. Each instantiation of `IRFunction` extends this class.
 */
class IRFunctionBase extends TIRFunction {
  Language::Declaration decl;

  IRFunctionBase() {
    this = TFunctionIRFunction(decl)
    or
    this = TVarInitIRFunction(decl)
  }

  /** Gets a textual representation of this element. */
  final string toString() { result = "IR: " + decl.toString() }

  /** Gets the function whose IR is represented. */
  final Language::Declaration getFunction() { result = decl }

  /** Gets the location of the function. */
  final Language::Location getLocation() { result = decl.getLocation() }
}
