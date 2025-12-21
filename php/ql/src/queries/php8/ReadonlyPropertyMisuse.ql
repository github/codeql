/**
 * @name Readonly Property Misuse Detection
 * @description Detects readonly properties that may need initialization
 * @kind problem
 * @problem.severity warning
 * @id php/readonly-property-misuse
 * @tags php8.2 correctness
 */

import php
import codeql.php.ast.PHP8ReadonlyProperties

from ReadonlyProperty prop
select prop, "Readonly property detected - ensure it is initialized in constructor"
