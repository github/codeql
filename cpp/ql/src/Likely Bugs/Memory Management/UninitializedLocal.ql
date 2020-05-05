/**
 * @name Potentially uninitialized local variable
 * @description Reading from a local variable that has not been assigned to
 *              will typically yield garbage.
 * @kind problem
 * @id cpp/uninitialized-local
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       external/cwe/cwe-665
 *       external/cwe/cwe-457
 */

import cpp
import semmle.code.cpp.controlflow.StackVariableReachability

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

/**
 * A declaration of a local variable that leaves the
 * variable uninitialized.
 */
DeclStmt declWithNoInit(LocalVariable v) {
  result.getADeclaration() = v and
  not exists(v.getInitializer()) and
  /* The type of the variable is not stack-allocated. */
  not allocatedType(v.getType())
}

class UninitialisedLocalReachability extends StackVariableReachability {
  UninitialisedLocalReachability() { this = "UninitialisedLocal" }

  override predicate isSource(ControlFlowNode node, StackVariable v) { node = declWithNoInit(v) }

  override predicate isSink(ControlFlowNode node, StackVariable v) { useOfVarActual(v, node) }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) {
    // only report the _first_ possibly uninitialized use
    useOfVarActual(v, node) or
    definitionBarrier(v, node)
  }
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
  // Finally, exclude functions that contain assembly blocks. It's
  // anyone's guess what happens in those.
  containsInlineAssembly(result.getEnclosingFunction())
}

from UninitialisedLocalReachability r, LocalVariable v, VariableAccess va
where
  r.reaches(_, v, va) and
  not va = commonException()
select va, "The variable $@ may not be initialized here.", v, v.getName()
