/**
 * @name Misspelling
 * @description Names and comments in QL should use US spelling and avoid common misspellings.
 * @kind problem
 * @problem.severity warning
 * @id ql/misspelling
 * @tags maintainability
 * @precision very-high
 */

import ql
import codeql_ql.style.MisspellingQuery

from AstNode node, string nodeKind, string wrong, string right, string mistake
where misspelled_element(node, nodeKind, wrong, right, mistake)
select node,
  "This " + nodeKind + " contains the " + mistake + " '" + wrong + "', which should instead be '" +
    right + "'."
