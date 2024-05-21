/**
 * Provides classes and predicates for working with XML files and their content.
 */

import semmle.files.FileSystem
private import semmle.javascript.internal.Locations
private import codeql.xml.Xml

private module Input implements InputSig<File, DbLocation> {
  class XmlLocatableBase = @xmllocatable or @xmlnamespaceable;

  predicate xmllocations_(XmlLocatableBase e, DbLocation loc) { loc = getLocatableLocation(e) }

  class XmlParentBase = @xmlparent;

  class XmlNamespaceableBase = @xmlnamespaceable;

  class XmlElementBase = @xmlelement;

  class XmlFileBase = File;

  predicate xmlEncoding_(XmlFileBase f, string enc) { xmlEncoding(f, enc) }

  class XmlDtdBase = @xmldtd;

  predicate xmlDTDs_(XmlDtdBase e, string root, string publicId, string systemId, XmlFileBase file) {
    xmlDTDs(e, root, publicId, systemId, file)
  }

  predicate xmlElements_(
    XmlElementBase e, string name, XmlParentBase parent, int idx, XmlFileBase file
  ) {
    xmlElements(e, name, parent, idx, file)
  }

  class XmlAttributeBase = @xmlattribute;

  predicate xmlAttrs_(
    XmlAttributeBase e, XmlElementBase elementid, string name, string value, int idx,
    XmlFileBase file
  ) {
    xmlAttrs(e, elementid, name, value, idx, file)
  }

  class XmlNamespaceBase = @xmlnamespace;

  predicate xmlNs_(XmlNamespaceBase e, string prefixName, string uri, XmlFileBase file) {
    xmlNs(e, prefixName, uri, file)
  }

  predicate xmlHasNs_(XmlNamespaceableBase e, XmlNamespaceBase ns, XmlFileBase file) {
    xmlHasNs(e, ns, file)
  }

  class XmlCommentBase = @xmlcomment;

  predicate xmlComments_(XmlCommentBase e, string text, XmlParentBase parent, XmlFileBase file) {
    xmlComments(e, text, parent, file)
  }

  class XmlCharactersBase = @xmlcharacters;

  predicate xmlChars_(
    XmlCharactersBase e, string text, XmlParentBase parent, int idx, int isCDATA, XmlFileBase file
  ) {
    xmlChars(e, text, parent, idx, isCDATA, file)
  }
}

import Make<File, DbLocation, Input>
