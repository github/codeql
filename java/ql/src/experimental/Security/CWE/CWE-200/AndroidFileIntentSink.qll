/** Provides Android sink models related to file creation. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.frameworks.android.Android
import semmle.code.java.frameworks.android.Intent

/** A sink representing methods creating a file in Android. */
class AndroidFileSink extends DataFlow::Node {
  AndroidFileSink() { sinkNode(this, "create-file") }
}

/**
 * The Android class `android.os.AsyncTask` for running tasks off the UI thread to achieve
 * better user experience.
 */
class AsyncTask extends RefType {
  AsyncTask() { this.hasQualifiedName("android.os", "AsyncTask") }
}

/** The `execute` method of Android `AsyncTask`. */
class AsyncTaskExecuteMethod extends Method {
  AsyncTaskExecuteMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof AsyncTask and
    this.getName() = "execute"
  }

  int getParamIndex() { result = 0 }
}

/** The `executeOnExecutor` method of Android `AsyncTask`. */
class AsyncTaskExecuteOnExecutorMethod extends Method {
  AsyncTaskExecuteOnExecutorMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof AsyncTask and
    this.getName() = "executeOnExecutor"
  }

  int getParamIndex() { result = 1 }
}

/** The `doInBackground` method of Android `AsyncTask`. */
class AsyncTaskRunInBackgroundMethod extends Method {
  AsyncTaskRunInBackgroundMethod() {
    this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() instanceof AsyncTask and
    this.getName() = "doInBackground"
  }
}

/** The service start method of Android context. */
class ContextStartServiceMethod extends Method {
  ContextStartServiceMethod() {
    this.getName() = ["startService", "startForegroundService"] and
    this.getDeclaringType().getASupertype*() instanceof TypeContext
  }
}

/** The `onStartCommand` method of Android service. */
class ServiceOnStartCommandMethod extends Method {
  ServiceOnStartCommandMethod() {
    this.hasName("onStartCommand") and
    this.getDeclaringType() instanceof AndroidService
  }
}
