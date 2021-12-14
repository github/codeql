/** Provides definitions related to the namespace `System.Threading.Tasks`. */

import csharp
private import semmle.code.csharp.frameworks.system.Threading
private import semmle.code.csharp.dataflow.ExternalFlow

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

/** Data flow for `System.Threading.Tasks.Task`. */
private class SystemThreadingTasksTaskFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Threading.Tasks;Task;false;ContinueWith;(System.Action<System.Threading.Tasks.Task,System.Object>,System.Object);;Argument[1];Parameter[1] of Argument[0];value",
        "System.Threading.Tasks;Task;false;ContinueWith;(System.Action<System.Threading.Tasks.Task,System.Object>,System.Object,System.Threading.CancellationToken);;Argument[1];Parameter[1] of Argument[0];value",
        "System.Threading.Tasks;Task;false;ContinueWith;(System.Action<System.Threading.Tasks.Task,System.Object>,System.Object,System.Threading.CancellationToken,System.Threading.Tasks.TaskContinuationOptions,System.Threading.Tasks.TaskScheduler);;Argument[1];Parameter[1] of Argument[0];value",
        "System.Threading.Tasks;Task;false;ContinueWith;(System.Action<System.Threading.Tasks.Task,System.Object>,System.Object,System.Threading.Tasks.TaskContinuationOptions);;Argument[1];Parameter[1] of Argument[0];value",
        "System.Threading.Tasks;Task;false;ContinueWith;(System.Action<System.Threading.Tasks.Task,System.Object>,System.Object,System.Threading.Tasks.TaskScheduler);;Argument[1];Parameter[1] of Argument[0];value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,System.Object,TResult>,System.Object);;Argument[1];Parameter[1] of Argument[0];value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,System.Object,TResult>,System.Object);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,System.Object,TResult>,System.Object,System.Threading.CancellationToken);;Argument[1];Parameter[1] of Argument[0];value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,System.Object,TResult>,System.Object,System.Threading.CancellationToken);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,System.Object,TResult>,System.Object,System.Threading.CancellationToken,System.Threading.Tasks.TaskContinuationOptions,System.Threading.Tasks.TaskScheduler);;Argument[1];Parameter[1] of Argument[0];value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,System.Object,TResult>,System.Object,System.Threading.CancellationToken,System.Threading.Tasks.TaskContinuationOptions,System.Threading.Tasks.TaskScheduler);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,System.Object,TResult>,System.Object,System.Threading.Tasks.TaskContinuationOptions);;Argument[1];Parameter[1] of Argument[0];value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,System.Object,TResult>,System.Object,System.Threading.Tasks.TaskContinuationOptions);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,System.Object,TResult>,System.Object,System.Threading.Tasks.TaskScheduler);;Argument[1];Parameter[1] of Argument[0];value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,System.Object,TResult>,System.Object,System.Threading.Tasks.TaskScheduler);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,TResult>);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,TResult>,System.Threading.CancellationToken);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,TResult>,System.Threading.CancellationToken,System.Threading.Tasks.TaskContinuationOptions,System.Threading.Tasks.TaskScheduler);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,TResult>,System.Threading.Tasks.TaskContinuationOptions);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;ContinueWith<>;(System.Func<System.Threading.Tasks.Task,TResult>,System.Threading.Tasks.TaskScheduler);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;FromResult<>;(TResult);;Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;Run<>;(System.Func<System.Threading.Tasks.Task<TResult>>);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;Run<>;(System.Func<System.Threading.Tasks.Task<TResult>>,System.Threading.CancellationToken);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;Run<>;(System.Func<TResult>);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;Run<>;(System.Func<TResult>,System.Threading.CancellationToken);;ReturnValue of Argument[0];Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;Task;(System.Action<System.Object>,System.Object);;Argument[1];Parameter[0] of Argument[0];value",
        "System.Threading.Tasks;Task;false;Task;(System.Action<System.Object>,System.Object,System.Threading.CancellationToken);;Argument[1];Parameter[0] of Argument[0];value",
        "System.Threading.Tasks;Task;false;Task;(System.Action<System.Object>,System.Object,System.Threading.CancellationToken,System.Threading.Tasks.TaskCreationOptions);;Argument[1];Parameter[0] of Argument[0];value",
        "System.Threading.Tasks;Task;false;Task;(System.Action<System.Object>,System.Object,System.Threading.Tasks.TaskCreationOptions);;Argument[1];Parameter[0] of Argument[0];value",
        "System.Threading.Tasks;Task;false;WhenAll<>;(System.Collections.Generic.IEnumerable<System.Threading.Tasks.Task<TResult>>);;Property[System.Threading.Tasks.Task<>.Result] of Element of Argument[0];Element of Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;WhenAll<>;(System.Threading.Tasks.Task<TResult>[]);;Property[System.Threading.Tasks.Task<>.Result] of Element of Argument[0];Element of Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;WhenAny<>;(System.Collections.Generic.IEnumerable<System.Threading.Tasks.Task<TResult>>);;Property[System.Threading.Tasks.Task<>.Result] of Element of Argument[0];Element of Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;WhenAny<>;(System.Threading.Tasks.Task<TResult>,System.Threading.Tasks.Task<TResult>);;Property[System.Threading.Tasks.Task<>.Result] of Element of Argument[0];Element of Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;WhenAny<>;(System.Threading.Tasks.Task<TResult>,System.Threading.Tasks.Task<TResult>);;Property[System.Threading.Tasks.Task<>.Result] of Element of Argument[1];Element of Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
        "System.Threading.Tasks;Task;false;WhenAny<>;(System.Threading.Tasks.Task<TResult>[]);;Property[System.Threading.Tasks.Task<>.Result] of Element of Argument[0];Element of Property[System.Threading.Tasks.Task<>.Result] of ReturnValue;value",
      ]
  }
}

/** The `System.Threading.Tasks.Task<T>` class. */
class SystemThreadingTasksTaskTClass extends SystemThreadingTasksUnboundGenericClass {
  SystemThreadingTasksTaskTClass() { this.hasName("Task<>") }

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
