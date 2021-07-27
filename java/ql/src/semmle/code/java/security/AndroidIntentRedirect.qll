import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.frameworks.android.Intent

abstract class IntentRedirectSink extends DataFlow::Node { }

abstract class IntentRedirectSanitizer extends DataFlow::Node { }

class IntentRedirectAdditionalTaintStep extends Unit {
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

private class DefaultIntentRedirectSink extends IntentRedirectSink {
  DefaultIntentRedirectSink() {
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      this.asExpr() = ma.getAnArgument() and
      (
        this.asExpr().getType() instanceof TypeIntent
        or
        this.asExpr().getType().(Array).getComponentType() instanceof TypeIntent
      )
    |
      m instanceof StartActivityMethod or
      m instanceof StartServiceMethod or
      m instanceof SendBroadcastMethod
    )
  }
}
