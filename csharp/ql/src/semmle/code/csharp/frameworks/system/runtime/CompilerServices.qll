/** Provides definitions related to the namespace `System.Runtime.CompilerServices`. */

import csharp
private import semmle.code.csharp.frameworks.system.Runtime

/** The `System.Runtime.CompilerServices` namespace. */
class SystemRuntimeCompilerServicesNamespace extends Namespace {
  SystemRuntimeCompilerServicesNamespace() {
    this.getParentNamespace() instanceof SystemRuntimeNamespace and
    this.hasName("CompilerServices")
  }
}

/** An unbound generic struct in the `System.Runtime.CompilerServices` namespace. */
class SystemRuntimeCompilerServicesNamespaceUnboundGenericStruct extends UnboundGenericStruct {
  SystemRuntimeCompilerServicesNamespaceUnboundGenericStruct() {
    this = any(SystemRuntimeCompilerServicesNamespace n).getATypeDeclaration()
  }
}

/** The `System.Runtime.CompilerServices.TaskAwaiter<>` struct. */
class SystemRuntimeCompilerServicesTaskAwaiterStruct extends SystemRuntimeCompilerServicesNamespaceUnboundGenericStruct {
  SystemRuntimeCompilerServicesTaskAwaiterStruct() { this.hasName("TaskAwaiter<>") }

  /** Gets the `GetResult` method. */
  Method getGetResultMethod() { result = this.getAMethod("GetResult") }

  /** Gets the field that stores the underlying task. */
  Field getUnderlyingTaskField() { result = this.getAField() and result.hasName("m_task") }
}
