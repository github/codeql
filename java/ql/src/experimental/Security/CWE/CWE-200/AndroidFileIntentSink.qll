/** Provides Android sink models related to file creation. */
deprecated module;

import java
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.frameworks.android.Android
import semmle.code.java.frameworks.android.Intent

/** A sink representing methods creating a file in Android. */
class AndroidFileSink extends DataFlow::Node {
  AndroidFileSink() { sinkNode(this, "path-injection") }
}

/**
 * The Android class `android.os.AsyncTask` for running tasks off the UI thread to achieve
 * better user experience.
 */
class AsyncTask extends RefType {
  AsyncTask() { this.hasQualifiedName("android.os", "AsyncTask") }
}

/** The `execute` or `executeOnExecutor` method of Android's `AsyncTask` class. */
class ExecuteAsyncTaskMethod extends Method {
  int paramIndex;

  ExecuteAsyncTaskMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof AsyncTask and
    (
      this.getName() = "execute" and paramIndex = 0
      or
      this.getName() = "executeOnExecutor" and paramIndex = 1
    )
  }

  int getParamIndex() { result = paramIndex }
}

/** The `doInBackground` method of Android's `AsyncTask` class. */
class AsyncTaskRunInBackgroundMethod extends Method {
  AsyncTaskRunInBackgroundMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof AsyncTask and
    this.getName() = "doInBackground"
  }
}

/** The service start method of Android's `Context` class. */
class ContextStartServiceMethod extends Method {
  ContextStartServiceMethod() {
    this.getName() = ["startService", "startForegroundService"] and
    this.getDeclaringType().getAnAncestor() instanceof TypeContext
  }
}

/** The `onStartCommand` method of Android's `Service` class. */
class ServiceOnStartCommandMethod extends Method {
  ServiceOnStartCommandMethod() {
    this.hasName("onStartCommand") and
    this.getDeclaringType() instanceof AndroidService
  }
}
