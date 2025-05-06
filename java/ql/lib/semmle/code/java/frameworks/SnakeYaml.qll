/**
 * Provides classes and predicates for working with the SnakeYaml serialization framework.
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking

/**
 * The class `org.yaml.snakeyaml.constructor.SafeConstructor`.
 */
class SnakeYamlSafeConstructor extends RefType {
  SnakeYamlSafeConstructor() {
    this.hasQualifiedName("org.yaml.snakeyaml.constructor", "SafeConstructor")
  }
}

/**
 * An instance of `SafeConstructor`.
 */
class SafeSnakeYamlConstruction extends ClassInstanceExpr {
  SafeSnakeYamlConstruction() {
    this.getConstructedType().getASourceSupertype*() instanceof SnakeYamlSafeConstructor
  }
}

/**
 * The class `org.yaml.snakeyaml.Yaml`.
 */
class Yaml extends RefType {
  Yaml() { this.getAnAncestor().hasQualifiedName("org.yaml.snakeyaml", "Yaml") }
}

/** A call to a parse method of `Yaml`. */
private class SnakeYamlParse extends MethodCall {
  SnakeYamlParse() {
    exists(Method m |
      m.getDeclaringType() instanceof Yaml and
      m.hasName(["compose", "composeAll", "load", "loadAll", "loadAs", "parse"]) and
      m = this.getMethod()
    )
  }
}

private class TagInspector extends Interface {
  TagInspector() { this.hasQualifiedName("org.yaml.snakeyaml.inspector", "TagInspector") }
}

private class LoaderOptions extends Class {
  LoaderOptions() { this.hasQualifiedName("org.yaml.snakeyaml", "LoaderOptions") }
}

private class SnakeYamlBaseConstructor extends Class {
  SnakeYamlBaseConstructor() {
    this.hasQualifiedName("org.yaml.snakeyaml.constructor", "BaseConstructor")
  }
}

private class IsGlobalTagAllowed extends Method {
  IsGlobalTagAllowed() {
    this.getDeclaringType().getASourceSupertype*() instanceof TagInspector and
    this.hasName("isGlobalTagAllowed")
  }
}

/**
 * Holds if `m` always returns `true` ignoring any exceptional flow.
 */
private predicate alwaysAllowsGlobalTags(IsGlobalTagAllowed m) {
  forex(ReturnStmt rs | rs.getEnclosingCallable() = m |
    rs.getResult().(CompileTimeConstantExpr).getBooleanValue() = true
  )
}

/**
 * A class that overrides the `org.yaml.snakeyaml.inspector.TagInspector.IsGlobalTagAllowed` method and **always** returns `true` (though it could also exit due to an uncaught exception),
 * thus allowing arbitrary code execution when untrusted data is deserialized.
 */
private class UnsafeTagInspector extends RefType {
  UnsafeTagInspector() {
    this.getAnAncestor() instanceof TagInspector and
    alwaysAllowsGlobalTags(this.getAMethod())
  }
}

/**
 * A configuration to model the flow of a `UnsafeTagInspector` to the qualifier of a `SnakeYamlParse` call.
 */
private module UnsafeTagInspectorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(ClassInstanceExpr).getConstructedType() instanceof UnsafeTagInspector
  }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      m.getDeclaringType() instanceof LoaderOptions and
      m.hasName("setTagInspector")
    |
      n1.asExpr() = ma.getArgument(0) and
      n2.asExpr() = ma.getQualifier()
    )
    or
    exists(ConstructorCall cc, Constructor c, int argIdx |
      c.getDeclaringType().getAnAncestor() instanceof SnakeYamlBaseConstructor and
      c.getParameterType(argIdx) instanceof LoaderOptions
      or
      c.getDeclaringType() instanceof Yaml and
      (
        c.getParameterType(argIdx) instanceof LoaderOptions or
        c.getParameterType(argIdx).(RefType).getAnAncestor() instanceof SnakeYamlBaseConstructor
      )
    |
      cc.getConstructor() = c and n1.asExpr() = cc.getArgument(argIdx) and n2.asExpr() = cc
    )
  }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(SnakeYamlParse p).getQualifier() }
}

private module UnsafeTagInspectorFlow = TaintTracking::Global<UnsafeTagInspectorConfig>;

/**
 * A call to a parse method of `Yaml` that allows arbitrary constructor to be called.
 */
class UnsafeSnakeYamlParse extends SnakeYamlParse {
  UnsafeSnakeYamlParse() { UnsafeTagInspectorFlow::flowToExpr(this.getQualifier()) }
}
