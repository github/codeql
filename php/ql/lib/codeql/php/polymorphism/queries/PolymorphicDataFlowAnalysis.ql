/**
 * @name Taint Flow Through Polymorphic Dispatch
 * @description Tracks potentially dangerous taint flows through polymorphic method calls
 * @kind problem
 * @problem.severity error
 * @security-severity high
 * @precision medium
 * @tags security
 *       polymorphism
 *       taint-flow
 *       injection
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.DataFlowIntegration

/**
 * Detects SQL injection through polymorphic dispatch
 */
from MethodCall call, Expr userInput
where
  // Method called with user input
  userInput = call.getArgument(0) and
  // Method is polymorphic (could have multiple implementations)
  count(Class c | exists(c.getMethod(call.getMethodName()))) > 1 and
  // User input flows to a query execution
  exists(FunctionCall queryCall |
    queryCall.getFunction().toString() = "query" and
    queryCall.getArgument(0).toString() contains userInput.toString()
  )
select call,
  "User input flows through polymorphic method " + call.getMethodName() +
    " to a SQL query - potential SQL injection vulnerability"

union

/**
 * Detects command injection through polymorphic dispatch
 */
from MethodCall call, Expr userInput
where
  // Method called with user input
  userInput = call.getArgument(0) and
  // Method is polymorphic
  count(Class c | exists(c.getMethod(call.getMethodName()))) > 1 and
  // User input flows to command execution
  exists(FunctionCall execCall |
    (
      execCall.getFunction().toString() = "system" or
      execCall.getFunction().toString() = "exec" or
      execCall.getFunction().toString() = "shell_exec" or
      execCall.getFunction().toString() = "passthru"
    ) and
    execCall.getArgument(0).toString() contains userInput.toString()
  )
select call,
  "User input flows through polymorphic method " + call.getMethodName() +
    " to command execution - potential command injection vulnerability"

union

/**
 * Detects XSS through polymorphic dispatch
 */
from MethodCall call, Expr userInput
where
  // Method called with user input
  userInput = call.getArgument(0) and
  // Method is polymorphic
  count(Class c | exists(c.getMethod(call.getMethodName()))) > 1 and
  // User input flows to output
  exists(FunctionCall echoCall |
    echoCall.getFunction().toString() = "echo" and
    echoCall.getArgument(0).toString() contains userInput.toString()
  )
select call,
  "User input flows through polymorphic method " + call.getMethodName() +
    " to output - potential XSS vulnerability"
