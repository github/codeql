/** Provides classes and predicates to reason about XML external entities (XXE) vulnerabilities. */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.TaintTracking
private import codeql.swift.frameworks.Xml.Xml
private import codeql.swift.dataflow.ExternalFlow

/** A data flow sink for XML external entities (XXE) vulnerabilities. */
abstract class XxeSink extends DataFlow::Node { }

/** A barrier for XML external entities (XXE) vulnerabilities. */
abstract class XxeBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class XxeAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to XML external entities (XXE) vulnerabilities.
   */
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

/** The XML argument of a `XMLParser` vulnerable to XXE. */
private class XmlParserXxeSink extends XxeSink {
  XmlParserXxeSink() {
    this.asExpr() = any(Argument a | a.getApplyExpr() instanceof VulnerableParser).getExpr()
  }
}

/** The construction of a `XMLParser` that enables external entities. */
private class VulnerableParser extends CallExpr {
  VulnerableParser() {
    resolvesExternalEntities(this) and this.getFunction() instanceof InitializerLookupExpr
  }
}

/** Holds if there is an access of `ref` that sets `shouldResolveExternalEntities` to `true`. */
private predicate resolvesExternalEntities(XmlParserRef ref) {
  exists(XmlParserRef base |
    DataFlow::localExprFlow(ref, base) or DataFlow::localExprFlow(base, ref)
  |
    exists(AssignExpr assign, ShouldResolveExternalEntities s, BooleanLiteralExpr b |
      s.getBase() = base and
      assign.getDest() = s and
      b.getValue() = true and
      DataFlow::localExprFlow(b, assign.getSource())
    )
  )
}

/** A reference to the field `XMLParser.shouldResolveExternalEntities`. */
private class ShouldResolveExternalEntities extends MemberRefExpr {
  ShouldResolveExternalEntities() {
    this.getMember().(FieldDecl).getName() = "shouldResolveExternalEntities" and
    this.getBase() instanceof XmlParserRef
  }
}

/** An expression of type `XMLParser`. */
private class XmlParserRef extends Expr {
  XmlParserRef() {
    this.getType() instanceof XmlParserType or
    this.getType() = any(OptionalType t | t.getBaseType() instanceof XmlParserType)
  }
}

/** The type `XMLParser`. */
private class XmlParserType extends NominalType {
  XmlParserType() { this.getFullName() = "XMLParser" }
}

/** The XML argument of a `XMLDocument` vulnerable to XXE. */
private class XmlDocumentXxeSink extends XxeSink {
  XmlDocumentXxeSink() { this.asExpr() = any(VulnerableXmlDocument d).getArgument(0).getExpr() }
}

/** An `XMLDocument` that sets `nodeLoadExternalEntitiesAlways` in its options. */
private class VulnerableXmlDocument extends ApplyExpr {
  VulnerableXmlDocument() {
    this.getStaticTarget().(Initializer).getEnclosingDecl().asNominalTypeDecl().getFullName() =
      "XMLDocument" and
    this.getArgument(1).getExpr().(ArrayExpr).getAnElement().(MemberRefExpr).getMember() instanceof
      NodeLoadExternalEntitiesAlways
  }
}

/** The option `XMLNode.Options.nodeLoadExternalEntitiesAlways`. */
private class NodeLoadExternalEntitiesAlways extends VarDecl {
  NodeLoadExternalEntitiesAlways() {
    this.getName() = "nodeLoadExternalEntitiesAlways" and
    this.getEnclosingDecl().asNominalTypeDecl().(StructDecl).getFullName() = "XMLNode.Options"
  }
}

/** The XML argument of an `AEXMLDocument` vulnerable to XXE. */
private class AexmlDocumentSink extends XxeSink {
  AexmlDocumentSink() {
    // `AEXMLDocument` initialized with vulnerable options.
    exists(ApplyExpr call | this.asExpr() = call.getArgument(0).getExpr() |
      call.(VulnerableAexmlDocument)
          .getStaticTarget()
          .hasName(["init(xml:options:)", "init(xml:encoding:options:)"])
      or
      // `loadXML` called on a vulnerable AEXMLDocument.
      DataFlow::localExprFlow(any(VulnerableAexmlDocument v),
        call.(AexmlDocumentLoadXml).getQualifier())
    )
  }
}

/** The XML argument of an `AEXMLParser` initialized with an `AEXMLDocument` vulnerable to XXE. */
private class AexmlParserSink extends XxeSink {
  AexmlParserSink() {
    exists(AexmlParser parser | this.asExpr() = parser.getArgument(1).getExpr() |
      DataFlow::localExprFlow(any(VulnerableAexmlDocument v), parser.getArgument(0).getExpr())
    )
  }
}

/** The creation of an `AEXMLDocument` that receives a vulnerable `AEXMLOptions` argument. */
private class VulnerableAexmlDocument extends AexmlDocument {
  VulnerableAexmlDocument() {
    exists(AexmlOptions optionsArgument, VulnerableAexmlOptions vulnOpts |
      this.getAnArgument().getExpr() = optionsArgument and
      DataFlow::localExprFlow(vulnOpts, optionsArgument)
    )
  }
}

/**
 * An `AEXMLOptions` object which contains a `parserSettings` with `shouldResolveExternalEntities`
 * set to `true`.
 */
private class VulnerableAexmlOptions extends AexmlOptions {
  VulnerableAexmlOptions() {
    exists(
      AexmlParserSettings parserSettings, AexmlShouldResolveExternalEntities sree, AssignExpr a
    |
      a.getSource() = any(BooleanLiteralExpr b | b.getValue() = true) and
      a.getDest() = sree and
      sree.(MemberRefExpr).getBase() = parserSettings and
      parserSettings.(MemberRefExpr).getBase() = this
    )
  }
}

/** An expression of type `AEXMLOptions.ParserSettings`. */
private class AexmlParserSettings extends Expr {
  pragma[inline]
  AexmlParserSettings() {
    this.getType() instanceof AexmlOptionsParserSettingsType or
    this.getType() = any(OptionalType t | t.getBaseType() instanceof AexmlOptionsParserSettingsType) or
    this.getType() = any(LValueType t | t.getObjectType() instanceof AexmlOptionsParserSettingsType)
  }
}

/** An expression of type `AEXMLOptions`. */
private class AexmlOptions extends Expr {
  pragma[inline]
  AexmlOptions() {
    this.getType() instanceof AexmlOptionsType or
    this.getType() = any(OptionalType t | t.getBaseType() instanceof AexmlOptionsType) or
    this.getType() = any(LValueType t | t.getObjectType() instanceof AexmlOptionsType)
  }
}

/** The XML argument of a `libxml2` parsing call vulnerable to XXE. */
private class Libxml2XxeSink extends XxeSink {
  Libxml2XxeSink() {
    exists(Libxml2ParseCall c, Libxml2BadOption opt |
      this.asExpr() = c.getXml() and
      TaintTracking::localTaintStep*(DataFlow::exprNode(opt.getAnAccess()),
        DataFlow::exprNode(c.getOptions()))
    )
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultXxeSink extends XxeSink {
  DefaultXxeSink() { sinkNode(this, "xxe") }
}
