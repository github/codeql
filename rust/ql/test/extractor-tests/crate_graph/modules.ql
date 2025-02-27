/**
 * @id module-graph
 * @name Module and Item Graph
 * @kind graph
 */

import rust

predicate nodes(Item i) { i instanceof RelevantNode }

class RelevantNode extends Item {
  RelevantNode() {
    this.getParentNode*() =
      any(Crate m | m.getName() = "test" and m.getVersion() = "0.0.1").getModule()
  }
}

predicate edges(RelevantNode container, RelevantNode element) {
  element = container.(Module).getItemList().getAnItem() or
  element = container.(Impl).getAssocItemList().getAnAssocItem() or
  element = container.(Trait).getAssocItemList().getAnAssocItem()
}

query predicate nodes(RelevantNode node, string attr, string val) {
  nodes(node) and
  (
    attr = "semmle.label" and
    val = node.toString()
    or
    attr = "semmle.order" and
    val =
      any(int i | node = rank[i](RelevantNode n | nodes(n) | n order by n.toString())).toString()
  )
}

query predicate edges(RelevantNode pred, RelevantNode succ, string attr, string val) {
  edges(pred, succ) and
  (
    attr = "semmle.label" and
    val = ""
    or
    attr = "semmle.order" and
    val = any(int i | succ = rank[i](Item s | edges(pred, s) | s order by s.toString())).toString()
  )
}
