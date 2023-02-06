/**
 * @name Dependency path
 * @kind path-problem
 * @description Reports known dependency paths between different predicates or classes.
 * @precision medium
 * @severity info
 * @tags exploration
 * @id ql/explore/dependency-path
 */

//
// This query is for exploration purposes can be edited by hand according to your use-case.
// Note that dependencies introduced by 'magic' are not recognized by this query.
//
import codeql_ql.ast.Ast
import codeql_ql.dependency.DependencyPath

module Config implements DependencyConfig {
  /**
   * Holds if we should explore the transitive dependencies of `source`.
   */
  predicate isSource(PathNode source) {
    // A top-level is considered to depend on everything in the file, which can be useful for generating
    // quick overview of which files depend on a given sink.
    source.asAstNode() instanceof TopLevel
  }

  /**
   * Holds if a transitive dependency from a source to `sink` should be reported.
   */
  predicate isSink(PathNode sink) { sink.asAstNode().(Predicate).getName() = "isLocalSourceNode" }

  /**
   * Holds if the `cached` members of a `cached` module or class should be unified.
   *
   * Whether to set this depends on your use-case:
   * - If you wish to know why one predicate causes another predicate to be evaluated, this should be `any()`.
   * - If you wish to investigate recursion patterns or understand why the value of one predicate
   *   is influenced by another predicate, it should be `none()`.
   */
  predicate followCacheDependencies() { any() }
}

import PathGraph<Config>

from PathNode source, PathNode sink
where hasFlowPath(source, sink)
select source, source, sink, "$@ depends on $@.", source, source.toString(), sink, sink.toString()
