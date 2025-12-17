/**
 * @name Complex DNF Type Usage
 * @description Identifies complex union and intersection types
 * @kind problem
 * @problem.severity note
 * @id php/complex-dnf-type-usage
 * @tags php8.2 maintainability
 */

import php
import codeql.php.ast.PHP8DnfTypes

from PhpUnionType t
where t.getNumComponents() > 3
select t, "Complex union type with " + t.getNumComponents() + " components. Consider simplifying."
