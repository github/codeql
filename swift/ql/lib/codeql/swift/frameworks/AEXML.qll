/**
 * Provides models for the AEXML library.
 */

import swift

/** The creation of an `AEXMLParser`. */
class AexmlParser extends ApplyExpr {
  AexmlParser() {
    this.getStaticTarget().(ConstructorDecl).getEnclosingDecl() instanceof AexmlParserDecl
  }
}

/** The creation of an `AEXMLDocument`. */
class AexmlDocument extends ApplyExpr {
  AexmlDocument() {
    this.getStaticTarget().(ConstructorDecl).getEnclosingDecl() instanceof AexmlDocumentDecl
  }
}

/** A call to `AEXMLDocument.loadXML(_:)`. */
class AexmlDocumentLoadXml extends MethodApplyExpr {
  AexmlDocumentLoadXml() {
    exists(MethodDecl f |
      this.getStaticTarget() = f and
      f.hasName("loadXML(_:)") and
      f.getEnclosingDecl() instanceof AexmlDocumentDecl
    )
  }
}

/** The class `AEXMLParser`. */
class AexmlParserDecl extends ClassDecl {
  AexmlParserDecl() { this.getFullName() = "AEXMLParser" }
}

/** The class `AEXMLDocument`. */
class AexmlDocumentDecl extends ClassDecl {
  AexmlDocumentDecl() { this.getFullName() = "AEXMLDocument" }
}

/** A reference to the field `AEXMLOptions.ParserSettings.shouldResolveExternalEntities`. */
class AexmlShouldResolveExternalEntities extends MemberRefExpr {
  AexmlShouldResolveExternalEntities() {
    exists(FieldDecl f | this.getMember() = f |
      f.getName() = "shouldResolveExternalEntities" and
      f.getEnclosingDecl().(NominalTypeDecl).getType() instanceof AexmlOptionsParserSettingsType
    )
  }
}

/** The type `AEXMLOptions`. */
class AexmlOptionsType extends StructType {
  AexmlOptionsType() { this.getFullName() = "AEXMLOptions" }
}

/** The type `AEXMLOptions.ParserSettings`. */
class AexmlOptionsParserSettingsType extends StructType {
  AexmlOptionsParserSettingsType() { this.getFullName() = "AEXMLOptions.ParserSettings" }
}
