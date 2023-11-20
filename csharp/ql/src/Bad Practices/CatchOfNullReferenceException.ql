/**
 * @name Poor error handling: catch of NullReferenceException
 * @description Finds catch clauses that catch NullReferenceException
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/catch-nullreferenceexception
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-395
 */

import csharp

from SpecificCatchClause scc
where scc.getCaughtExceptionType().hasFullyQualifiedName("System", "NullReferenceException")
select scc, "Poor error handling: try to fix the cause of the 'NullReferenceException'."
