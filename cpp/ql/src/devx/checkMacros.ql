/**
 * @name Name: Check macros
 * @description Description: Ensure that macros like __FUNCTION__, __FILE__ and __LINE__ are part of only debug logs, and not others.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/check-macros
 * @tags testability
 *       readability
 *       maintainability
 */

import cpp
import semmle.code.cpp.commons.Printf
import semmle.code.cpp.models.interfaces.FormattingFunction

// Find the syslog calls that meet two conditions

// 1. First parameter is not "LOG_DEBUG". Such as LOG_ERR.

// 2. Macros in log messages.

// Example: syslog(LOG_ERR, "%s: Failed init_producer", __FUNCTION__);

/*
Holds if the log macro is debug.
*/
predicate isLogDebug(Expr mie) {
    exists(MacroInvocation mi |
        mi.getExpr() = mie and
        (
          mi.getMacroName() = "LOG_DEBUG"
        )
      )
}

class Likely__FUNCTION__ extends StringLiteral {
    Likely__FUNCTION__() { 
        this.getValue() = this.getEnclosingFunction().getName() 
    }
  }
  
/**
 * Holds if `e` is either:
 * 1. a macro invocation with the name `s`, or
 * 2. a string literal with the same value as the name of `e`'s enclosing function. This likely means
 * that `e` is a use of the `__FUNCTION__` macro.
 */
predicate isMacroInvocationLike(Expr e) {
    exists(MacroInvocation mi |
        e = mi.getExpr()
    )
    or
    e instanceof Likely__FUNCTION__
}


from string format, FormattingFunctionCall fc, int n
where
format = fc.getFormat().getValue() and // format: "%s: Failed init_producer"
fc.getTarget().hasName("syslog") and
not isLogDebug(fc.getArgument(0)) 
// isMacroInvocationLike(fc.getFormatArgument(n))
// fc.getFormatArgument(n).getValue() = fc.getEnclosingFunction().getName()
select fc, "Argument " + n + " of " + fc.toString() + " is " + fc.getFormatArgument(n).getValue()
