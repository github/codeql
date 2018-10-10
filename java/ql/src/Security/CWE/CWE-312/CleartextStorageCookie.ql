/**
 * @name Cleartext storage of sensitive information in cookie
 * @description Storing sensitive information in cleartext can expose it to an attacker.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/cleartext-storage-in-cookie
 * @tags security
 *       external/cwe/cwe-315
 */

import java
import SensitiveStorage

from SensitiveSource data, Cookie s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsToCached(input) and
  // Exclude results in test code.
  not testMethod(store.getEnclosingCallable()) and
  not testMethod(data.getEnclosingCallable())
select store, "Cookie $@ containing $@ is stored here. Data was added $@.", s, s.toString(), data,
  "sensitive data", input, "here"
