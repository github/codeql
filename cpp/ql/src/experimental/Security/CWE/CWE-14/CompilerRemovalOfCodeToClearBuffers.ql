/**
 * @name Compiler Removal Of Code To Clear Buffers
 * @description --Using the memset function to clear private data as a final expression when working with a variable is potentially dangerous because the compiler can optimize this call.
 *              --For some compilers, optimization is also possible when using calls to free memory after the memset function.
 *              --To clear it, you need to use the RtlSecureZeroMemory or memset_s functions, or compilation flags that exclude optimization of memset calls (-fno-builtin-memset).
 * @kind problem
 * @id cpp/compiler-removal-of-code-to-clear-buffers
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       external/cwe/cwe-14
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow

/**
 * A call to `memset` , for some local variable.
 */
class CompilerRemovaMemset extends FunctionCall {
  CompilerRemovaMemset() {
    this.getTarget().hasName("memset") and
    exists(DataFlow::Node source, DataFlow::Node sink, LocalVariable isv, Expr exp |
      DataFlow::localFlow(source, sink) and
      this.getArgument(0) = isv.getAnAccess() and
      source.asExpr() = exp and
      exp.getLocation().getEndLine() < this.getArgument(0).getLocation().getStartLine() and
      sink.asExpr() = this.getArgument(0)
    )
  }

  predicate isExistsAllocForThisVariable() {
    exists(FunctionCall alloc, Variable v |
      alloc = v.getAnAssignedValue() and
      this.getArgument(0) = v.getAnAccess() and
      alloc.getASuccessor+() = this
    )
  }

  predicate isExistsFreeForThisVariable() {
    exists(FunctionCall free, Variable v |
      free instanceof DeallocationExpr and
      this.getArgument(0) = v.getAnAccess() and
      free.getArgument(0) = v.getAnAccess() and
      this.getASuccessor+() = free
    )
  }

  predicate isExistsCallWithThisVariableExcludingDeallocationCalls() {
    exists(FunctionCall fc, Variable v |
      not fc instanceof DeallocationExpr and
      this.getArgument(0) = v.getAnAccess() and
      fc.getAnArgument() = v.getAnAccess() and
      this.getASuccessor+() = fc
    )
  }

  predicate isVariableUseAfterMemsetExcludingCalls() {
    exists(DataFlow::Node source, DataFlow::Node sink, LocalVariable isv, Expr exp |
      DataFlow::localFlow(source, sink) and
      this.getArgument(0) = isv.getAnAccess() and
      source.asExpr() = isv.getAnAccess() and
      exp.getLocation().getStartLine() > this.getArgument(2).getLocation().getEndLine() and
      not exp.getParent() instanceof FunctionCall and
      sink.asExpr() = exp
    )
  }

  predicate isVariableUseBoundWithArgumentFunction() {
    exists(DataFlow::Node source, DataFlow::Node sink, LocalVariable isv, Parameter p, Expr exp |
      DataFlow::localFlow(source, sink) and
      this.getArgument(0) = isv.getAnAccess() and
      this.getEnclosingFunction().getAParameter() = p and
      exp.getAChild*() = p.getAnAccess() and
      source.asExpr() = exp and
      sink.asExpr() = isv.getAnAccess()
    )
  }

  predicate isVariableUseBoundWithGlobalVariable() {
    exists(
      DataFlow::Node source, DataFlow::Node sink, LocalVariable isv, GlobalVariable gv, Expr exp
    |
      DataFlow::localFlow(source, sink) and
      this.getArgument(0) = isv.getAnAccess() and
      exp.getAChild*() = gv.getAnAccess() and
      source.asExpr() = exp and
      sink.asExpr() = isv.getAnAccess()
    )
  }

  predicate isExistsCompilationFlagsBlockingRemoval() {
    exists(Compilation c |
      c.getAFileCompiled() = this.getFile() and
      c.getAnArgument() = "-fno-builtin-memset"
    )
  }

  predicate isUseVCCompilation() {
    exists(Compilation c |
      c.getAFileCompiled() = this.getFile() and
      (
        c.getArgument(2).toString().matches("%gcc%") or
        c.getArgument(2).toString().matches("%g++%") or
        c.getArgument(2).toString().matches("%clang%") or
        c.getArgument(2).toString() = "--force-recompute"
      )
    )
  }
}

from CompilerRemovaMemset fc
where
  not (fc.isExistsAllocForThisVariable() and not fc.isExistsFreeForThisVariable()) and
  not (fc.isExistsFreeForThisVariable() and not fc.isUseVCCompilation()) and
  not fc.isVariableUseAfterMemsetExcludingCalls() and
  not fc.isExistsCallWithThisVariableExcludingDeallocationCalls() and
  not fc.isVariableUseBoundWithArgumentFunction() and
  not fc.isVariableUseBoundWithGlobalVariable() and
  not fc.isExistsCompilationFlagsBlockingRemoval()
select fc.getArgument(0), "this variable will not be cleared"
