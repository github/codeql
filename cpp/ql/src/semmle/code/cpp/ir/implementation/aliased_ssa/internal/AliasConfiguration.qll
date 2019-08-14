private import cpp
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
private import semmle.code.cpp.ir.implementation.unaliased_ssa.gvn.ValueNumbering
private import AliasAnalysis

/**
 * A memory allocation that can be tracked by the AliasedSSA alias analysis.
 * For now, we track all variables accessed within the function, including both local variables
 * and global variables. In the future, we will track indirect parameters as well.
 */
class Allocation extends ValueNumber {
  IRVariable var;

  Allocation() {
    // For now, we only track variables.
    var = this.getAnInstruction().(VariableAddressInstruction).getVariable()
  }

  final string getAllocationString() {
    exists(string suffix |
      result = var.toString() + suffix and
      if isUnaliased() then
        suffix = ""
      else
        suffix = "*"
    )
  }

  final Type getType() {
    result = var.getType()
  }

  final int getBitSize() {
    result = getType().getSize() * 8
  }
  
  final predicate alwaysEscapes() {
    // An automatic variable only escapes if its address is taken and escapes, but we assume that
    // any other kind of variable always escapes.
    not var instanceof IRAutomaticVariable 
  }

  final predicate isUnaliased() {
    not allocationEscapes(this)
  }

  final Instruction getABaseInstruction() {
    // Any instruction with this value number serves as a base address for this allocation.
    result = getAnInstruction()
  }
}
