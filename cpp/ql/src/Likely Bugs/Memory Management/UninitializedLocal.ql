/**
 * @name Potentially uninitialized local variable
 * @description Reading from a local variable that has not been assigned to
 *              will typically yield garbage.
 * @kind path-problem
 * @id cpp/uninitialized-local
 * @problem.severity warning
 * @security-severity 7.8
 * @precision medium
 * @tags security
 *       external/cwe/cwe-665
 *       external/cwe/cwe-457
 */

import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.dataflow.MustFlow
import PathGraph

/**
 * Auxiliary predicate: Types that don't require initialization
 * before they are used, since they're stack-allocated.
 */
predicate allocatedType(Type t) {
  /* Arrays: "int foo[1]; foo[0] = 42;" is ok. */
  t instanceof ArrayType
  or
  /* Structs: "struct foo bar; bar.baz = 42" is ok. */
  t instanceof Class
  or
  /* Typedefs to other allocated types are fine. */
  allocatedType(t.(TypedefType).getUnderlyingType())
  or
  /* Type specifiers don't affect whether or not a type is allocated. */
  allocatedType(t.getUnspecifiedType())
}

pragma[noinline]
predicate containsInlineAssembly(Function f) { exists(AsmStmt s | s.getEnclosingFunction() = f) }

/**
 * Auxiliary predicate: List common exceptions or false positives
 * for this check to exclude them.
 */
VariableAccess commonException() {
  // If the uninitialized use we've found is in a macro expansion, it's
  // typically something like va_start(), and we don't want to complain.
  result.getParent().isInMacroExpansion()
  or
  result.getParent() instanceof BuiltInOperation
  or
  // Ignore any uninitialized use that is explicitly cast to void and
  // is an expression statement.
  result.getActualType() instanceof VoidType and
  result.getParent() instanceof ExprStmt
  or
  // Finally, exclude functions that contain assembly blocks. It's
  // anyone's guess what happens in those.
  containsInlineAssembly(result.getEnclosingFunction())
  or
  exists(Call c | c.getQualifier() = result | c.getTarget().isStatic())
}

predicate isSinkImpl(Instruction sink, VariableAccess va) {
  exists(LoadInstruction load |
    va = load.getUnconvertedResultExpression() and
    not va = commonException() and
    not va.getTarget().(LocalVariable).getFunction().hasErrors() and
    sink = load.getSourceValue()
  )
}

class MustFlow extends MustFlowConfiguration {
  MustFlow() { this = "MustFlow" }

  override predicate isSource(Instruction source) {
    source instanceof UninitializedInstruction and
    exists(Type t | t = source.getResultType() | not allocatedType(t))
  }

  override predicate isSink(Operand sink) { isSinkImpl(sink.getDef(), _) }

  override predicate allowInterproceduralFlow() { none() }

  override predicate isBarrier(Instruction instr) { instr instanceof ChiInstruction }
}

from
  VariableAccess va, LocalVariable v, MustFlow conf, MustFlowPathNode source, MustFlowPathNode sink
where
  conf.hasFlowPath(source, sink) and
  isSinkImpl(sink.getInstruction(), va) and
  v = va.getTarget()
select va, source, sink, "The variable $@ may not be initialized at this access.", v, v.getName()
