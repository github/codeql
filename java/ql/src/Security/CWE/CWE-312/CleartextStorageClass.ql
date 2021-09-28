/**
 * @name Cleartext storage of sensitive information using storable class
 * @description Storing sensitive information in cleartext can expose it to an attacker.
 * @kind problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @precision medium
 * @id java/cleartext-storage-in-class
 * @tags security
 *       external/cwe/cwe-499
 *       external/cwe/cwe-312
 */

import java
import semmle.code.java.security.CleartextStorageClassQuery

from SensitiveSource data, ClassStore s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsTo(input)
select store, "Storable class $@ containing $@ is stored here. Data was added $@.", s, s.toString(),
  data, "sensitive data", input, "here"
