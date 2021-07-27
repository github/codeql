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
import semmle.code.cpp.dataflow.DataFlow
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

/*
Holds if there is macro in parameters.
For example: syslog (LOG_ERR, 
                    "***** %s: return throttled errcode vrf %s afi %u loc 1*****", 
                    __FUNCTION__, <------ should be reported
                    table_ctx->vrf_name, 
                    table_ctx->official_afi);
*/
// predicate hasMacro(FormattingFunctionCall fc) {
//     exists(MacroInvocation mi |
//         mi.getExpr() = v)
// }

class SourceNode extends DataFlow::Node {
    SourceNode() {
      not DataFlow::localFlowStep(_, this)
    }
  }

from string format, FormattingFunctionCall fc, SourceNode src, DataFlow::Node arg
where format = fc.getFormat().getValue() // format: "%s: Failed init_producer"
    and fc.getTarget().hasName("syslog") 
    and not isLogDebug(fc.getArgument(0)) // exclude debug logs
    // and lit.getValue() = "bgp_nbr_range_print"
    and DataFlow::localFlow(src, arg)
    and src.asExpr() instanceof StringLiteral
select fc, "Argument " + arg + " of " + fc.toString() + " is " + arg
