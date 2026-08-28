import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.controlflow.internal.Cfg as Cfg
private import semmle.python.dataflow.new.internal.SsaImpl as SsaImpl

private predicate truthyGuard(DataFlow::GuardNode guard, Cfg::ControlFlowNode node, boolean branch) {
  node = guard and branch = true
}

private predicate falseyGuard(DataFlow::GuardNode guard, Cfg::ControlFlowNode node, boolean branch) {
  node = guard and branch = false
}

private predicate genericRelation(DataFlow::ExprNode node, boolean branch) {
  branch = true and node = DataFlow::BarrierGuard<truthyGuard/3>::getABarrierNode()
  or
  branch = false and node = DataFlow::BarrierGuard<falseyGuard/3>::getABarrierNode()
}

private predicate directRelation(DataFlow::ExprNode node, boolean branch) {
  exists(
    DataFlow::GuardNode guard, SsaImpl::EssaDefinition def, Cfg::NameNode checked, Cfg::NameNode use
  |
    checked = guard and
    SsaImpl::AdjacentUses::useOfDef(def, checked) and
    SsaImpl::AdjacentUses::useOfDef(def, use) and
    checked != use and
    guard.controlsBlock(use.getBasicBlock(), branch) and
    node.asCfgNode() = use
  )
}

from DataFlow::ExprNode node, boolean branch
where
  directRelation(node, branch) and not genericRelation(node, branch)
  or
  genericRelation(node, branch) and not directRelation(node, branch)
select node, branch
