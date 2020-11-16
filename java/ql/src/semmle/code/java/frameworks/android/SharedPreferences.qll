/* Definitions related to `android.content.SharedPreferences`. */
import semmle.code.java.Type

/* The interface `android.content.SharedPreferences` */
library class TypeSharedPreferences extends Interface {
  TypeSharedPreferences() { hasQualifiedName("android.content", "SharedPreferences") }
}

/* The class `androidx.security.crypto.EncryptedSharedPreferences`, which implements `SharedPreferences` with encryption support. */
library class TypeEncryptedSharedPreferences extends Class {
  TypeEncryptedSharedPreferences() {
    hasQualifiedName("androidx.security.crypto", "EncryptedSharedPreferences")
  }
}

/* A getter method of `android.content.SharedPreferences`. */
library class SharedPreferencesGetMethod extends Method {
  SharedPreferencesGetMethod() {
    getDeclaringType() instanceof TypeSharedPreferences and
    getName().matches("get%")
  }
}

/* Returns `android.content.SharedPreferences.Editor` from the `edit` call of `android.content.SharedPreferences`. */
library class SharedPreferencesGetEditorMethod extends Method {
  SharedPreferencesGetEditorMethod() {
    getDeclaringType() instanceof TypeSharedPreferences and
    hasName("edit") and
    getReturnType() instanceof TypeSharedPreferencesEditor
  }
}

/* Definitions related to `android.content.SharedPreferences.Editor`. */
library class TypeSharedPreferencesEditor extends Interface {
  TypeSharedPreferencesEditor() { hasQualifiedName("android.content", "SharedPreferences$Editor") }
}

/* A setter method for `android.content.SharedPreferences`. */
library class SharedPreferencesSetMethod extends Method {
  SharedPreferencesSetMethod() {
    getDeclaringType() instanceof TypeSharedPreferencesEditor and
    getName().matches("put%")
  }
}

/* A setter method for `android.content.SharedPreferences`. */
library class SharedPreferencesStoreMethod extends Method {
  SharedPreferencesStoreMethod() {
    getDeclaringType() instanceof TypeSharedPreferencesEditor and
    hasName(["commit", "apply"])
  }
}
