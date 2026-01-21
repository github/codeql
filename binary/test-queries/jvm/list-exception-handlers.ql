/**
 * @name List exception handlers
 * @description Lists all exception handlers in the bytecode
 * @kind table
 * @id jvm/list-exception-handlers
 */

import semmle.code.binary.ast.internal.JvmInstructions

from JvmExceptionHandler handler
select handler.getMethod().getFullyQualifiedName() as method, handler.getStartPC() as tryStart,
  handler.getEndPC() as tryEnd, handler.getHandlerPC() as handlerStart,
  handler.getCatchType() as catchType
