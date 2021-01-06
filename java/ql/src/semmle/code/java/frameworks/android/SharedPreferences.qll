/** Provides classes related to `android.content.SharedPreferences`. */

import java

/** Definitions related to `android.content.SharedPreferences`. */
module SharedPreferences {
  /** The interface `android.content.SharedPreferences` */
  class TypePrefs extends Interface {
    TypePrefs() { hasQualifiedName("android.content", "SharedPreferences") }
  }

  /** The class `androidx.security.crypto.EncryptedSharedPreferences`, which implements `SharedPreferences` with encryption support. */
  class TypeEncryptedPrefs extends Class {
    TypeEncryptedPrefs() {
      hasQualifiedName("androidx.security.crypto", "EncryptedSharedPreferences")
    }
  }

  /** The create method of `androidx.security.crypto.EncryptedSharedPreferences` */
  class CreateEncryptedPrefsMethod extends Method {
    CreateEncryptedPrefsMethod() {
      getDeclaringType() instanceof TypeEncryptedPrefs and
      hasName("create")
    }
  }

  /** A getter method of `android.content.SharedPreferences`. */
  class GetPreferenceMethod extends Method {
    GetPreferenceMethod() {
      getDeclaringType() instanceof TypePrefs and
      getName().matches("get%")
    }
  }

  /** Returns `android.content.SharedPreferences.Editor` from the `edit` call of `android.content.SharedPreferences`. */
  class GetEditorMethod extends Method {
    GetEditorMethod() {
      getDeclaringType() instanceof TypePrefs and
      hasName("edit") and
      getReturnType() instanceof TypeEditor
    }
  }

  /** Definitions related to `android.content.SharedPreferences.Editor`. */
  class TypeEditor extends Interface {
    TypeEditor() { hasQualifiedName("android.content", "SharedPreferences$Editor") }
  }

  /** A setter method for `android.content.SharedPreferences`. */
  class SetPreferenceMethod extends Method {
    SetPreferenceMethod() {
      getDeclaringType() instanceof TypeEditor and
      getName().matches("put%")
    }
  }

  /** A setter method for `android.content.SharedPreferences`. */
  class StorePreferenceMethod extends Method {
    StorePreferenceMethod() {
      getDeclaringType() instanceof TypeEditor and
      hasName(["commit", "apply"])
    }
  }
}
