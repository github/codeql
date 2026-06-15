/**
 * Provides classes modeling security-relevant aspects of the `bson` PyPI package.
 * See
 * - https://pypi.org/project/bson/
 * - https://github.com/py-bson/bson
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `bson` PyPI package.
 * See
 * - https://pypi.org/project/bson/
 * - https://github.com/py-bson/bson
 */
private module BSon {
  /**
   * ObjectId returns a string representing an id.
   * If at any time ObjectId can't parse it's input (like when a tainted dict in passed in),
   * then ObjectId will throw an error preventing the query from running.
   */
  private class BsonObjectIdCall extends DataFlow::CallCfgNode, NoSqlSanitizer::Range {
    BsonObjectIdCall() {
      exists(API::Node mod |
        mod = API::moduleImport("bson")
        or
        mod = API::moduleImport("bson").getMember(["objectid", "json_util"])
      |
        this = mod.getMember("ObjectId").getACall()
      )
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }
  }
}
