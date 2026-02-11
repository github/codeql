/** Provides classes and predicates to reason about cleartext storage in Android's SharedPreferences. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.android.SharedPreferences
import semmle.code.java.security.CleartextStorageQuery
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dataflow.FlowSources

private class SharedPrefsCleartextStorageSink extends CleartextStorageSink {
  SharedPrefsCleartextStorageSink() {
    exists(MethodCall m |
      m.getMethod() instanceof PutSharedPreferenceMethod and
      this.asExpr() = m.getArgument(1)
    )
  }
}

/**
 * The call to get a `SharedPreferences.Editor` object, which can set shared preferences and be
 * stored to the device.
 */
class SharedPreferencesEditorMethodCall extends Storable, MethodCall {
  SharedPreferencesEditorMethodCall() {
    this.getMethod() instanceof GetSharedPreferencesEditorMethod and
    not DataFlow::localExprFlow(any(MethodCall ma |
        ma.getMethod() instanceof CreateEncryptedSharedPreferencesMethod
      ), this.getQualifier())
  }

  /** Gets an input, for example `password` in `editor.putString("password", password);`. */
  override Expr getAnInput() {
    exists(DataFlow::Node editor |
      sharedPreferencesInput(editor, result) and
      SharedPreferencesFlow::flow(DataFlow::exprNode(this), editor)
    )
  }

  /** Gets a store, for example `editor.commit();`. */
  override Expr getAStore() {
    exists(DataFlow::Node editor |
      sharedPreferencesStore(editor, result) and
      SharedPreferencesFlow::flow(DataFlow::exprNode(this), editor)
    )
  }
}

/**
 * Holds if `input` is the second argument of a setter method
 * called on `editor`, which is an instance of `SharedPreferences$Editor`.
 */
private predicate sharedPreferencesInput(DataFlow::Node editor, Expr input) {
  exists(MethodCall m |
    m.getMethod() instanceof PutSharedPreferenceMethod and
    input = m.getArgument(1) and
    editor.asExpr() = m.getQualifier().getUnderlyingExpr()
  )
}

/**
 * Holds if `m` is a store method called on `editor`,
 * which is an instance of `SharedPreferences$Editor`.
 */
private predicate sharedPreferencesStore(DataFlow::Node editor, MethodCall m) {
  m.getMethod() instanceof StoreSharedPreferenceMethod and
  editor.asExpr() = m.getQualifier().getUnderlyingExpr()
}

/**
 * A shared preferences editor method call source node.
 */
private class SharedPreferencesEditorMethodCallSource extends ApiSourceNode {
  SharedPreferencesEditorMethodCallSource() {
    this.asExpr() instanceof SharedPreferencesEditorMethodCall
  }
}

/**
 * A shared preferences sink node.
 */
private class SharedPreferencesSink extends ApiSinkNode {
  SharedPreferencesSink() {
    sharedPreferencesInput(this, _) or
    sharedPreferencesStore(this, _)
  }
}

/** Flow from `SharedPreferences.Editor` to either a setter or a store method. */
private module SharedPreferencesFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof SharedPreferencesEditorMethodCallSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof SharedPreferencesSink }
}

private module SharedPreferencesFlow = DataFlow::Global<SharedPreferencesFlowConfig>;
