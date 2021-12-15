/**
 * @name Cleartext storage of sensitive information using `SharedPreferences` on Android
 * @description Cleartext Storage of Sensitive Information using
 *              SharedPreferences on Android allows access for users with root
 *              privileges or unexpected exposure from chained vulnerabilities.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/android/cleartext-storage-shared-prefs
 * @tags security
 *       external/cwe/cwe-312
 */

import java
import semmle.code.java.dataflow.DataFlow4
import semmle.code.java.dataflow.DataFlow5
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.frameworks.android.SharedPreferences
import semmle.code.java.security.SensitiveActions

/** Holds if the method call is a setter method of `SharedPreferences`. */
private predicate sharedPreferencesInput(DataFlow::Node sharedPrefs, Expr input) {
  exists(MethodAccess m |
    m.getMethod() instanceof PutSharedPreferenceMethod and
    input = m.getArgument(1) and
    not exists(EncryptedValueFlowConfig conf | conf.hasFlow(_, DataFlow::exprNode(input))) and
    sharedPrefs.asExpr() = m.getQualifier()
  )
}

/** Holds if the method call is the store method of `SharedPreferences`. */
private predicate sharedPreferencesStore(DataFlow::Node sharedPrefs, Expr store) {
  exists(MethodAccess m |
    m.getMethod() instanceof StoreSharedPreferenceMethod and
    store = m and
    sharedPrefs.asExpr() = m.getQualifier()
  )
}

/** Flow from `SharedPreferences` to either a setter or a store method. */
class SharedPreferencesFlowConfig extends DataFlow::Configuration {
  SharedPreferencesFlowConfig() {
    this = "CleartextStorageSharedPrefs::SharedPreferencesFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof SharedPreferencesEditorMethodAccess
  }

  override predicate isSink(DataFlow::Node sink) {
    sharedPreferencesInput(sink, _) or
    sharedPreferencesStore(sink, _)
  }
}

/**
 * Method call of encrypting sensitive information.
 * As there are various implementations of encryption (reversible and non-reversible) from both JDK and third parties, this class simply checks method name to take a best guess to reduce false positives.
 */
class EncryptedSensitiveMethodAccess extends MethodAccess {
  EncryptedSensitiveMethodAccess() {
    this.getMethod().getName().toLowerCase().matches(["%encrypt%", "%hash%"])
  }
}

/** Flow configuration of encrypting sensitive information. */
class EncryptedValueFlowConfig extends DataFlow5::Configuration {
  EncryptedValueFlowConfig() { this = "CleartextStorageSharedPrefs::EncryptedValueFlowConfig" }

  override predicate isSource(DataFlow5::Node src) {
    exists(EncryptedSensitiveMethodAccess ema | src.asExpr() = ema)
  }

  override predicate isSink(DataFlow5::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof PutSharedPreferenceMethod and
      sink.asExpr() = ma.getArgument(1)
    )
  }
}

/** Flow from the create method of `androidx.security.crypto.EncryptedSharedPreferences` to its instance. */
private class EncryptedSharedPrefFlowConfig extends DataFlow4::Configuration {
  EncryptedSharedPrefFlowConfig() {
    this = "CleartextStorageSharedPrefs::EncryptedSharedPrefFlowConfig"
  }

  override predicate isSource(DataFlow4::Node src) {
    src.asExpr().(MethodAccess).getMethod() instanceof CreateEncryptedSharedPreferencesMethod
  }

  override predicate isSink(DataFlow4::Node sink) {
    sink.asExpr().getType() instanceof SharedPreferences
  }
}

/** The call to get a `SharedPreferences.Editor` object, which can set shared preferences or be stored to device. */
class SharedPreferencesEditorMethodAccess extends MethodAccess {
  SharedPreferencesEditorMethodAccess() {
    this.getMethod() instanceof GetSharedPreferencesEditorMethod and
    not exists(
      EncryptedSharedPrefFlowConfig config // not exists `SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(...)`
    |
      config.hasFlow(_, DataFlow::exprNode(this.getQualifier()))
    )
  }

  /** Gets an input, for example `password` in `editor.putString("password", password);`. */
  Expr getAnInput() {
    exists(SharedPreferencesFlowConfig conf, DataFlow::Node n |
      sharedPreferencesInput(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }

  /** Gets a store, for example `editor.commit();`. */
  Expr getAStore() {
    exists(SharedPreferencesFlowConfig conf, DataFlow::Node n |
      sharedPreferencesStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}

/**
 * Flow from sensitive expressions to shared preferences.
 * Note it can be merged into `SensitiveSourceFlowConfig` of `Security/CWE/CWE-312/SensitiveStorage.qll` when this query is promoted from the experimental directory.
 */
private class SensitiveSharedPrefsFlowConfig extends TaintTracking::Configuration {
  SensitiveSharedPrefsFlowConfig() {
    this = "CleartextStorageSharedPrefs::SensitiveSharedPrefsFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess m |
      m.getMethod() instanceof PutSharedPreferenceMethod and
      sink.asExpr() = m.getArgument(1)
    )
  }
}

/** Class for shared preferences that may contain 'sensitive' information */
class SensitiveSharedPrefsSource extends Expr {
  SensitiveSharedPrefsSource() {
    // SensitiveExpr is abstract, this lets us inherit from it without
    // being a technical subclass
    this instanceof SensitiveExpr
  }

  /** Holds if this source flows to the `sink`. */
  predicate flowsTo(Expr sink) {
    exists(SensitiveSharedPrefsFlowConfig conf |
      conf.hasFlow(DataFlow::exprNode(this), DataFlow::exprNode(sink))
    )
  }
}

from SensitiveSharedPrefsSource data, SharedPreferencesEditorMethodAccess s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsTo(input)
select store, "'SharedPreferences' class $@ containing $@ is stored here. Data was added $@.", s,
  s.toString(), data, "sensitive data", input, "here"
