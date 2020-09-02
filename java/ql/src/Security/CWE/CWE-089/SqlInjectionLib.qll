/** Definitions used by the queries for database query injection. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.QueryInjection

/** A sink for MongoDB injection vulnerabilities. */
class MongoDbInjectionSink extends QueryInjectionSink {
  MongoDbInjectionSink() {
    exists(MethodAccess call |
      call.getMethod().getDeclaringType().hasQualifiedName("com.mongodb", "BasicDBObject") and
      call.getMethod().hasName("parse") and
      this.asExpr() = call.getArgument(0)
    )
    or
    exists(CastExpr c |
      c.getExpr() = this.asExpr() and
      c.getTypeExpr().getType().(RefType).hasQualifiedName("com.mongodb", "DBObject")
    )
  }
}

private class QueryInjectionFlowConfig extends TaintTracking::Configuration {
  QueryInjectionFlowConfig() { this = "SqlInjectionLib::QueryInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    mongoJsonStep(node1, node2)
  }
}

/**
 * Implementation of `SqlTainted.ql`. This is extracted to a QLL so that it
 * can be excluded from `SqlUnescaped.ql` to avoid overlapping results.
 */
predicate queryTaintedBy(
  QueryInjectionSink query, DataFlow::PathNode source, DataFlow::PathNode sink
) {
  exists(QueryInjectionFlowConfig conf | conf.hasFlowPath(source, sink) and sink.getNode() = query)
}

predicate mongoJsonStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma |
    ma.getMethod().getDeclaringType().hasQualifiedName("com.mongodb.util", "JSON") and
    ma.getMethod().hasName("parse") and
    ma.getArgument(0) = node1.asExpr() and
    ma = node2.asExpr()
  )
}
