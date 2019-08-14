private import semmle.code.cpp.ir.implementation.raw.IR

/**
 * A memory allocation that can be tracked by the SimpleSSA alias analysis.
 * All automatic variables are tracked.
 */
class Allocation extends IRAutomaticVariable {
  VariableAddressInstruction getABaseInstruction() {
    result.getVariable() = this
  }

  final string getAllocationString() {
    result = toString()
  }

  predicate alwaysEscapes() {
    // An automatic variable only escapes if its address is taken and escapes.
    none()
  }
}
