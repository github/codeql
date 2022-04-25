/** Provides classes related to `android.content.SharedPreferences`. */

import java
private import semmle.code.java.dataflow.ExternalFlow

/** The interface `android.content.SharedPreferences`. */
class SharedPreferences extends Interface {
  SharedPreferences() { this.hasQualifiedName("android.content", "SharedPreferences") }
}

/** The class `androidx.security.crypto.EncryptedSharedPreferences`, which implements `SharedPreferences` with encryption support. */
class EncryptedSharedPreferences extends Class {
  EncryptedSharedPreferences() {
    this.hasQualifiedName("androidx.security.crypto", "EncryptedSharedPreferences")
  }
}

/** The `create` method of `androidx.security.crypto.EncryptedSharedPreferences`. */
class CreateEncryptedSharedPreferencesMethod extends Method {
  CreateEncryptedSharedPreferencesMethod() {
    this.getDeclaringType() instanceof EncryptedSharedPreferences and
    this.hasName("create")
  }
}

/** The method `android.content.SharedPreferences::edit`, which returns an `android.content.SharedPreferences.Editor`. */
class GetSharedPreferencesEditorMethod extends Method {
  GetSharedPreferencesEditorMethod() {
    this.getDeclaringType() instanceof SharedPreferences and
    this.hasName("edit") and
    this.getReturnType() instanceof SharedPreferencesEditor
  }
}

/** The interface `android.content.SharedPreferences.Editor`. */
class SharedPreferencesEditor extends Interface {
  SharedPreferencesEditor() { this.hasQualifiedName("android.content", "SharedPreferences$Editor") }
}

/**
 * A method that updates a key-value pair in a
 * `android.content.SharedPreferences` through a `SharedPreferences.Editor`. The
 * value is not written until a `StorePreferenceMethod` is called.
 */
class PutSharedPreferenceMethod extends Method {
  PutSharedPreferenceMethod() {
    this.getDeclaringType() instanceof SharedPreferencesEditor and
    this.getName().matches("put%")
  }
}

/** A method on `SharedPreferences.Editor` that writes the pending changes to the underlying `android.content.SharedPreferences`. */
class StoreSharedPreferenceMethod extends Method {
  StoreSharedPreferenceMethod() {
    this.getDeclaringType() instanceof SharedPreferencesEditor and
    this.hasName(["commit", "apply"])
  }
}

private class SharedPreferencesSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.content;SharedPreferences$Editor;true;clear;;;Argument[-1];ReturnValue;value",
        "android.content;SharedPreferences$Editor;true;putBoolean;;;Argument[-1];ReturnValue;value",
        "android.content;SharedPreferences$Editor;true;putFloat;;;Argument[-1];ReturnValue;value",
        "android.content;SharedPreferences$Editor;true;putInt;;;Argument[-1];ReturnValue;value",
        "android.content;SharedPreferences$Editor;true;putLong;;;Argument[-1];ReturnValue;value",
        "android.content;SharedPreferences$Editor;true;putString;;;Argument[-1];ReturnValue;value",
        "android.content;SharedPreferences$Editor;true;putStringSet;;;Argument[-1];ReturnValue;value",
        "android.content;SharedPreferences$Editor;true;remove;;;Argument[-1];ReturnValue;value"
      ]
  }
}
