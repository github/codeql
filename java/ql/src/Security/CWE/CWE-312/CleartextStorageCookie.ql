/**
 * @name Cleartext storage of sensitive information in cookie
 * @description Storing sensitive information in cleartext can expose it to an attacker.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision high
 * @id java/cleartext-storage-in-cookie
 * @tags security
 *       external/cwe/cwe-315
 */

import java
import semmle.code.java.security.CleartextStorageCookieQuery

from SensitiveSource data, Cookie s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsTo(input)
select store, "Cookie $@ containing $@ is stored here. Data was added $@.", s, s.toString(), data,
  "sensitive data", input, "here"
