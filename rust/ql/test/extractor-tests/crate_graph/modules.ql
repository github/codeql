/**
 * @id module-graph
 * @name Module and Item Graph
 * @kind graph
 */

import rust
import codeql.rust.internal.PathResolution

predicate nodes(Item i) { i instanceof RelevantNode }

class RelevantNode extends Element instanceof ItemNode {
  RelevantNode() {
    this.(ItemNode).getImmediateParentModule*() =
      any(Crate m | m.getName() = "test" and m.getVersion() = "0.0.1")
          .(CrateItemNode)
          .getModuleNode()
  }

  string label() { result = this.toString() }
}

class HasGenericParams extends RelevantNode {
  private GenericParamList params;

  HasGenericParams() {
    params = this.(Function).getGenericParamList() or
    params = this.(Enum).getGenericParamList() or
    params = this.(Struct).getGenericParamList() or
    params = this.(Union).getGenericParamList() or
    params = this.(Impl).getGenericParamList() or
    params = this.(Trait).getGenericParamList() // or
    //params = this.(TraitAlias).getGenericParamList()
  }

  override string label() {
    result =
      super.toString() + "<" +
        strictconcat(string part, int index |
          part = params.getGenericParam(index).toString()
        |
          part, ", " order by index
        ) + ">"
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
    val = node.label()
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
