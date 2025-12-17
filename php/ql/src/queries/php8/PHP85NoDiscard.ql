/**
 * @name PHP 8.5 #[NoDiscard] Attribute Violations
 * @description Detects functions marked with #[NoDiscard] attribute
 * @kind problem
 * @problem.severity warning
 * @id php/nodiscard-violation
 * @tags php85 attributes best-practices
 */

import php
import codeql.php.ast.PHP85NoDiscard

from NoDiscardFunction func
select func, "Function marked with #[NoDiscard] attribute: " + func.getFunctionName()
