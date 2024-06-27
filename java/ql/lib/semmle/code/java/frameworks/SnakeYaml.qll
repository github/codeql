/**
 * Provides classes and predicates for working with the SnakeYaml serialization framework.
 */

import java
import semmle.code.java.dataflow.DataFlow

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
  SafeSnakeYamlConstruction() { this.getConstructedType() instanceof SnakeYamlSafeConstructor }
}

/**
 * The class `org.yaml.snakeyaml.Yaml`.
 */
class Yaml extends RefType {
  Yaml() { this.getAnAncestor().hasQualifiedName("org.yaml.snakeyaml", "Yaml") }
}

private DataFlow::ExprNode yamlClassInstanceExprArgument(ClassInstanceExpr cie) {
  cie.getConstructedType() instanceof Yaml and
  result.getExpr() = cie.getArgument(0)
}

private module SafeYamlConstructionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSnakeYamlConstruction }

  predicate isSink(DataFlow::Node sink) { sink = yamlClassInstanceExprArgument(_) }

  additional ClassInstanceExpr getSafeYaml() {
    SafeYamlConstructionFlow::flowTo(yamlClassInstanceExprArgument(result))
  }
}

private module SafeYamlConstructionFlow = DataFlow::Global<SafeYamlConstructionFlowConfig>;

/**
 * An instance of `Yaml` that does not allow arbitrary constructor to be called.
 */
private class SafeYaml extends ClassInstanceExpr {
  SafeYaml() { SafeYamlConstructionFlowConfig::getSafeYaml() = this }
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

private module SafeYamlFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeYaml }

  predicate isSink(DataFlow::Node sink) { sink = yamlParseQualifier(_) }

  additional DataFlow::ExprNode yamlParseQualifier(SnakeYamlParse syp) {
    result.getExpr() = syp.getQualifier()
  }

  additional SnakeYamlParse getASafeSnakeYamlParse() {
    SafeYamlFlow::flowTo(yamlParseQualifier(result))
  }
}

private module SafeYamlFlow = DataFlow::Global<SafeYamlFlowConfig>;

/**
 * A call to a parse method of `Yaml` that allows arbitrary constructor to be called.
 */
class UnsafeSnakeYamlParse extends SnakeYamlParse {
  UnsafeSnakeYamlParse() { not SafeYamlFlowConfig::getASafeSnakeYamlParse() = this }
}
