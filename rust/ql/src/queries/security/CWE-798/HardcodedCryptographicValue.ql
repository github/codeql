/**
 * @name Hard-coded cryptographic value
 * @description Using hardcoded keys, passwords, salts or initialization
 *              vectors is not secure.
 * @kind problem
 * @problem.severity warning
 * @security-severity TODO
 * @precision high
 * @id rust/hardcoded-crytographic-value
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 *       external/cwe/cwe-1204
 */

import rust

from Locatable e
where none()
select e, ""
