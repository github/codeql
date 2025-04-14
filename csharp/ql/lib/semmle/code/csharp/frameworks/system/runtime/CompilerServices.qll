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

/** The ``System.Runtime.CompilerServices.TaskAwaiter`1`` struct. */
class SystemRuntimeCompilerServicesTaskAwaiterStruct extends SystemRuntimeCompilerServicesNamespaceUnboundGenericStruct
{
  SystemRuntimeCompilerServicesTaskAwaiterStruct() { this.hasName("TaskAwaiter`1") }

  /** Gets the `GetResult` method. */
  Method getGetResultMethod() { result = this.getAMethod("GetResult") }

  /** Gets the field that stores the underlying task. */
  Field getUnderlyingTaskField() { result = this.getAField() and result.hasName("m_task") }
}

/** The ``System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1`` struct. */
class SystemRuntimeCompilerServicesConfiguredTaskAwaitableTStruct extends SystemRuntimeCompilerServicesNamespaceUnboundGenericStruct
{
  SystemRuntimeCompilerServicesConfiguredTaskAwaitableTStruct() {
    this.hasName("ConfiguredTaskAwaitable`1")
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

/** The ``System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1.ConfiguredTaskAwaiter`` struct. */
class SystemRuntimeCompilerServicesConfiguredTaskAwaitableTConfiguredTaskAwaiterStruct extends Struct
{
  SystemRuntimeCompilerServicesConfiguredTaskAwaitableTConfiguredTaskAwaiterStruct() {
    this = any(SystemRuntimeCompilerServicesConfiguredTaskAwaitableTStruct n).getANestedType() and
    this.hasName("ConfiguredTaskAwaiter")
  }

  /** Gets the `GetResult` method. */
  Method getGetResultMethod() { result = this.getAMethod("GetResult") }

  /** Gets the field that stores the underlying task. */
  Field getUnderlyingTaskField() { result = this.getAField() and result.hasName("m_task") }
}

/** An attribute of type `System.Runtime.CompilerServices.InlineArrayAttribute`. */
class SystemRuntimeCompilerServicesInlineArrayAttribute extends Attribute {
  SystemRuntimeCompilerServicesInlineArrayAttribute() {
    this.getNamespace() instanceof SystemRuntimeCompilerServicesNamespace and
    this.getType().hasName("InlineArrayAttribute")
  }

  /**
   * Gets the length of the inline array.
   */
  int getLength() { result = this.getConstructorArgument(0).getValue().toInt() }
}

/** An attribute of type `System.Runtime.CompilerServices.OverloadResolutionPriority`. */
class SystemRuntimeCompilerServicesOverloadResolutionPriorityAttribute extends Attribute {
  SystemRuntimeCompilerServicesOverloadResolutionPriorityAttribute() {
    this.getNamespace() instanceof SystemRuntimeCompilerServicesNamespace and
    this.getType().hasName("OverloadResolutionPriorityAttribute")
  }

  /**
   * Gets the priority number.
   */
  int getPriority() { result = this.getConstructorArgument(0).getValue().toInt() }
}
