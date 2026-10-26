/**
 * @name Cleartext storage of sensitive information using `SharedPreferences` on Android
 * @description Cleartext Storage of Sensitive Information using
 *              SharedPreferences on Android allows access for users with root
 *              privileges or unexpected exposure from chained vulnerabilities.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id java/android/cleartext-storage-shared-prefs
 * @tags security
 *       external/cwe/cwe-312
 */

import java
import semmle.code.java.security.CleartextStorageSharedPrefsQuery

from SensitiveSource data, SharedPreferencesEditorMethodCall s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsTo(input)
select store, "This stores the 'SharedPreferences' class $@ containing $@ which $@.", s,
  s.toString(), data, "sensitive data", input, "was set as a shared preference"
