import java
import semmle.code.java.dataflow.FlowSteps

class TypeIntent extends Class {
  TypeIntent() { hasQualifiedName("android.content", "Intent") }
}

class TypeActivity extends Class {
  TypeActivity() { hasQualifiedName("android.app", "Activity") }
}

class TypeContext extends RefType {
  TypeContext() { hasQualifiedName("android.content", "Context") }
}

class TypeBroadcastReceiver extends Class {
  TypeBroadcastReceiver() { hasQualifiedName("android.content", "BroadcastReceiver") }
}

class AndroidGetIntentMethod extends Method {
  AndroidGetIntentMethod() { hasName("getIntent") and getDeclaringType() instanceof TypeActivity }
}

class AndroidReceiveIntentMethod extends Method {
  AndroidReceiveIntentMethod() {
    hasName("onReceive") and getDeclaringType() instanceof TypeBroadcastReceiver
  }
}

class ContextStartActivityMethod extends Method {
  ContextStartActivityMethod() {
    (hasName("startActivity") or hasName("startActivities")) and
    getDeclaringType() instanceof TypeContext
  }
}

class IntentGetExtraMethod extends Method, TaintPreservingCallable {
  IntentGetExtraMethod() {
    (getName().regexpMatch("get\\w+Extra") or hasName("getExtras")) and
    getDeclaringType() instanceof TypeIntent
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}

/** A getter on `android.os.BaseBundle` or `android.os.Bundle`. */
class BundleGetterMethod extends Method, TaintPreservingCallable {
  BundleGetterMethod() {
    getDeclaringType().hasQualifiedName("android.os", ["BaseBundle", "Bundle"]) and
    getName().matches("get%")
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}
