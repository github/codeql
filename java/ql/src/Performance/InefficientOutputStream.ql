/**
 * @name Inefficient output stream
 * @description Using the default implementation of 'write(byte[],int,int)'
 *              provided by 'java.io.OutputStream' is very inefficient.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/inefficient-output-stream
 * @tags efficiency
 */

import java

class InefficientWriteBytes extends Class {
  InefficientWriteBytes() {
    this.hasQualifiedName("java.io", "OutputStream") or
    this.hasQualifiedName("java.io", "FilterOutputStream")
  }
}

from Class c, Method m
where
  not c.isAbstract() and
  not c instanceof InefficientWriteBytes and
  c.getASupertype() instanceof InefficientWriteBytes and
  c.getAMethod() = m and
  m.getName() = "write" and
  m.getNumberOfParameters() = 1 and
  m.getParameterType(0).(PrimitiveType).getName() = "int" and
  exists(Method m2 | c.inherits(m2) |
    m2.getName() = "write" and
    m2.getNumberOfParameters() = 3 and
    m2.getDeclaringType() instanceof InefficientWriteBytes
  ) and
  // If that method doesn't call write itself, then we don't have a problem.
  // This is the case is some dummy implementations.
  exists(MethodCall ma | ma.getEnclosingCallable() = m | ma.getMethod().getName() = "write")
select c,
  "This class extends 'java.io.OutputStream' and implements $@, but does not override 'write(byte[],int,int)'.",
  m, m.getName()
