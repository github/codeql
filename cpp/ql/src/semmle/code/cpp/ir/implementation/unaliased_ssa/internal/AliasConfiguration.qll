private import AliasConfigurationImports

/**
 * A memory allocation that can be tracked by the SimpleSSA alias analysis.
 * All automatic variables are tracked.
 */
class Allocation extends IRAutomaticVariable {
  VariableAddressInstruction getABaseInstruction() { result.getIRVariable() = this }

  final string getAllocationString() { result = toString() }
}
