/**
 * Contains an extension of `GraphExport` that relies on API graph specific functionality.
 */

private import ApiGraphModels as Shared
private import codeql.mad.dynamic.GraphExport
private import ApiGraphModelsSpecific as Specific

private module API = Specific::API;

private import Shared

/**
 * Holds if some proper prefix of `(type, path)` evaluated to `node`, where `remainingPath`
 * is bound to the suffix of `path` that was not evaluated yet.
 *
 * See concrete examples in `TypeGraphExport`.
 */
bindingset[type, path]
private predicate partiallyEvaluatedModel(
  string type, AccessPath path, API::Node node, string remainingPath
) {
  exists(int n |
    getNodeFromPath(type, path, n) = node and
    n > 0 and
    // Note that `n < path.getNumToken()` is implied by the use of strictconcat()
    remainingPath =
      strictconcat(int k | k = [n .. path.getNumToken() - 1] | path.getToken(k), "." order by k)
  )
}

/**
 * Holds if `type` and all types leading to `type` should be re-exported.
 */
signature predicate shouldContainTypeSig(string type);

/**
 * Wrapper around `GraphExport` that also exports information about re-exported types.
 *
 * ### JavaScript example 1
 * For example, suppose `shouldContainType("foo")` holds, and the following is the entry point for a package `bar`:
 * ```js
 * // bar.js
 * module.exports.xxx = require('foo');
 * ```
 * then this would generate the following type model:
 * ```
 * foo; bar; Member[xxx]
 * ```
 *
 * ### JavaScript example 2
 * For a more complex case, suppose the following type model exists:
 * ```
 * foo.XYZ; foo; Member[x].Member[y].Member[z]
 * ```
 * And the package exports something that matches a prefix of the access path above:
 * ```js
 * module.exports.blah = require('foo').x.y;
 * ```
 * This would result in the following type model:
 * ```
 * foo.XYZ; bar; Member[blah].Member[z]
 * ```
 * Notice that the access path `Member[blah].Member[z]` consists of an access path generated from the API
 * graph, with pieces of the access path from the original type model appended to it.
 */
module TypeGraphExport<
  GraphExportSig<Specific::Location, API::Node> S, shouldContainTypeSig/1 shouldContainType>
{
  /** Like `shouldContainType` but includes types that lead to `type` via type models. */
  private predicate shouldContainTypeEx(string type) {
    shouldContainType(type)
    or
    exists(string prevType |
      shouldContainType(prevType) and
      Shared::typeModel(prevType, type, _)
    )
  }

  private module Config implements GraphExportSig<Specific::Location, API::Node> {
    import S

    predicate shouldContain(API::Node node) {
      S::shouldContain(node)
      or
      exists(string type1 | shouldContainTypeEx(type1) |
        ModelOutput::getATypeNode(type1).getAValueReachableFromSource() = node.asSink()
        or
        exists(string type2, string path |
          Shared::typeModel(type1, type2, path) and
          getNodeFromPath(type2, path, _).getAValueReachableFromSource() = node.asSink()
        )
      )
    }
  }

  private module ExportedGraph = GraphExport<Specific::Location, API::Node, Config>;

  import ExportedGraph

  /**
   * Holds if `type1, type2, path` should be emitted as a type model, that is `(type2, path)` leads to an instance of `type1`.
   */
  predicate typeModel(string type1, string type2, string path) {
    ExportedGraph::typeModel(type1, type2, path)
    or
    shouldContainTypeEx(type1) and
    exists(API::Node node |
      // A relevant type is exported directly
      Specific::sourceFlowsToSink(ModelOutput::getATypeNode(type1), node) and
      ExportedGraph::pathToNode(type2, path, node)
      or
      // Something that leads to a relevant type, but didn't finish its access path, is exported
      exists(string midType, string midPath, string remainingPath, string prefix, API::Node source |
        Shared::typeModel(type1, midType, midPath) and
        partiallyEvaluatedModel(midType, midPath, source, remainingPath) and
        Specific::sourceFlowsToSink(source, node) and
        ExportedGraph::pathToNode(type2, prefix, node) and
        path = join(prefix, remainingPath)
      )
    )
  }
}
