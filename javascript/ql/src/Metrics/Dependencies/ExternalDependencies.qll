/**
 * Provides a helper predicate for encoding external dependency counts.
 */

import semmle.javascript.dependencies.Dependencies

/**
 * Holds if `f` is a file that contains `n` dependencies on `dep` (where `n` is non-zero),
 * and `entity` is the string `p<|>depid<|>depver`, where `p` is the path of `f`
 * relative to the source root, and `depid` and `depver` are the id and version,
 * respectively, of `dep`.
 */
predicate externalDependencies(File f, Dependency dep, string entity, int n) {
  exists(string id, string v | dep.info(id, v) |
    entity = "/" + f.getRelativePath() + "<|>" + id + "<|>" + v
  ) and
  n = strictcount(Locatable use | use.getFile() = f and use = dep.getAUse(_))
}
