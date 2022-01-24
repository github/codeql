/** Provides classes and predicates to reason about `AsyncTask`s in Android. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/**
 * Models the value-preserving step from `asyncTask.execute(params)` to `AsyncTask::doInBackground(params)`.
 */
private class AsyncTaskAdditionalValueStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(ExecuteAsyncTaskMethodAccess ma, AsyncTaskRunInBackgroundMethod m |
      DataFlow::getInstanceArgument(ma).getType() = m.getDeclaringType() and
      node1.asExpr() = ma.getParamsArgument() and
      node2.asParameter() = m.getParameter(0)
    )
  }
}

/**
 * The Android class `android.os.AsyncTask`.
 */
private class AsyncTask extends RefType {
  AsyncTask() { this.hasQualifiedName("android.os", "AsyncTask") }
}

/** A call to the `execute` or `executeOnExecutor` methods of the `android.os.AsyncTask` class. */
private class ExecuteAsyncTaskMethodAccess extends MethodAccess {
  Argument paramsArgument;

  ExecuteAsyncTaskMethodAccess() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof AsyncTask
    |
      m.getName() = "execute" and not m.isStatic() and paramsArgument = this.getArgument(0)
      or
      m.getName() = "executeOnExecutor" and paramsArgument = this.getArgument(1)
    )
  }

  /** Returns the `params` argument of this call. */
  Argument getParamsArgument() { result = paramsArgument }
}

/** The `doInBackground` method of the `android.os.AsyncTask` class. */
private class AsyncTaskRunInBackgroundMethod extends Method {
  AsyncTaskRunInBackgroundMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof AsyncTask and
    this.getName() = "doInBackground"
  }
}
