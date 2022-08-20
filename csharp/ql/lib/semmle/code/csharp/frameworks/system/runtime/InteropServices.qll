/** Provides definitions related to the namespace `System.Runtime.InteropServices`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Runtime

/** The `System.Runtime.InteropServices` namespace. */
class SystemRuntimeInteropServicesNamespace extends Namespace {
  SystemRuntimeInteropServicesNamespace() {
    this.getParentNamespace() instanceof SystemRuntimeNamespace and
    this.hasName("InteropServices")
  }
}

/** A class in the `System.Runtime.InteropServices` namespace. */
class SystemRuntimeInteropServicesClass extends Class {
  SystemRuntimeInteropServicesClass() {
    this = any(SystemRuntimeInteropServicesNamespace n).getATypeDeclaration()
  }
}

/** The `System.Runtime.InteropServices.DllImportAttribute` class. */
class SystemRuntimeInteropServicesDllImportAttributeClass extends SystemRuntimeInteropServicesClass {
  SystemRuntimeInteropServicesDllImportAttributeClass() { this.hasName("DllImportAttribute") }
}

/** The `System.Runtime.InteropServices.Marshal` class. */
class SystemRuntimeInteropServicesMarshalClass extends SystemRuntimeInteropServicesClass {
  SystemRuntimeInteropServicesMarshalClass() { this.hasName("Marshal") }

  /** Gets the `PtrToStructure(IntPtr, Type)` method. */
  Method getPtrToStructureTypeMethod() {
    result.getDeclaringType() = this and
    result.hasName("PtrToStructure") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof SystemIntPtrType and
    result.getParameter(1).getType() instanceof SystemTypeClass and
    result.getReturnType() instanceof SystemObjectClass
  }

  /** Gets the `PtrToStructure(IntPtr, object)` method. */
  Method getPtrToStructureObjectMethod() {
    result.getDeclaringType() = this and
    result.hasName("PtrToStructure") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() instanceof SystemIntPtrType and
    result.getParameter(1).getType() instanceof SystemObjectClass and
    result.getReturnType() instanceof VoidType
  }
}

/** The `System.Runtime.InteropServices.ComImportAttribute` class. */
class SystemRuntimeInteropServicesComImportAttributeClass extends SystemRuntimeInteropServicesClass {
  SystemRuntimeInteropServicesComImportAttributeClass() { this.hasName("ComImportAttribute") }
}
