import SsaConsistency
import SSAConsistencyImports

module SsaConsistency {
  /**
   * Holds if a `MemoryOperand` has more than one `MemoryLocation` assigned by alias analysis.
   */
  query predicate multipleOperandMemoryLocations(
    OldIR::MemoryOperand operand, string message, OldIR::IRFunction func, string funcText
  ) {
    exists(int locationCount |
      locationCount = strictcount(Alias::getOperandMemoryLocation(operand)) and
      locationCount > 1 and
      func = operand.getEnclosingIRFunction() and
      funcText = LanguageDebug::getIdentityString(func.getFunction()) and
      message =
        operand.getUse().toString() + " " + "Operand has " + locationCount.toString() +
          " memory accesses in function '$@': " +
          strictconcat(Alias::getOperandMemoryLocation(operand).toString(), ", ")
    )
  }

  /**
   * Holds if a `MemoryLocation` does not have an associated `VirtualVariable`.
   */
  query predicate missingVirtualVariableForMemoryLocation(
    Alias::MemoryLocation location, string message, OldIR::IRFunction func, string funcText
  ) {
    not exists(location.getVirtualVariable()) and
    func = location.getIRFunction() and
    funcText = LanguageDebug::getIdentityString(func.getFunction()) and
    message = "Memory location has no virtual variable in function '$@'."
  }

  /**
   * Holds if a `MemoryLocation` is a member of more than one `VirtualVariable`.
   */
  query predicate multipleVirtualVariablesForMemoryLocation(
    Alias::MemoryLocation location, string message, OldIR::IRFunction func, string funcText
  ) {
    exists(int vvarCount |
      vvarCount = strictcount(location.getVirtualVariable()) and
      vvarCount > 1 and
      func = location.getIRFunction() and
      funcText = LanguageDebug::getIdentityString(func.getFunction()) and
      message =
        "Memory location has " + vvarCount.toString() + " virtual variables in function '$@': (" +
          concat(Alias::VirtualVariable vvar |
            vvar = location.getVirtualVariable()
          |
            vvar.toString(), ", "
          ) + ")."
    )
  }
}
