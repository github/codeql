/**
 * @name Use of a broken or weak cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can compromise security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id rust/weak-cryptographic-algorithm
 * @tags security
 *       external/cwe/cwe-327
 */

import rust

from int i
where none()
select i
