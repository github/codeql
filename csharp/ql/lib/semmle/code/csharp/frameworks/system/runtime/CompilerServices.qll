/** Provides definitions related to the namespace `System.Runtime.CompilerServices`. */

import csharp
private import semmle.code.csharp.frameworks.system.Runtime
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.ExternalFlow

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

/** Data flow for `System.Runtime.CompilerServices.TaskAwaiter<>`. */
private class SystemRuntimeCompilerServicesTaskAwaiterFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Runtime.CompilerServices;TaskAwaiter<>;false;GetResult;();;Property[System.Threading.Tasks.Task<>.Result] of SyntheticField[m_task_task_awaiter] of Argument[Qualifier];ReturnValue;value"
  }
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

/** Data flow for `System.Runtime.CompilerServices.ConfiguredTaskAwaitable<>`. */
private class SystemRuntimeCompilerServicesConfiguredTaskAwaitableTFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Runtime.CompilerServices;ConfiguredTaskAwaitable<>;false;GetAwaiter;();;SyntheticField[m_configuredTaskAwaiter] of Argument[Qualifier];ReturnValue;value"
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

/** Data flow for `System.Runtime.CompilerServices.ConfiguredTaskAwaitable<>.ConfiguredTaskAwaiter`. */
private class SystemRuntimeCompilerServicesConfiguredTaskAwaitableTConfiguredTaskAwaiterFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Runtime.CompilerServices;ConfiguredTaskAwaitable<>+ConfiguredTaskAwaiter;false;GetResult;();;Property[System.Threading.Tasks.Task<>.Result] of SyntheticField[m_task_configured_task_awaitable] of Argument[Qualifier];ReturnValue;value"
  }
}

/** Data flow for `System.Runtime.CompilerServices.ReadOnlyCollectionBuilder<>`. */
private class SystemRuntimeCompilerServicesReadOnlyCollectionBuilderFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Runtime.CompilerServices;ReadOnlyCollectionBuilder<>;false;Reverse;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Runtime.CompilerServices;ReadOnlyCollectionBuilder<>;false;Reverse;(System.Int32,System.Int32);;Element of Argument[0];Element of ReturnValue;value",
      ]
  }
}
