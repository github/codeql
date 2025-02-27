/**
 * @id module-graph
 * @name Module and Item Graph
 * @kind graph
 */

import rust

query predicate nodes(Item i) {
  i.getParentNode*() = any(Crate m | m.getName() = "test" and m.getVersion() = "0.0.1").getModule()
}

query predicate edges(Item container, Item element) {
  element = container.(Module).getItemList().getAnItem() or
  element = container.(Impl).getAssocItemList().getAnAssocItem() or
  element = container.(Trait).getAssocItemList().getAnAssocItem()
}
