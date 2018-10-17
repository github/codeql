/**
 * @name Cleartext storage of sensitive information using 'Properties' class
 * @description Storing sensitive information in cleartext can expose it to an attacker.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/cleartext-storage-in-properties
 * @tags security
 *       external/cwe/cwe-313
 */

import java
import SensitiveStorage

from SensitiveSource data, Properties s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsToCached(input) and
  // Exclude results in test code.
  not testMethod(store.getEnclosingCallable()) and
  not testMethod(data.getEnclosingCallable())
select store, "'Properties' class $@ containing $@ is stored here. Data was added $@.", s,
  s.toString(), data, "sensitive data", input, "here"
