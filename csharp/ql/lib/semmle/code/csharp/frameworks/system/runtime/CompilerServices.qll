/** Provides definitions related to the namespace `System.Runtime.CompilerServices`. */

import csharp
private import semmle.code.csharp.frameworks.system.Runtime
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate

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

/** The `System.Runtime.CompilerServices.ConfiguredTaskAwaitable<>` struct. */
class SystemRuntimeCompilerServicesConfiguredTaskAwaitableTStruct extends SystemRuntimeCompilerServicesNamespaceUnboundGenericStruct {
  SystemRuntimeCompilerServicesConfiguredTaskAwaitableTStruct() {
    this.hasName("ConfiguredTaskAwaitable<>")
  }

  /** Gets the `GetAwaiter` method. */
  Method getGetAwaiterMethod() { result = this.getAMethod("GetAwaiter") }

  /** Gets the field that stores the underlying awaiter. */
  Field getUnderlyingAwaiterField() {
    result = this.getAField() and result.hasName("m_configuredTaskAwaiter")
  }
}

private class SyntheticConfiguredTaskAwaiterField extends SyntheticField {
  SyntheticConfiguredTaskAwaiterField() { this = "m_configuredTaskAwaiter" }

  override Type getType() {
    result instanceof
      SystemRuntimeCompilerServicesConfiguredTaskAwaitableTConfiguredTaskAwaiterStruct
  }
}

/** The `System.Runtime.CompilerServices.ConfiguredTaskAwaitable<>.ConfiguredTaskAwaiter` struct. */
class SystemRuntimeCompilerServicesConfiguredTaskAwaitableTConfiguredTaskAwaiterStruct extends Struct {
  SystemRuntimeCompilerServicesConfiguredTaskAwaitableTConfiguredTaskAwaiterStruct() {
    this = any(SystemRuntimeCompilerServicesConfiguredTaskAwaitableTStruct n).getANestedType() and
    this.hasName("ConfiguredTaskAwaiter")
  }

  /** Gets the `GetResult` method. */
  Method getGetResultMethod() { result = this.getAMethod("GetResult") }

  /** Gets the field that stores the underlying task. */
  Field getUnderlyingTaskField() { result = this.getAField() and result.hasName("m_task") }
}
