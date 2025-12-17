/**
 * @name Readonly Property Analysis
 * @description Detects readonly properties in the codebase
 * @kind problem
 * @problem.severity note
 * @id php/readonly-property-analysis
 * @tags php8.2 language-feature readonly
 */

import php
import codeql.php.ast.PHP8ReadonlyProperties

from ReadonlyProperty prop
select prop, "Readonly property detected"
