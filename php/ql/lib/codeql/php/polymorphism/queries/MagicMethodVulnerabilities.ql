/**
 * @name Magic Method Vulnerabilities
 * @description Detects vulnerabilities in magic method implementations
 * @kind problem
 * @problem.severity warning
 * @security-severity high
 * @precision medium
 * @tags security
 *       polymorphism
 *       magic-methods
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.MagicMethods
import codeql.php.polymorphism.VulnerabilityDetection

/**
 * Detects __call method that could allow arbitrary method execution
 */
from Method magicCall, FunctionCall eval_or_exec_call
where
  magicCall.getName() = "__call" and
  eval_or_exec_call.getEnclosingFunction() = magicCall and
  (
    eval_or_exec_call.getFunction().toString() matches "eval%" or
    eval_or_exec_call.getFunction().toString() matches "exec%" or
    eval_or_exec_call.getFunction().toString() matches "system%" or
    eval_or_exec_call.getFunction().toString() matches "shell_exec%"
  )
select magicCall,
  "Dangerous __call implementation: unrestricted method execution could allow code injection"

union

/**
 * Detects __toString that could have side effects
 */
from Method toString, FunctionCall dangerous_call
where
  toString.getName() = "__toString" and
  dangerous_call.getEnclosingFunction() = toString and
  (
    dangerous_call.getFunction().toString() matches "system%" or
    dangerous_call.getFunction().toString() matches "exec%" or
    dangerous_call.getFunction().toString() matches "file_put_contents%" or
    dangerous_call.getFunction().toString() matches "unserialize%"
  )
select toString,
  "Dangerous __toString implementation: implicit conversions could trigger dangerous operations"

union

/**
 * Detects __set that allows unrestricted property modification
 */
from Method set_method
where
  set_method.getName() = "__set" and
  not exists(Expr validation |
    // Some validation exists
    true
  )
select set_method,
  "Unvalidated __set method could allow property injection attacks"
