import semmle.code.java.Type

/* Definitions related to `android.content.SharedPreferences`. */
module SharedPreferences {
  /* The interface `android.content.SharedPreferences` */
  class TypeSharedPreferences extends Interface {
    TypeSharedPreferences() { hasQualifiedName("android.content", "SharedPreferences") }
  }

  /* The class `androidx.security.crypto.EncryptedSharedPreferences`, which implements `SharedPreferences` with encryption support. */
  class TypeEncryptedSharedPreferences extends Class {
    TypeEncryptedSharedPreferences() {
      hasQualifiedName("androidx.security.crypto", "EncryptedSharedPreferences")
    }
  }

  /* The create method of `androidx.security.crypto.EncryptedSharedPreferences` */
  class EncryptedSharedPrefsCreateMethod extends Method {
    EncryptedSharedPrefsCreateMethod() {
      getDeclaringType() instanceof TypeEncryptedSharedPreferences and
      hasName("create")
    }
  }

  /* A getter method of `android.content.SharedPreferences`. */
  class SharedPreferencesGetMethod extends Method {
    SharedPreferencesGetMethod() {
      getDeclaringType() instanceof TypeSharedPreferences and
      getName().matches("get%")
    }
  }

  /* Returns `android.content.SharedPreferences.Editor` from the `edit` call of `android.content.SharedPreferences`. */
  class SharedPreferencesGetEditorMethod extends Method {
    SharedPreferencesGetEditorMethod() {
      getDeclaringType() instanceof TypeSharedPreferences and
      hasName("edit") and
      getReturnType() instanceof TypeSharedPreferencesEditor
    }
  }

  /* Definitions related to `android.content.SharedPreferences.Editor`. */
  class TypeSharedPreferencesEditor extends Interface {
    TypeSharedPreferencesEditor() {
      hasQualifiedName("android.content", "SharedPreferences$Editor")
    }
  }

  /* A setter method for `android.content.SharedPreferences`. */
  class SharedPreferencesSetMethod extends Method {
    SharedPreferencesSetMethod() {
      getDeclaringType() instanceof TypeSharedPreferencesEditor and
      getName().matches("put%")
    }
  }

  /* A setter method for `android.content.SharedPreferences`. */
  class SharedPreferencesStoreMethod extends Method {
    SharedPreferencesStoreMethod() {
      getDeclaringType() instanceof TypeSharedPreferencesEditor and
      hasName(["commit", "apply"])
    }
  }
}
