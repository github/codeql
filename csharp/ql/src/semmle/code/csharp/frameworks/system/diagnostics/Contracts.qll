/** Provides definitions related to the namespace `System.Diagnostics.Contracts`. */

import semmle.code.csharp.Type
private import semmle.code.csharp.frameworks.system.Diagnostics

/** The `System.Diagnostics.Contracts` namespace. */
class SystemDiagnosticsContractsNamespace extends Namespace {
  SystemDiagnosticsContractsNamespace() {
    this.getParentNamespace() instanceof SystemDiagnosticsNamespace and
    this.hasName("Contracts")
  }
}

/** A class in the `System.Diagnostics.Contracts` namespace. */
class SystemDiagnosticsContractsClass extends Class {
  SystemDiagnosticsContractsClass() {
    this.getNamespace() instanceof SystemDiagnosticsContractsNamespace
  }
}

/** The `System.Diagnostics.Contracts.Contract` class. */
class SystemDiagnosticsContractsContractClass extends SystemDiagnosticsContractsClass {
  SystemDiagnosticsContractsContractClass() {
    this.hasName("Contract") and
    this.isStatic()
  }

  /** Gets an `Assert(bool, ...)` method. */
  Method getAnAssertMethod() {
    result.getDeclaringType() = this and
    result.hasName("Assert") and
    result.getParameter(0).getType() instanceof BoolType and
    result.getReturnType() instanceof VoidType
  }

  /** Gets an `Assume(bool, ...)` method. */
  Method getAnAssumeMethod() {
    result.getDeclaringType() = this and
    result.hasName("Assume") and
    result.getParameter(0).getType() instanceof BoolType and
    result.getReturnType() instanceof VoidType
  }

  /** Gets a `Requires(bool, ...)` method. */
  Method getARequiresMethod() {
    result.getDeclaringType() = this and
    result.hasName("Requires") and
    result.getParameter(0).getType() instanceof BoolType and
    result.getReturnType() instanceof VoidType
  }
}
