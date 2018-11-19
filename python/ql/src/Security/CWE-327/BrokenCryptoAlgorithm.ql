/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id py/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */
import python
import semmle.python.security.SensitiveData
import semmle.python.security.Crypto

from SensitiveDataSource src, WeakCryptoSink sink
where src.flowsToSink(sink)

select sink, "Sensitive data from $@ is used in a broken or weak cryptographic algorithm.", src , src.toString()
