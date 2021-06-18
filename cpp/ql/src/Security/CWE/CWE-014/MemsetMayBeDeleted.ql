/**
 * @name Call to `memset` may be deleted
 * @description Using the `memset` function to clear private data in a variable that has no subsequent use
 *              can make information-leak vulnerabilities easier to exploit because the compiler can remove the call.
 * @kind problem
 * @id cpp/memset-may-be-deleted
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @tags security
 *       external/cwe/cwe-14
 */

import cpp
import semmle.code.cpp.dataflow.EscapesTree
import semmle.code.cpp.commons.Exclusions
import semmle.code.cpp.models.interfaces.Alias

class MemsetFunction extends Function {
  MemsetFunction() {
    this.hasGlobalOrStdOrBslName("memset")
    or
    this.hasGlobalOrStdName("wmemset")
    or
    this.hasGlobalName(["bzero", "__builtin_memset"])
  }
}

predicate isNonEscapingArgument(Expr escaped) {
  exists(Call call, AliasFunction aliasFunction, int i |
    aliasFunction = call.getTarget() and
    call.getArgument(i) = escaped.getUnconverted() and
    (
      aliasFunction.parameterNeverEscapes(i)
      or
      aliasFunction.parameterEscapesOnlyViaReturn(i) and
      (call instanceof ExprInVoidContext or call.getConversion*() instanceof BoolConversion)
    )
  )
}

pragma[noinline]
predicate callToMemsetWithRelevantVariable(
  LocalVariable v, VariableAccess acc, FunctionCall call, MemsetFunction memset
) {
  not v.isStatic() and
  // Reference-typed variables get special treatment in `variableAddressEscapesTree` so we leave them
  // out of this query.
  not v.getUnspecifiedType() instanceof ReferenceType and
  call.getTarget() = memset and
  acc = v.getAnAccess() and
  // `v` escapes as the argument to `memset`
  variableAddressEscapesTree(acc, call.getArgument(0).getFullyConverted())
}

pragma[noinline]
predicate relevantVariable(LocalVariable v, FunctionCall call, MemsetFunction memset) {
  exists(VariableAccess acc, VariableAccess anotherAcc |
    callToMemsetWithRelevantVariable(v, acc, call, memset) and
    // `v` is not only just used in the call to `memset`.
    anotherAcc = v.getAnAccess() and
    acc != anotherAcc and
    not anotherAcc.isUnevaluated()
  )
}

from FunctionCall call, LocalVariable v, MemsetFunction memset
where
  relevantVariable(v, call, memset) and
  not isFromMacroDefinition(call) and
  // `v` doesn't escape anywhere else.
  forall(Expr escape | variableAddressEscapesTree(v.getAnAccess(), escape) |
    isNonEscapingArgument(escape)
  ) and
  // There is no later use of `v`.
  not v.getAnAccess() = call.getASuccessor*() and
  // Not using the `-fno-builtin-memset` flag
  exists(Compilation c |
    c.getAFileCompiled() = call.getFile() and
    not c.getAnArgument() = "-fno-builtin-memset"
  )
select call, "Call to " + memset.getName() + " may be deleted by the compiler."
