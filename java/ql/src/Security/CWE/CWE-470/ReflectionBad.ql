/**
 * @name Unsafe reflection
 * @description External input with reflection to select which classes to use
 * @kind reflection
 * @problem.severity warning
 * @precision medium
 * @id java/unsafe-reflection
 * @tags security
 *       external/cwe/cwe-470
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class ClassFornameMethod extends Method {
  ClassFornameMethod() {
    this.getDeclaringType().getSourceDeclaration().hasQualifiedName("java.lang", "Class") and
    this.hasName("forName")
  }
}

class ArgumentToReflection extends Expr {
  ArgumentToReflection() {
    exists(MethodAccess ma, Method method |
      ma.getArgument(0) = this and
      method = ma.getMethod() and
      method instanceof ClassFornameMethod
    )
  }
}

class StringArgumentToReflection extends ArgumentToReflection {
  StringArgumentToReflection() { this.getType() instanceof TypeString }
}

class UnsafeReflectionConfig extends TaintTracking::Configuration {
  UnsafeReflectionConfig() { this = "UnsafeReflectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof ArgumentToReflection }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeReflectionConfig conf,
  StringArgumentToReflection reflectionArg
where conf.hasFlowPath(source, sink) and sink.getNode().asExpr() = reflectionArg
select reflectionArg, source, sink, "$@ flows to here and is used in reflection", source.getNode(),
  "User controlled value"
