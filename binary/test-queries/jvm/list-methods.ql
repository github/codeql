/**
 * @name List all JVM methods
 * @description Lists all methods found in the analyzed JVM bytecode
 * @kind table
 * @id jvm/list-methods
 */

import semmle.code.binary.ast.internal.JvmInstructions

from JvmMethod m
select m.getDeclaringType().getFullName() as className, m.getName() as methodName,
  m.getFullyQualifiedName() as fullyQualified
