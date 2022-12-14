/**
 * @name Cleartext storage of sensitive information using 'Properties' class
 * @description Storing sensitive information in cleartext can expose it to an attacker.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id java/cleartext-storage-in-properties
 * @tags security
 *       external/cwe/cwe-313
 */

import java
import semmle.code.java.security.CleartextStoragePropertiesQuery

from SensitiveSource data, Properties s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsTo(input)
select store, "This stores 'Properties' class $@ containing $@ which was $@.", s, s.toString(),
  data, "sensitive data", input, "previously added"
