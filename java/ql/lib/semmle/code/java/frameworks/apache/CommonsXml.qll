/** Provides XML definitions related to the `org.apache.commons` package. */

import java
private import semmle.code.java.dataflow.RangeUtils
private import semmle.code.java.security.XmlParsers

/**
 * The classes `org.apache.commons.digester3.Digester`, `org.apache.commons.digester.Digester` or `org.apache.tomcat.util.digester.Digester`.
 */
private class Digester extends RefType {
  Digester() {
    this.hasQualifiedName([
        "org.apache.commons.digester3", "org.apache.commons.digester",
        "org.apache.tomcat.util.digester"
      ], "Digester")
  }
}

/** A call to `Digester.parse`. */
private class DigesterParse extends XmlParserCall {
  DigesterParse() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof Digester and
      m.hasName("parse")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { SafeDigesterFlow::flowToExpr(this.getQualifier()) }
}

/** A `ParserConfig` that is specific to `Digester`. */
private class DigesterConfig extends ParserConfig {
  DigesterConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof Digester and
      m.hasName("setFeature")
    )
  }
}

/**
 * A safely configured `Digester`.
 */
private class SafeDigester extends VarAccess {
  SafeDigester() {
    exists(Variable v | v = this.getVariable() |
      exists(DigesterConfig config | config.getQualifier() = v.getAnAccess() |
        config.enables(singleSafeConfig())
      )
      or
      exists(DigesterConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-general-entities"
              ))
      ) and
      exists(DigesterConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-parameter-entities"
              ))
      ) and
      exists(DigesterConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() =
                  "http://apache.org/xml/features/nonvalidating/load-external-dtd"
              ))
      )
    )
  }
}

private module SafeDigesterFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeDigester }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod().getDeclaringType() instanceof Digester
    )
  }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeDigesterFlow = DataFlow::Global<SafeDigesterFlowConfig>;
