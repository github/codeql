/**
 * @name Acronyms should be PascalCase/camelCase.
 * @description Acronyms should be PascalCase/camelCase instead of upper-casing all the letters.
 * @kind problem
 * @problem.severity warning
 * @id ql/acronyms-should-be-pascal-case
 * @tags correctness
 *       maintainability
 * @precision high
 */

import ql
import codeql_ql.style.AcronymsShouldBeCamelCaseQuery

from string name, AstNode node
where shouldBePascalCased(name, node, _)
select node, "Acronyms should be PascalCase/camelCase"
