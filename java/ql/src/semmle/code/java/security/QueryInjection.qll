import java
import semmle.code.java.dataflow.DataFlow

/** A sink for database query language injection vulnerabilities. */
abstract class QueryInjectionSink extends DataFlow::ExprNode { }
