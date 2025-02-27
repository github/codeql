/**
 * @id crate-graph
 * @name Crate Graph
 * @kind graph
 */

import rust

query predicate nodes(Crate c) { any() }

query predicate edges(Crate c1, Crate c2) { c1.getADependency() = c2 }
