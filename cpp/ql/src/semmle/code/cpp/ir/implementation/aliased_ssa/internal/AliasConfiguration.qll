private import AliasConfigurationInternal
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
private import cpp
private import AliasAnalysis

private newtype TAllocation =
  TVariableAllocation(IRVariable var) or
  TIndirectParameterAllocation(IRAutomaticUserVariable var) {
    exists(InitializeIndirectionInstruction instr | instr.getIRVariable() = var)
  }

/**
 * A memory allocation that can be tracked by the AliasedSSA alias analysis.
 */
abstract class Allocation extends TAllocation {
  abstract string toString();

  final string getAllocationString() { result = toString() }

  abstract Instruction getABaseInstruction();

  abstract IRFunction getEnclosingIRFunction();

  abstract Language::Location getLocation();

  abstract string getUniqueId();

  abstract IRType getIRType();

  abstract predicate isReadOnly();

  abstract predicate alwaysEscapes();

  abstract predicate isAlwaysAllocatedOnStack();

  final predicate isUnaliased() { not allocationEscapes(this) }
}

class VariableAllocation extends Allocation, TVariableAllocation {
  IRVariable var;

  VariableAllocation() { this = TVariableAllocation(var) }

  final override string toString() { result = var.toString() }

  final override VariableInstruction getABaseInstruction() {
    result.getIRVariable() = var and
    (result instanceof VariableAddressInstruction or result instanceof StringConstantInstruction)
  }

  final override IRFunction getEnclosingIRFunction() { result = var.getEnclosingIRFunction() }

  final override Language::Location getLocation() { result = var.getLocation() }

  final override string getUniqueId() { result = var.getUniqueId() }

  final override IRType getIRType() { result = var.getIRType() }

  final override predicate isReadOnly() { var.isReadOnly() }

  final override predicate isAlwaysAllocatedOnStack() { var instanceof IRAutomaticVariable }

  final override predicate alwaysEscapes() {
    // All variables with static storage duration have their address escape, even when escape analysis
    // is allowed to be unsound. Otherwise, we won't have a definition for any non-escaped global
    // variable. Normally, we rely on `AliasedDefinition` to handle that.
    not var instanceof IRAutomaticVariable
  }

  final IRVariable getIRVariable() { result = var }
}

class IndirectParameterAllocation extends Allocation, TIndirectParameterAllocation {
  IRAutomaticUserVariable var;

  IndirectParameterAllocation() { this = TIndirectParameterAllocation(var) }

  final override string toString() { result = "*" + var.toString() }

  final override InitializeParameterInstruction getABaseInstruction() {
    result.getIRVariable() = var
  }

  final override IRFunction getEnclosingIRFunction() { result = var.getEnclosingIRFunction() }

  final override Language::Location getLocation() { result = var.getLocation() }

  final override string getUniqueId() { result = var.getUniqueId() }

  final override IRType getIRType() { result = var.getIRType() }

  final override predicate isReadOnly() { none() }

  final override predicate isAlwaysAllocatedOnStack() { none() }

  final override predicate alwaysEscapes() { none() }
}
