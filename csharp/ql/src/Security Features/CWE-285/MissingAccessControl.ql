/**
 * @name Missing function level access control
 * @description ... TODO
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cs/web/missing-function-level-access-control
 * @tags security
 *       external/cwe/cwe-285
 */

import csharp
import semmle.code.csharp.security.auth.MissingFunctionLevelAccessControlQuery

from Method m
where missingAuth(m)
select m, "This action is missing an authorization check."
