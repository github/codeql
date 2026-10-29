/** Provides definitions related to the namespace `System.Threading.Tasks`. */

import csharp
private import semmle.code.csharp.frameworks.system.Threading
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate

/** The `System.Threading.Tasks` namespace. */
class SystemThreadingTasksNamespace extends Namespace {
  SystemThreadingTasksNamespace() {
    this.getParentNamespace() instanceof SystemThreadingNamespace and
    this.hasName("Tasks")
  }
}

/** A class in the `System.Threading.Tasks` namespace. */
class SystemThreadingTasksClass extends Class {
  SystemThreadingTasksClass() { this.getNamespace() instanceof SystemThreadingTasksNamespace }
}

/** An unbound generic class in the `System.Threading.Tasks` namespace. */
class SystemThreadingTasksUnboundGenericClass extends UnboundGenericClass {
  SystemThreadingTasksUnboundGenericClass() {
    this.getNamespace() instanceof SystemThreadingTasksNamespace
  }
}

/** The `System.Threading.Tasks.Task` class. */
class SystemThreadingTasksTaskClass extends SystemThreadingTasksClass {
  SystemThreadingTasksTaskClass() { this.hasName("Task") }
}

/** The ``System.Threading.Tasks.Task`1`` class. */
class SystemThreadingTasksTaskTClass extends SystemThreadingTasksUnboundGenericClass {
  SystemThreadingTasksTaskTClass() { this.hasName("Task`1") }

  /** Gets the `Result` property. */
  Property getResultProperty() {
    result.getDeclaringType() = this and
    result.hasName("Result") and
    result.getType() = this.getTypeParameter(0)
  }

  /** Gets the `GetAwaiter` method. */
  Method getGetAwaiterMethod() { result = this.getAMethod("GetAwaiter") }

  /** Gets the `ConfigureAwait` method. */
  Method getConfigureAwaitMethod() { result = this.getAMethod("ConfigureAwait") }
}

abstract private class SyntheticTaskField extends SyntheticField {
  bindingset[this]
  SyntheticTaskField() { any() }

  override Type getType() { result instanceof SystemThreadingTasksTaskTClass }
}

private class SyntheticTaskAwaiterUnderlyingTaskField extends SyntheticTaskField {
  SyntheticTaskAwaiterUnderlyingTaskField() { this = "m_task_task_awaiter" }
}

private class SyntheticConfiguredTaskAwaitableUnderlyingTaskField extends SyntheticTaskField {
  SyntheticConfiguredTaskAwaitableUnderlyingTaskField() {
    this = "m_task_configured_task_awaitable"
  }
}
