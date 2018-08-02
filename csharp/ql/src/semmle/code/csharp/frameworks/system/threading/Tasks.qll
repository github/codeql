/** Provides definitions related to the namespace `System.Threading.Tasks`. */
import csharp
private import semmle.code.csharp.frameworks.system.Threading

/** The `System.Threading.Tasks` namespace. */
class SystemThreadingTasksNamespace extends Namespace {
  SystemThreadingTasksNamespace() {
    this.getParentNamespace() instanceof SystemThreadingNamespace and
    this.hasName("Tasks")
  }
}

/** DEPRECATED. Gets the `System.Threading.Tasks` namespace. */
deprecated
SystemThreadingTasksNamespace getSystemThreadingTasksNamespace() { any() }

/** A class in the `System.Threading.Tasks` namespace. */
class SystemThreadingTasksClass extends Class {
  SystemThreadingTasksClass() {
    this.getNamespace() instanceof SystemThreadingTasksNamespace
  }
}

/** An unbound generic class in the `System.Threading.Tasks` namespace. */
class SystemThreadingTasksUnboundGenericClass extends UnboundGenericClass {
  SystemThreadingTasksUnboundGenericClass() {
    this.getNamespace() instanceof SystemThreadingTasksNamespace
  }
}

/** The `System.Threading.Tasks.Task` class. */
class SystemThreadingTasksTaskClass extends SystemThreadingTasksClass {
  SystemThreadingTasksTaskClass() {
    this.hasName("Task")
  }
}

/** DEPRECATED. Gets the `System.Threading.Tasks.Task` class. */
deprecated
SystemThreadingTasksTaskClass getSystemThreadingTasksTaskClass() { any() }

/** The `System.Threading.Tasks.Task<T>` class. */
class SystemThreadingTasksTaskTClass extends SystemThreadingTasksUnboundGenericClass {
  SystemThreadingTasksTaskTClass() {
    this.hasName("Task<>")
  }

  /** Gets the `Result` property. */
  Property getResultProperty() {
    result.getDeclaringType() = this
    and
    result.hasName("Result")
    and
    result.getType() = this.getTypeParameter(0)
  }
}

/** DEPRECATED. Gets the `System.Threading.Tasks.Task<T>` class. */
deprecated
SystemThreadingTasksTaskTClass getSystemThreadingTasksTaskTClass() { any() }
