/**
 * @name PHP 8.0+ Named Arguments Security Test
 * @description Test queries for security analysis using named arguments
 * @kind table
 * @problem.severity warning
 */

import php
import codeql.php.ast.PHP8NamedArguments

// Test: Find method calls on request object with named arguments (potential security concern)
from Call call, Expr arg
where call.getObject().(Variable).getName() = "$request" and
      call.getMethodName() = "input" and
      call.hasNamedArguments() and
      arg = call.getArgumentByName("key")
select call.getLocation().getStartLine() as line,
       call.toString() as callExpr,
       arg.toString() as argumentValue,
       "request_input_named_arg" as testType
