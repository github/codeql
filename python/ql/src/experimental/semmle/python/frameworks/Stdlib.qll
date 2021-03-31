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

private module NoSQL {
  // more methods?
  private class PyMongoMethods extends string {
    PyMongoMethods() { this in ["find_one"] }
  }

  private class PyMongoCall extends DataFlow::CallCfgNode, NoSQLQuery::Range {
    PyMongoCall() {
      this =
        API::moduleImport("pymongo")
            .getMember("MongoClient")
            .getReturn()
            .getAMember*()
            .getMember(any(PyMongoMethods pyMongoM))
            .getACall()
    }

    override DataFlow::Node getQueryNode() { result = this.getArg(0) }
  }

  // more methods?
  private class PyMongoFlaskMethods extends string {
    PyMongoFlaskMethods() { this in ["find"] }
  }

  private class PyMongoFlaskCall extends DataFlow::CallCfgNode, NoSQLQuery::Range {
    PyMongoFlaskCall() {
      this =
        API::moduleImport("flask_pymongo")
            .getMember("PyMongo")
            .getReturn()
            .getAMember*()
            .getMember(any(PyMongoFlaskMethods pyMongoFlaskM))
            .getACall()
    }

    override DataFlow::Node getQueryNode() { result = this.getArg(0) }
  }

  private class MongoEngineCall extends DataFlow::CallCfgNode, NoSQLQuery::Range {
    MongoEngineCall() {
      this =
        API::moduleImport("mongoengine")
            .getMember("Document")
            .getASubclass()
            .getMember("objects")
            .getACall()
    }

    override DataFlow::Node getQueryNode() { result = this.getArg(0) }
  }

  // pending: look for more Sanitizer libs
  private class MongoSanitizerCall extends DataFlow::CallCfgNode, NoSQLSanitizer::Range {
    MongoSanitizerCall() {
      this =
        API::moduleImport("mongosanitizer").getMember("sanitizer").getMember("sanitize").getACall()
    }

    override DataFlow::Node getSanitizerNode() { result = this.getArg(0) }
  }
}
