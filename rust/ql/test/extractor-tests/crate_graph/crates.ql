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

query predicate nodes(MyCrate c) { any() }

query predicate edges(MyCrate c1, MyCrate c2) { c1.getADependency() = c2 }
