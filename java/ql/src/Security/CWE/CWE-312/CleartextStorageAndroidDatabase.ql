/**
 * @name Cleartext storage of sensitive information using a local database on Android
 * @description Cleartext Storage of Sensitive Information using
 *              a local database on Android allows access for users with root
 *              privileges or unexpected exposure from chained vulnerabilities.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id java/android/cleartext-storage-database
 * @tags security
 *       external/cwe/cwe-312
 */

import java
import semmle.code.java.security.CleartextStorageAndroidDatabaseQuery

from SensitiveSource data, LocalDatabaseOpenMethodCall s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsTo(input)
select store, "This stores data in a SQLite database $@ containing $@ which was $@.", s,
  s.toString(), data, "sensitive data", input, "previously added"
