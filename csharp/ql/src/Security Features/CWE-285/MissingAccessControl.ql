/**
 * @name Missing function level access control
 * @description Sensitive actions should have authorization checks to prevent them from being used by malicious actors.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cs/web/missing-function-level-access-control
 * @tags security
 *       external/cwe/cwe-285
 *       external/cwe/cwe-284
 *       external/cwe/cwe-862
 */

import csharp
import semmle.code.csharp.security.auth.MissingFunctionLevelAccessControlQuery

from Method m
where missingAuth(m)
select m, "This action is missing an authorization check."
