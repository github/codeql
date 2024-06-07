/** Provides definitions related to the `javax.xml` package. */

import java
private import semmle.code.java.security.XmlParsers

/** A call to `Validator.validate`. */
private class ValidatorValidate extends XmlParserCall {
  ValidatorValidate() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof Validator and
      m.hasName("validate")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { SafeValidatorFlow::flowToExpr(this.getQualifier()) }
}

/** A `TransformerConfig` specific to `Validator`. */
private class ValidatorConfig extends TransformerConfig {
  ValidatorConfig() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof Validator and
      m.hasName("setProperty")
    )
  }
}

/** The class `javax.xml.validation.Validator`. */
private class Validator extends RefType {
  Validator() { this.hasQualifiedName("javax.xml.validation", "Validator") }
}

/** A safely configured `Validator`. */
private class SafeValidator extends VarAccess {
  SafeValidator() {
    exists(Variable v | v = this.getVariable() |
      exists(ValidatorConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalDtd())
      ) and
      exists(ValidatorConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalSchema())
      )
    )
  }
}

private module SafeValidatorFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeValidator }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod().getDeclaringType() instanceof Validator
    )
  }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeValidatorFlow = DataFlow::Global<SafeValidatorFlowConfig>;
