/** Provides classes and predicates to reason about cleartext storage in Android's SharedPreferences. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.android.SharedPreferences
import semmle.code.java.security.CleartextStorageQuery

private class SharedPrefsCleartextStorageSink extends CleartextStorageSink {
  SharedPrefsCleartextStorageSink() {
    exists(MethodAccess m |
      m.getMethod() instanceof PutSharedPreferenceMethod and
      this.asExpr() = m.getArgument(1)
    )
  }
}

/**
 * The call to get a `SharedPreferences.Editor` object, which can set shared preferences and be
 * stored to the device.
 */
class SharedPreferencesEditorMethodAccess extends Storable, MethodAccess {
  SharedPreferencesEditorMethodAccess() {
    this.getMethod() instanceof GetSharedPreferencesEditorMethod and
    not DataFlow::localExprFlow(any(MethodAccess ma |
        ma.getMethod() instanceof CreateEncryptedSharedPreferencesMethod
      ), this.getQualifier())
  }

  /** Gets an input, for example `password` in `editor.putString("password", password);`. */
  override Expr getAnInput() {
    exists(SharedPreferencesFlowConfig conf, DataFlow::Node editor |
      sharedPreferencesInput(editor, result) and
      conf.hasFlow(DataFlow::exprNode(this), editor)
    )
  }

  /** Gets a store, for example `editor.commit();`. */
  override Expr getAStore() {
    exists(SharedPreferencesFlowConfig conf, DataFlow::Node editor |
      sharedPreferencesStore(editor, result) and
      conf.hasFlow(DataFlow::exprNode(this), editor)
    )
  }
}

/**
 * Holds if `input` is the second argument of a setter method
 * called on `editor`, which is an instance of `SharedPreferences$Editor`.
 */
private predicate sharedPreferencesInput(DataFlow::Node editor, Expr input) {
  exists(MethodAccess m |
    m.getMethod() instanceof PutSharedPreferenceMethod and
    input = m.getArgument(1) and
    editor.asExpr() = m.getQualifier()
  )
}

/**
 * Holds if `m` is a store method called on `editor`,
 * which is an instance of `SharedPreferences$Editor`.
 */
private predicate sharedPreferencesStore(DataFlow::Node editor, MethodAccess m) {
  m.getMethod() instanceof StoreSharedPreferenceMethod and
  editor.asExpr() = m.getQualifier()
}

/** Flow from `SharedPreferences.Editor` to either a setter or a store method. */
private class SharedPreferencesFlowConfig extends DataFlow::Configuration {
  SharedPreferencesFlowConfig() { this = "SharedPreferencesFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof SharedPreferencesEditorMethodAccess
  }

  override predicate isSink(DataFlow::Node sink) {
    sharedPreferencesInput(sink, _) or
    sharedPreferencesStore(sink, _)
  }
}
