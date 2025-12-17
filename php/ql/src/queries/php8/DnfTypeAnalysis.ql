/**
 * @name Disjunctive Normal Form (DNF) Type Analysis
 * @description Detects union and intersection types in the codebase
 * @kind problem
 * @problem.severity note
 * @id php/dnf-type-analysis
 * @tags php8.2 language-feature types
 */

import php
import codeql.php.ast.PHP8DnfTypes

from PhpUnionType unionType
select unionType, "Union type with " + unionType.getNumComponents() + " components"
