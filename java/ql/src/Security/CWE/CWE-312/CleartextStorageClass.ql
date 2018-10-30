/**
 * @name Cleartext storage of sensitive information using storable class
 * @description Storing sensitive information in cleartext can expose it to an attacker.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/cleartext-storage-in-class
 * @tags security
 *       external/cwe/cwe-499
 *       external/cwe/cwe-312
 */

import java
import SensitiveStorage

from SensitiveSource data, ClassStore s, Expr input, Expr store
where
  input = s.getAnInput() and
  store = s.getAStore() and
  data.flowsToCached(input) and
  // Exclude results in test code.
  not testMethod(store.getEnclosingCallable()) and
  not testMethod(data.getEnclosingCallable())
select store, "Storable class $@ containing $@ is stored here. Data was added $@.", s, s.toString(),
  data, "sensitive data", input, "here"
