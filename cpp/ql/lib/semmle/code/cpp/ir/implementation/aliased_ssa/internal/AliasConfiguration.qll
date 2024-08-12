private import AliasConfigurationInternal
private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
private import cpp
private import AliasAnalysis
private import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.SimpleSSA as UnaliasedSsa

private newtype TAllocation =
  TVariableAllocation(IRVariable var) {
    // Only model variables that were not already handled in unaliased SSA.
    not UnaliasedSsa::canReuseSsaForVariable(var)
  } or
  TIndirectParameterAllocation(IRAutomaticVariable var) {
    exists(InitializeIndirectionInstruction instr | instr.getIRVariable() = var)
  } or
  TDynamicAllocation(CallInstruction call) {
    exists(InitializeDynamicAllocationInstruction instr | instr.getPrimaryInstruction() = call)
  }

/**
 * A memory allocation that can be tracked by the AliasedSSA alias analysis.
 */
abstract class Allocation extends TAllocation {
  abstract string toString();

  final string getAllocationString() { result = this.toString() }

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
  IRAutomaticVariable var;

  IndirectParameterAllocation() { this = TIndirectParameterAllocation(var) }

  final override string toString() { result = "*" + var.toString() }

  final override InitializeParameterInstruction getABaseInstruction() {
    result.getIRVariable() = var
  }

  final override IRFunction getEnclosingIRFunction() { result = var.getEnclosingIRFunction() }

  final override Language::Location getLocation() { result = var.getLocation() }

  final override string getUniqueId() { result = var.getUniqueId() }

  final override IRType getIRType() { result instanceof IRUnknownType }

  final override predicate isReadOnly() { none() }

  final override predicate isAlwaysAllocatedOnStack() { none() }

  final override predicate alwaysEscapes() { none() }

  final IRAutomaticVariable getIRVariable() { result = var }
}

class DynamicAllocation extends Allocation, TDynamicAllocation {
  CallInstruction call;

  DynamicAllocation() { this = TDynamicAllocation(call) }

  final override string toString() {
    // This isn't performant, but it's only used in test/dump code right now.
    // Dynamic allocations within a function are numbered in the order by start
    // line number. This keeps them stable when the function moves within the
    // file, or when non-allocating lines are added and removed within the
    // function.
    exists(int i |
      result = "dynamic{" + i.toString() + "}" and
      call =
        rank[i](CallInstruction rangeCall |
          exists(TDynamicAllocation(rangeCall)) and
          rangeCall.getEnclosingIRFunction() = call.getEnclosingIRFunction()
        |
          rangeCall order by rangeCall.getLocation().getStartLine()
        )
    )
  }

  final override CallInstruction getABaseInstruction() { result = call }

  final override IRFunction getEnclosingIRFunction() { result = call.getEnclosingIRFunction() }

  final override Language::Location getLocation() { result = call.getLocation() }

  final override string getUniqueId() { result = call.getUniqueId() }

  final override IRType getIRType() { result instanceof IRUnknownType }

  final override predicate isReadOnly() { none() }

  final override predicate isAlwaysAllocatedOnStack() { none() }

  final override predicate alwaysEscapes() { none() }
}

predicate phaseNeedsSoundEscapeAnalysis() { none() }

UnaliasedSsa::Allocation getOldAllocation(VariableAllocation allocation) {
  UnaliasedSsa::canReuseSsaForVariable(allocation.getIRVariable()) and
  result = allocation.getIRVariable()
}
