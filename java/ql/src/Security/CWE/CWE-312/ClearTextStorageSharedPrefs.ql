/**
 * @name Cleartext storage of sensitive information using `SharedPreferences` on Android
 * @description Cleartext Storage of Sensitive Information using SharedPreferences on Android allows user with root privileges to access or unexpected exposure from chained vulnerabilities.
 * @kind problem
 * @id java/android/cleartext-storage-shared-prefs
 * @tags security
 *       external/cwe/cwe-312
 */

import java
import SensitiveStorage

from SensitiveSource data, SharedPreferencesEditor s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsToCached(input) and
  // Exclude results in test code.
  not testMethod(store.getEnclosingCallable()) and
  not testMethod(data.getEnclosingCallable())
select store, "'SharedPreferences' class $@ containing $@ is stored here. Data was added $@.", s,
  s.toString(), data, "sensitive data", input, "here"
