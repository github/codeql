/**
 * @name Cleartext storage of sensitive information in the Android filesystem
 * @description Cleartext storage of sensitive information in the Android filesystem
 *              allows access for users with root privileges or unexpected exposure
 *              from chained vulnerabilities.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id java/android/cleartext-storage-filesystem
 * @tags security
 *       external/cwe/cwe-312
 */

import java
import semmle.code.java.security.CleartextStorageAndroidFilesystemQuery

from SensitiveSource data, LocalFileOpenCall s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsTo(input)
select store, "Local file $@ containing $@ is stored $@. Data was added $@.", s, s.toString(), data,
  "sensitive data", store, "here", input, "here"
