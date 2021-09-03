/** Provides classes and predicates to reason about cleartext storage in Android's SharedPreferences. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow4
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
 * Holds if `input` is not encrypted and is the second argument of a setter method
 * called on `editor`, which is an instance of `SharedPreferences$Editor`
 * .
 */
private predicate sharedPreferencesInput(DataFlow::Node editor, Expr input) {
  exists(MethodAccess m |
    m.getMethod() instanceof PutSharedPreferenceMethod and
    input = m.getArgument(1) and
    not exists(EncryptedValueFlowConfig conf | conf.hasFlow(_, DataFlow::exprNode(input))) and
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

/**
 * Method call for encrypting sensitive information. As there are various implementations of
 * encryption (reversible and non-reversible) from both JDK and third parties, this class simply
 * checks method name to take a best guess to reduce false positives.
 */
private class EncryptedSensitiveMethodAccess extends MethodAccess {
  EncryptedSensitiveMethodAccess() {
    this.getMethod().getName().toLowerCase().matches(["%encrypt%", "%hash%"])
  }
}

/** Flow configuration for encryption methods flowing to inputs of `SharedPreferences`. */
private class EncryptedValueFlowConfig extends DataFlow4::Configuration {
  EncryptedValueFlowConfig() { this = "SensitiveStorage::EncryptedValueFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof EncryptedSensitiveMethodAccess
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SharedPrefsCleartextStorageSink }
}
