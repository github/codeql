/**
 * @name Duck Typing Missing Methods
 * @description Detects potential runtime errors from duck typing without method verification
 * @kind problem
 * @problem.severity warning
 * @security-severity low
 * @precision medium
 * @tags polymorphism
 *       duck-typing
 *       runtime-error
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.DuckTyping

/**
 * Detects calls on untyped variables that might not implement required methods
 */
from MethodCall call, Variable untypedVar
where
  untypedVar = call.getObject() and
  // Variable has no type annotation
  not exists(Expr typeAnnotation |
    // No type hint
    true
  ) and
  // Method is called without existence check
  not exists(FunctionCall methodExists |
    methodExists.getFunction().toString() = "method_exists"
  )
select call,
  "Method " + call.getMethodName() +
    " called on untyped variable - could fail at runtime if method doesn't exist"
