/**
 * Provides classes and predicates for Groovy Code Injection
 * taint-tracking configuration.
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow

/** A data flow sink for Groovy expression injection vulnerabilities. */
abstract class GroovyInjectionSink extends DataFlow::ExprNode { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `GroovyInjectionConfig`.
 */
class GroovyInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `GroovyInjectionConfig` configuration.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

private class DefaultGroovyInjectionSink extends GroovyInjectionSink {
  DefaultGroovyInjectionSink() { sinkNode(this, "groovy") }
}

private class DefaultLdapInjectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "groovy.lang;GroovyShell;false;evaluate;;;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;;;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;;;Argument[0];groovy",
        "groovy.util;Eval;false;me;(String);;Argument[0];groovy",
        "groovy.util;Eval;false;me;(String,Object,String);;Argument[2];groovy",
        "groovy.util;Eval;false;x;(Object,String);;Argument[1];groovy",
        "groovy.util;Eval;false;xy;(Object,Object,String);;Argument[2];groovy",
        "groovy.util;Eval;false;xyz;(Object,Object,Object,String);;Argument[3];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;;;Argument[0];groovy"
      ]
  }
}

/** A set of additional taint steps to consider when taint tracking Groovy related data flows. */
private class DefaultGroovyInjectionAdditionalTaintStep extends GroovyInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    groovyCodeSourceTaintStep(node1, node2)
  }
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step from a tainted string to
 * a `GroovyCodeSource` instance, i.e. `new GroovyCodeSource(tainted, ...)`.
 */
private predicate groovyCodeSourceTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(ConstructorCall gcscc |
    gcscc.getConstructedType() instanceof TypeGroovyCodeSource and
    gcscc = toNode.asExpr() and
    gcscc.getArgument(0) = fromNode.asExpr()
  )
}

/** The class `groovy.lang.GroovyCodeSource`. */
private class TypeGroovyCodeSource extends RefType {
  TypeGroovyCodeSource() { this.hasQualifiedName("groovy.lang", "GroovyCodeSource") }
}
