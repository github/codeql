/**
 * @name Global shadowed by local variable
 * @description Defining a local variable with the same name as a global variable
 *              makes the global variable unusable within the current scope and makes the code
 *              more difficult to read.
 * @kind problem
 * @tags quality
 *       maintainability
 *       readability
 *       correctness
 * @problem.severity recommendation
 * @sub-severity low
 * @precision medium
 * @id py/local-shadows-global
 */

import python
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.ApiGraphs
import Shadowing

predicate shadows(Name d, GlobalVariable g, Function scope, int line) {
  g.getScope() = scope.getScope() and
  d.getScope() = scope and
  exists(LocalVariable l |
    d.defines(l) and
    l.getId() = g.getId()
  ) and
  not exists(Import il, Import ig, Name gd | il.contains(d) and gd.defines(g) and ig.contains(gd)) and
  not exists(Assign a | a.getATarget() = d and a.getValue() = g.getAnAccess()) and
  not DuckTyping::globallyDefinedName(g.getId()) and
  d.getLocation().getStartLine() = line and
  exists(Name defn | defn.defines(g) | not exists(If i | i.isNameEqMain() | i.contains(defn))) and
  not optimizing_parameter(d)
}

/* pytest fixtures require that the parameter name is also a global */
predicate assigned_pytest_fixture(GlobalVariable v) {
  exists(NameNode def, API::Node fixture |
    fixture = API::moduleImport("pytest").getMember("fixture") and
    def.defines(v) and
    def.(DefinitionNode).getValue() =
      [fixture.getACall(), fixture.getReturn().getACall()].asCfgNode()
  )
}

predicate first_shadowing_definition(Name d, GlobalVariable g) {
  exists(int first, Scope scope |
    shadows(d, g, scope, first) and
    first = min(int line | shadows(_, g, scope, line))
  )
}

from Name d, GlobalVariable g, Name def
where
  first_shadowing_definition(d, g) and
  not exists(Name n | n.deletes(g)) and
  def.defines(g) and
  not assigned_pytest_fixture(g) and
  not g.getId() = "_"
select d, "Local variable '" + g.getId() + "' shadows a $@.", def, "global variable"
