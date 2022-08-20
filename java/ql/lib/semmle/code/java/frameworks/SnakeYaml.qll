/**
 * Provides classes and predicates for working with the SnakeYaml serialization framework.
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.DataFlow3

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

private class SafeYamlConstructionFlowConfig extends DataFlow3::Configuration {
  SafeYamlConstructionFlowConfig() { this = "SnakeYaml::SafeYamlConstructionFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof SafeSnakeYamlConstruction
  }

  override predicate isSink(DataFlow::Node sink) { sink = this.yamlClassInstanceExprArgument(_) }

  private DataFlow::ExprNode yamlClassInstanceExprArgument(ClassInstanceExpr cie) {
    cie.getConstructedType() instanceof Yaml and
    result.getExpr() = cie.getArgument(0)
  }

  ClassInstanceExpr getSafeYaml() { this.hasFlowTo(this.yamlClassInstanceExprArgument(result)) }
}

/**
 * An instance of `Yaml` that does not allow arbitrary constructor to be called.
 */
private class SafeYaml extends ClassInstanceExpr {
  SafeYaml() { exists(SafeYamlConstructionFlowConfig conf | conf.getSafeYaml() = this) }
}

/** A call to a parse method of `Yaml`. */
private class SnakeYamlParse extends MethodAccess {
  SnakeYamlParse() {
    exists(Method m |
      m.getDeclaringType() instanceof Yaml and
      m.hasName(["compose", "composeAll", "load", "loadAll", "loadAs", "parse"]) and
      m = this.getMethod()
    )
  }
}

private class SafeYamlFlowConfig extends DataFlow2::Configuration {
  SafeYamlFlowConfig() { this = "SnakeYaml::SafeYamlFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeYaml }

  override predicate isSink(DataFlow::Node sink) { sink = this.yamlParseQualifier(_) }

  private DataFlow::ExprNode yamlParseQualifier(SnakeYamlParse syp) {
    result.getExpr() = syp.getQualifier()
  }

  SnakeYamlParse getASafeSnakeYamlParse() { this.hasFlowTo(this.yamlParseQualifier(result)) }
}

/**
 * A call to a parse method of `Yaml` that allows arbitrary constructor to be called.
 */
class UnsafeSnakeYamlParse extends SnakeYamlParse {
  UnsafeSnakeYamlParse() { not exists(SafeYamlFlowConfig sy | sy.getASafeSnakeYamlParse() = this) }
}
