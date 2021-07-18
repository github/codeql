/**
 * @name File loaded in Java EE applications that can be controlled by an attacker
 * @description File name or path based on unvalidated user-input may allow attackers to access
 *              arbitrary configuration file and source code in Java EE applications.
 * @kind path-problem
 * @id java/unsafe-resource-load
 * @tags security
 *       external/cwe/cwe-552
 *       external/cwe/cwe-022
 *       external/cwe/cwe-073
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import DataFlow::PathGraph

/** The class `java.lang.ClassLoader`. */
class ClassLoader extends RefType {
  ClassLoader() { this.hasQualifiedName("java.lang", "ClassLoader") }
}

/** The class `javax.servlet.ServletContext`. */
class ServletContext extends RefType {
  ServletContext() { this.hasQualifiedName("javax.servlet", "ServletContext") }
}

/** The resource loading method. */
class LoadResourceMethod extends Method {
  LoadResourceMethod() {
    (
      this.getDeclaringType().getASupertype*() instanceof ClassLoader or
      this.getDeclaringType().getASupertype*() instanceof ServletContext
    ) and
    this.getName() = ["getResource", "getResourcePaths", "getResourceAsStream", "getResources"]
  }
}

/**
 * Holds if the resource path in the string format is matched against another path,
 * probably a whitelisted one, and doesn't contain `..` characters for path navigation.
 */
predicate isStringPathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypeString and
  ma.getMethod().getName() = ["startsWith", "equals"] and
  exists(MethodAccess ma2 |
    ma2.getMethod().getDeclaringType() instanceof TypeString and
    ma2.getMethod().hasName("contains") and
    ma2.getAnArgument().(StringLiteral).getValue() = ".." and
    ma2.getQualifier().(VarAccess).getVariable().getAnAccess() = ma.getQualifier()
  )
}

/**
 * Holds if the resource path of the type `java.nio.file.Path` is matched against another
 * path, probably a whitelisted one.
 */
predicate isFilePathMatch(MethodAccess ma) {
  ma.getMethod().getDeclaringType() instanceof TypePath and
  ma.getMethod().getName() = ["startsWith", "equals"]
}

/** Taint configuration of unsafe resource loading. */
class LoadResourceConfig extends TaintTracking::Configuration {
  LoadResourceConfig() { this = "LoadResourceConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not exists(CompareResourcePathConfig cc, DataFlow::Node sink | cc.hasFlow(source, sink))
  }

  /** Sink of resource loading. */
  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof LoadResourceMethod and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}

/** Taint configuration of resource path comparison. */
class CompareResourcePathConfig extends TaintTracking2::Configuration {
  CompareResourcePathConfig() { this = "CompareResourcePathConfig" }

  override predicate isSource(DataFlow2::Node source) { source instanceof RemoteFlowSource }

  /** Sink of path matching check. */
  override predicate isSink(DataFlow2::Node sink) {
    exists(MethodAccess ma |
      (
        isStringPathMatch(ma) or
        isFilePathMatch(ma)
      ) and
      sink.asExpr() = ma.getQualifier()
    )
  }

  /** Path normalization. */
  override predicate isAdditionalTaintStep(DataFlow2::Node node1, DataFlow2::Node node2) {
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType() instanceof TypePath and
      ma.getMethod().getName() = ["get", "normalize", "resolve"] and
      (node1.asExpr() = ma.getQualifier() or node1.asExpr() = ma.getArgument(0)) and
      node2.asExpr() = ma
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, LoadResourceConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe request loading due to $@.", source.getNode(),
  "user-provided value"
