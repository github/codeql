private import AliasConfigurationImports
private import codeql.util.Unit

/**
 * A memory allocation that can be tracked by the SimpleSSA alias analysis.
 * All automatic variables are tracked.
 */
class Allocation extends IRAutomaticVariable {
  VariableAddressInstruction getABaseInstruction() { result.getIRVariable() = this }

  final string getAllocationString() { result = this.toString() }

  predicate alwaysEscapes() {
    // An automatic variable only escapes if its address is taken and escapes.
    none()
  }
}

predicate phaseNeedsSoundEscapeAnalysis() { any() }

Unit getOldAllocation(Allocation allocation) { any() }
