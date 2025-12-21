/**
 * @name PHP 8.0+ Mixed Arguments Query Test
 * @description Test queries for mixed positional and named arguments
 * @kind table
 * @problem.severity recommendation
 */

import php
import codeql.php.ast.PHP8NamedArguments

// Test: Find all calls with mixed positional and named arguments
from Call call
where callHasMixedArguments(call)
select call.getLocation().getStartLine() as line,
       call.toString() as callExpr,
       "mixed_arguments" as testType
