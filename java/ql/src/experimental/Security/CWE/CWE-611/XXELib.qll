import java
import semmle.code.java.dataflow.DataFlow3
import semmle.code.java.dataflow.DataFlow4
import semmle.code.java.dataflow.DataFlow5
import semmle.code.java.security.XmlParsers
private import semmle.code.java.dataflow.SSA

/** A data flow sink for untrusted user input used to insecure xml parse. */
class UnsafeXxeSink extends DataFlow::ExprNode {
  UnsafeXxeSink() {
    exists(XmlParserCall parse |
      parse.getSink() = this.getExpr() and
      not parse.isSafe()
    )
  }
}

/** The class `org.rundeck.api.parser.ParserHelper`. */
class ParserHelper extends RefType {
  ParserHelper() { this.hasQualifiedName("org.rundeck.api.parser", "ParserHelper") }
}

/** A call to `ParserHelper.loadDocument`. */
class ParserHelperLoadDocument extends XmlParserCall {
  ParserHelperLoadDocument() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof ParserHelper and
      m.hasName("loadDocument")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { none() }
}

/** The class `javax.xml.validation.Validator`. */
class Validator extends RefType {
  Validator() { this.hasQualifiedName("javax.xml.validation", "Validator") }
}

/** A call to `Validator.validate`. */
class ValidatorValidate extends XmlParserCall {
  ValidatorValidate() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof Validator and
      m.hasName("validate")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeValidatorFlowConfig svfc | svfc.hasFlowToExpr(this.getQualifier()))
  }
}

/** A `ParserConfig` specific to `Validator`. */
class ValidatorConfig extends TransformerConfig {
  ValidatorConfig() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof Validator and
      m.hasName("setProperty")
    )
  }
}

/** A safely configured `Validator`. */
class SafeValidator extends VarAccess {
  SafeValidator() {
    exists(Variable v | v = this.getVariable() |
      exists(ValidatorConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalDTD())
      ) and
      exists(ValidatorConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalSchema())
      )
    )
  }
}

private class SafeValidatorFlowConfig extends DataFlow3::Configuration {
  SafeValidatorFlowConfig() { this = "SafeValidatorFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeValidator }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod().getDeclaringType() instanceof Validator
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** The class `org.dom4j.DocumentHelper`. */
class DocumentHelper extends RefType {
  DocumentHelper() { this.hasQualifiedName("org.dom4j", "DocumentHelper") }
}

/** A call to `DocumentHelper.parseText`. */
class DocumentHelperParseText extends XmlParserCall {
  DocumentHelperParseText() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof DocumentHelper and
      m.hasName("parseText")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { none() }
}

/**
 * The classes `org.apache.commons.digester3.Digester`, `org.apache.commons.digester.Digester` or `org.apache.tomcat.util.digester.Digester`.
 */
class Digester extends RefType {
  Digester() {
    this.hasQualifiedName([
        "org.apache.commons.digester3", "org.apache.commons.digester",
        "org.apache.tomcat.util.digester"
      ], "Digester")
  }
}

/** A call to `Digester.parse`. */
class DigesterParse extends XmlParserCall {
  DigesterParse() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof Digester and
      m.hasName("parse")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeDigesterFlowConfig sdfc | sdfc.hasFlowToExpr(this.getQualifier()))
  }
}

/** A `ParserConfig` that is specific to `Digester`. */
class DigesterConfig extends ParserConfig {
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
class SafeDigester extends VarAccess {
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

private class SafeDigesterFlowConfig extends DataFlow4::Configuration {
  SafeDigesterFlowConfig() { this = "SafeDigesterFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeDigester }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod().getDeclaringType() instanceof Digester
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** The class `java.beans.XMLDecoder`. */
class XmlDecoder extends RefType {
  XmlDecoder() { this.hasQualifiedName("java.beans", "XMLDecoder") }
}

/** DEPRECATED: Alias for XmlDecoder */
deprecated class XMLDecoder = XmlDecoder;

/** A call to `XMLDecoder.readObject`. */
class XmlDecoderReadObject extends XmlParserCall {
  XmlDecoderReadObject() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof XmlDecoder and
      m.hasName("readObject")
    )
  }

  override Expr getSink() { result = this.getQualifier() }

  override predicate isSafe() { none() }
}

/** DEPRECATED: Alias for XmlDecoderReadObject */
deprecated class XMLDecoderReadObject = XmlDecoderReadObject;

private predicate constantStringExpr(Expr e, string val) {
  e.(CompileTimeConstantExpr).getStringValue() = val
  or
  exists(SsaExplicitUpdate v, Expr src |
    e = v.getAUse() and
    src = v.getDefiningExpr().(VariableAssign).getSource() and
    constantStringExpr(src, val)
  )
}

/** A call to `SAXTransformerFactory.newTransformerHandler`. */
class SaxTransformerFactoryNewTransformerHandler extends XmlParserCall {
  SaxTransformerFactoryNewTransformerHandler() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType().hasQualifiedName("javax.xml.transform.sax", "SAXTransformerFactory") and
      m.hasName("newTransformerHandler")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeTransformerFactoryFlowConfig stf | stf.hasFlowToExpr(this.getQualifier()))
  }
}

/** DEPRECATED: Alias for SaxTransformerFactoryNewTransformerHandler */
deprecated class SAXTransformerFactoryNewTransformerHandler =
  SaxTransformerFactoryNewTransformerHandler;

/** An expression that always has the same string value. */
private class ConstantStringExpr extends Expr {
  string value;

  ConstantStringExpr() { constantStringExpr(this, value) }

  /** Get the string value of this expression. */
  string getStringValue() { result = value }
}
