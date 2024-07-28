/** Provides classes and predicates to reason about `AsyncTask`s in Android. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/*
 * The following flow steps aim to model the life-cycle of `AsyncTask`s described here:
 * https://developer.android.com/reference/android/os/AsyncTask#the-4-steps
 */

/**
 * A taint step from the vararg arguments of `AsyncTask::execute` and `AsyncTask::executeOnExecutor`
 * to the parameter of `AsyncTask::doInBackground`.
 */
private class AsyncTaskExecuteAdditionalValueStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(ExecuteAsyncTaskMethodCall ma, AsyncTaskRunInBackgroundMethod m |
      DataFlow::getInstanceArgument(ma).getType() = m.getDeclaringType()
    |
      node1.asExpr() = ma.getParamsArgument() and
      node2.asParameter() = m.getParameter(0)
    )
  }
}

/**
 * A value-preserving step from the return value of `AsyncTask::doInBackground`
 * to the parameter of `AsyncTask::onPostExecute`.
 */
private class AsyncTaskOnPostExecuteAdditionalValueStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(
      AsyncTaskRunInBackgroundMethod runInBackground, AsyncTaskOnPostExecuteMethod onPostExecute
    |
      onPostExecute.getDeclaringType() = runInBackground.getDeclaringType()
    |
      node1.asExpr() = any(ReturnStmt r | r.getEnclosingCallable() = runInBackground).getResult() and
      node2.asParameter() = onPostExecute.getParameter(0)
    )
  }
}

/**
 * A value-preserving step from field initializers in `AsyncTask`'s constructor or initializer method
 * to the instance parameter of `AsyncTask::runInBackground` and `AsyncTask::onPostExecute`.
 */
private class AsyncTaskFieldInitQualifierToInstanceParameterStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(AsyncTaskInit init, Callable receiver |
      n1.(DataFlow::PostUpdateNode).getPreUpdateNode() =
        DataFlow::getFieldQualifier(any(FieldWrite f | f.getEnclosingCallable() = init)) and
      n2.(DataFlow::InstanceParameterNode).getCallable() = receiver and
      receiver.getDeclaringType() = init.getDeclaringType() and
      (
        receiver instanceof AsyncTaskRunInBackgroundMethod or
        receiver instanceof AsyncTaskOnPostExecuteMethod
      )
    )
  }
}

/**
 * The Android class `android.os.AsyncTask`.
 */
private class AsyncTask extends RefType {
  AsyncTask() { this.hasQualifiedName("android.os", "AsyncTask") }
}

/** The constructor or initializer method of the `android.os.AsyncTask` class. */
private class AsyncTaskInit extends Callable {
  AsyncTaskInit() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof AsyncTask and
    (this instanceof Constructor or this instanceof InitializerMethod)
  }
}

/** A call to the `execute` or `executeOnExecutor` methods of the `android.os.AsyncTask` class. */
private class ExecuteAsyncTaskMethodCall extends MethodCall {
  ExecuteAsyncTaskMethodCall() {
    this.getMethod().hasName(["execute", "executeOnExecutor"]) and
    this.getMethod().getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof
      AsyncTask
  }

  /** Returns the `params` argument of this call. */
  Argument getParamsArgument() { result = this.getAnArgument() and result.isVararg() }
}

/** The `doInBackground` method of the `android.os.AsyncTask` class. */
private class AsyncTaskRunInBackgroundMethod extends Method {
  AsyncTaskRunInBackgroundMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof AsyncTask and
    this.hasName("doInBackground")
  }
}

/** The `onPostExecute` method of the `android.os.AsyncTask` class. */
private class AsyncTaskOnPostExecuteMethod extends Method {
  AsyncTaskOnPostExecuteMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof AsyncTask and
    this.hasName("onPostExecute")
  }
}
