/**
 * @name PHP 8.0+ Named Arguments Query Test
 * @description Test queries for named arguments feature detection
 * @kind table
 * @problem.severity recommendation
 */

import php
import codeql.php.ast.PHP8NamedArguments

// Test 1: Find all calls with named arguments
from Call call
where callHasNamedArguments(call)
select call.getLocation().getStartLine() as line,
       call.toString() as callExpr,
       "has_named_arguments" as testType
