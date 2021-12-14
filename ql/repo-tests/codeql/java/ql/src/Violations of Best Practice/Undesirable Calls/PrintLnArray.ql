/**
 * @name Implicit conversion from array to string
 * @description Directly printing an array, without first converting the array to a string,
 *              produces unreadable results.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id java/print-array
 * @tags maintainability
 */

import java
import semmle.code.java.StringFormat

/**
 * Holds if `e` is an argument of `Arrays.toString(..)`.
 */
predicate arraysToStringArgument(Expr e) {
  exists(MethodAccess ma, Method m |
    ma.getAnArgument() = e and
    ma.getMethod() = m and
    m.getDeclaringType().hasQualifiedName("java.util", "Arrays") and
    m.hasName("toString")
  )
}

from Expr arr
where
  arr.getType() instanceof Array and
  implicitToStringCall(arr) and
  not exists(FormattingCall fmtcall |
    // exclude slf4j formatting as it supports array formatting
    fmtcall.getAnArgumentToBeFormatted() = arr and fmtcall.getSyntax().isLogger()
  )
  or
  arr.getType().(Array).getComponentType() instanceof Array and
  arraysToStringArgument(arr)
select arr, "Implicit conversion from Array to String."
