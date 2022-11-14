/** Provides classes and predicates to reason about XML external entities (XXE) vulnerabilities. */

import swift
private import codeql.swift.dataflow.DataFlow

/** A data flow sink for XML external entities (XXE) vulnerabilities. */
abstract class XxeSink extends DataFlow::Node { }

/** A sanitizer for XML external entities (XXE) vulnerabilities. */
abstract class XxeSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to paths related to
 * XML external entities (XXE) vulnerabilities.
 */
class XxeAdditionalTaintStep extends Unit {
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

/** The XML argument of a `XMLParser` vulnerable to XXE. */
private class DefaultXxeSink extends XxeSink {
  DefaultXxeSink() {
    this.asExpr() = any(Argument a | a.getApplyExpr() instanceof VulnerableParser).getExpr()
  }
}

/** The construction of a `XMLParser` that enables external entities. */
private class VulnerableParser extends CallExpr {
  VulnerableParser() {
    resolvesExternalEntities(this) and this.getFunction() instanceof ConstructorRefCallExpr
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
