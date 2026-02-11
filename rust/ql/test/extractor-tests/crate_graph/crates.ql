/**
 * @id crate-graph
 * @name Crate Graph
 * @kind graph
 */

import rust

class MyCrate extends Crate {
  // avoid printing locations for crates outside of the test folder
  Location getLocation() { result = super.getLocation() and this.fromSource() }
}

private int getOrder(MyCrate c) {
  c =
    rank[result](MyCrate c0, string name, string version |
      name = c0.getName() and
      version = c0.getVersion()
    |
      c0 order by name, version
    )
}

query predicate nodes(MyCrate c, string key, string value) {
  key = "semmle.order" and value = getOrder(c).toString()
}

query predicate edges(MyCrate c1, MyCrate c2, string key, string value) {
  c1.getDependency(value) = c2 and
  key = "semmle.label"
}
