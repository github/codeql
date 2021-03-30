/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * PyMongoCall
 * MongoEngineCall
 * Custom escapes
 */
private module NoSQL {
  // doesn't work currently
  private class PyMongoCall extends DataFlow::Node, NoSQLQuery::Range {
    DataFlow::Node queryNode;

    PyMongoCall() {
      exists(SsaVariable clientVar, CallNode findCall |
        (
          clientVar.getDefinition().getImmediateDominator() =
            Value::named("pymongo.MongoClient").getACall() or
          clientVar.getDefinition().getImmediateDominator() =
            Value::named("flask_pymongo.PyMongo").getACall()
        ) and
        clientVar.getAUse().getNode() = findCall.getNode().getFunc().(Attribute).getObject() and
        findCall.getNode().getFunc().(Attribute).getName().matches("%find%") and
        this.asCfgNode() = findCall and
        queryNode.asExpr() = findCall.getArg(0).getNode()
      )
    }

    override DataFlow::Node getQueryNode() { result = queryNode }
  }

  // `API::moduleImport("mongoengine").getMember("Document").getASubclass*().getACall()` doesn't point
  // to our sinks
  private class MongoEngineCall extends DataFlow::CallCfgNode, NoSQLQuery::Range {
    DataFlow::Node queryNode;

    MongoEngineCall() {
      exists(DataFlow::AttrRead objectsMethod |
        this.getFunction() = objectsMethod and
        API::moduleImport("mongoengine").getMember("Document").getASubclass*().getACall() =
          objectsMethod.getObject().getALocalSource() and
        queryNode = this.getArg(0)
      )
    }

    override DataFlow::Node getQueryNode() { result = queryNode }
  }

  // pending: look for more Sanitizer libs
  private class MongoSanitizer extends DataFlow::CallCfgNode, NoSQLSanitizer::Range {
    DataFlow::Node escapeNode;

    MongoSanitizer() {
      this =
        API::moduleImport("mongosanitizer").getMember("sanitizer").getMember("sanitize").getACall() and
      escapeNode = this.getArg(0)
    }

    override DataFlow::Node getSanitizerNode() { result = escapeNode }
  }
}
