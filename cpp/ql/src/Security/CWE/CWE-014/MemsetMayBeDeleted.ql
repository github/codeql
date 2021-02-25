/**
 * @name Call to `memset` may be deleted
 * @description Using <code>memset</code> the function to clear private data in a variable that has no subsequent use
 *              can make information-leak vulnerabilities easier to exploit because the compiler can remove the call.
 * @kind problem
 * @id cpp/memset-may-be-deleted
 * @problem.severity warning
 * @precision high
 * @tags security
 *       external/cwe/cwe-14
 */

import cpp
import semmle.code.cpp.dataflow.EscapesTree
import semmle.code.cpp.commons.Exclusions

class MemsetFunction extends Function {
  MemsetFunction() {
    this.hasGlobalOrStdOrBslName("memset")
    or
    this.hasGlobalOrStdName("wmemset")
    or
    this.hasGlobalName(["bzero", "__builtin_memset"])
  }
}

from FunctionCall call, LocalVariable v, MemsetFunction memset
where
  call.getTarget() = memset and
  not isFromMacroDefinition(call) and
  // `v` only escapes as the argument to `memset`.
  forall(Expr escape | variableAddressEscapesTree(v.getAnAccess(), escape) |
    call.getArgument(0) = escape.getUnconverted()
  ) and
  // `v` is a stack-allocated array or a struct, and `v` is not static.
  not v.isStatic() and
  (
    v.getUnspecifiedType() instanceof ArrayType and call.getArgument(0) = v.getAnAccess()
    or
    v.getUnspecifiedType() instanceof Struct and
    call.getArgument(0).(AddressOfExpr).getAddressable() = v
  ) and
  // There is no later use of `v`.
  not v.getAnAccess() = call.getASuccessor*() and
  // Not using the `-fno-builtin-memset` flag
  exists(Compilation c |
    c.getAFileCompiled() = call.getFile() and
    not c.getAnArgument() = "-fno-builtin-memset"
  )
select call, "Call to " + memset.getName() + " may be deleted by the compiler."
