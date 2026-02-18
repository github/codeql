/**
 * @name Suspicious unused loop iteration variable
 * @description A loop iteration variable is unused, which suggests an error.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/unused-loop-variable
 */

import python
private import semmle.python.ApiGraphs
import Definition

predicate is_increment(Stmt s) {
  /* x += n */
  s.(AugAssign).getValue() instanceof IntegerLiteral
  or
  /* x = x + n */
  exists(Name t, BinaryExpr add |
    t = s.(AssignStmt).getTarget(0) and
    add = s.(AssignStmt).getValue() and
    add.getLeft().(Name).getVariable() = t.getVariable() and
    add.getRight() instanceof IntegerLiteral
  )
}

predicate counting_loop(For f) { is_increment(f.getAStmt()) }

predicate empty_loop(For f) { not exists(f.getStmt(1)) and f.getStmt(0) instanceof Pass }

predicate one_item_only(For f) {
  not exists(Continue c | f.contains(c)) and
  exists(Stmt s | s = f.getBody().getLastItem() |
    s instanceof Return
    or
    s instanceof Break
  )
}

/** Holds if `node` is a call to `range`, `xrange`, or `list(range(...))`. */
predicate call_to_range(DataFlow::Node node) {
  node = API::builtin(["range", "xrange"]).getACall()
  or
  /* Handle 'from six.moves import range' or similar. */
  node = API::moduleImport("six").getMember("moves").getMember(["range", "xrange"]).getACall()
  or
  /* Handle list(range(...)) and list(list(range(...))) */
  node = API::builtin("list").getACall() and
  call_to_range(node.(DataFlow::CallCfgNode).getArg(0))
}

/** Whether n is a use of a variable that is a not effectively a constant. */
predicate use_of_non_constant(Name n) {
  exists(Variable var |
    n.uses(var) and
    /* use is local */
    not n.getScope() instanceof Module and
    /* variable is not global */
    not var.getScope() instanceof Module
  |
    /* Defined more than once (dynamically) */
    strictcount(Name def | def.defines(var)) > 1
    or
    exists(For f, Name def | f.contains(def) and def.defines(var))
    or
    exists(While w, Name def | w.contains(def) and def.defines(var))
  )
}

/**
 * Whether loop body is implicitly repeating something N times.
 * E.g. queue.add(None)
 */
predicate implicit_repeat(For f) {
  not exists(f.getStmt(1)) and
  exists(ImmutableLiteral imm | f.getStmt(0).contains(imm)) and
  not exists(Name n | f.getBody().contains(n) and use_of_non_constant(n))
}

/**
 * Get the CFG node for the iterable relating to the for-statement `f` in a comprehension.
 * The for-statement `f` is the artificial for-statement in a comprehension
 * and the result is the iterable in that comprehension.
 * E.g. gets `x` from `{ y for y in x }`.
 */
ControlFlowNode get_comp_iterable(For f) {
  exists(Comp c | c.getFunction().getStmt(0) = f | c.getAFlowNode().getAPredecessor() = result)
}

from For f, Variable v, string msg
where
  f.getTarget() = v.getAnAccess() and
  not f.getAStmt().contains(v.getAnAccess()) and
  not call_to_range(DataFlow::exprNode(f.getIter())) and
  not call_to_range(DataFlow::exprNode(get_comp_iterable(f).getNode())) and
  not name_acceptable_for_unused_variable(v) and
  not f.getScope().getName() = "genexpr" and
  not empty_loop(f) and
  not one_item_only(f) and
  not counting_loop(f) and
  not implicit_repeat(f) and
  if exists(Name del | del.deletes(v) and f.getAStmt().contains(del))
  then msg = "' is deleted, but not used, in the loop body."
  else msg = "' is not used in the loop body."
select f, "For loop variable '" + v.getId() + msg
