/**
 * Contains predicates for generating `typeModel`s that contain typing
 * information for API nodes.
 */

private import ruby
private import codeql.ruby.ApiGraphs
private import Util as Util

/**
 * Contains predicates for generating `typeModel`s that contain typing
 * information for API nodes.
 */
module Types {
  /**
   * Holds if `node` should be seen as having the given `type`.
   */
  private predicate valueHasTypeName(DataFlow::LocalSourceNode node, string type) {
    node.getLocation().getFile() instanceof Util::RelevantFile and
    exists(DataFlow::ModuleNode mod |
      (
        node = mod.getAnImmediateReference().getAMethodCall("new")
        or
        node = mod.getAnOwnInstanceSelf()
      ) and
      type = mod.getQualifiedName()
      or
      (
        node = mod.getAnImmediateReference()
        or
        node = mod.getAnOwnModuleSelf()
      ) and
      type = mod.getQualifiedName() + "!"
    )
  }

  /**
   * Holds if `(type2, path)` should be seen as an instance of `type1`.
   */
  predicate typeModel(string type1, string type2, string path) {
    exists(API::Node node |
      valueHasTypeName(node.getAValueReachingSink(), type1) and
      Util::pathToNode(node, type2, path, true)
    )
  }
}
