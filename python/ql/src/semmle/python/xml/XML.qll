/**
 * A library for working with XML files and their content.
 */

import semmle.python.Files

/** An XML element that has a location. */
abstract class XMLLocatable extends @xmllocatable {
  /** The source location for this element. */
  Location getLocation() { xmllocations(this,result) }

  /**
   * Whether this element has the specified location information,
   * including file path, start line, start column, end line and end column.
   */
  predicate hasLocationInfo(string filepath, int startline, int startcolumn, int endline, int endcolumn) {
    exists(File f, Location l | l = this.getLocation() |
      locations_default(l,f,startline,startcolumn,endline,endcolumn) and
      filepath = f.getName()
    )
  }

  /** A printable representation of this element. */
  abstract string toString();
}

/**
 * An `XMLParent` is either an `XMLElement` or an `XMLFile`,
 * both of which can contain other elements.
 */
class XMLParent extends @xmlparent {
  /**
   * A printable representation of this XML parent.
   * (Intended to be overridden in subclasses.)
   */
  /*abstract*/ string getName() { result = "parent" }

  /** The file to which this XML parent belongs. */
  XMLFile getFile() { result = this or xmlElements(this,_,_,_,result) }

  /** The child element at a specified index of this XML parent. */
  XMLElement getChild(int index) { xmlElements(result, _, this, index, _) }

  /** A child element of this XML parent. */
  XMLElement getAChild() { xmlElements(result,_,this,_,_) }

  /** A child element of this XML parent with the given `name`. */
  XMLElement getAChild(string name) { xmlElements(result,_,this,_,_) and result.hasName(name) }

  /** A comment that is a child of this XML parent. */
  XMLComment getAComment() { xmlComments(result,_,this,_) }

  /** A character sequence that is a child of this XML parent. */
  XMLCharacters getACharactersSet() { xmlChars(result,_,this,_,_,_)  }

  /** The depth in the tree. (Overridden in XMLElement.) */
  int getDepth() { result = 0 }

  /** The number of child XML elements of this XML parent. */
  int getNumberOfChildren() {
    result = count(XMLElement e | xmlElements(e,_,this,_,_))
  }

  /** The number of places in the body of this XML parent where text occurs. */
  int getNumberOfCharacterSets() {
    result = count(int pos | xmlChars(_,_,this,pos,_,_))
  }

  /**
   * Append the character sequences of this XML parent from left to right, separated by a space,
   * up to a specified (zero-based) index.
   */
  string charsSetUpTo(int n) {
    (n = 0 and xmlChars(_,result,this,0,_,_)) or
    (n > 0 and exists(string chars | xmlChars(_,chars,this,n,_,_) |
                         result = this.charsSetUpTo(n-1) + " " + chars))
  }

  /** Append all the character sequences of this XML parent from left to right, separated by a space. */
  string allCharactersString() {
    exists(int n | n = this.getNumberOfCharacterSets() |
      (n = 0 and result = "") or
      (n > 0 and result = this.charsSetUpTo(n-1))
    )
  }

  /** The text value contained in this XML parent. */
  string getTextValue() {
    result = allCharactersString()
  }

  /** A printable representation of this XML parent. */
  string toString() { result = this.getName() }
}

/** An XML file. */
class XMLFile extends XMLParent, File {
  XMLFile() {
    xmlEncoding(this,_)
  }

  /** A printable representation of this XML file. */
  override
  string toString() { result = XMLParent.super.toString() }

  /** The name of this XML file. */
  override
  string getName() { files(this,result,_,_,_) }

  /** The path of this XML file. */
  string getPath() { files(this,_,result,_,_) }

  /** The path of the folder that contains this XML file. */
  string getFolder() {
    result = this.getPath().substring(0, this.getPath().length()-this.getName().length())
  }

  /** The encoding of this XML file. */
  string getEncoding() { xmlEncoding(this,result) }

  /** The XML file itself. */
  override
  XMLFile getFile() { result = this }

  /** A top-most element in an XML file. */
  XMLElement getARootElement() { result = this.getAChild() }

  /** A DTD associated with this XML file. */
  XMLDTD getADTD() { xmlDTDs(result,_,_,_,this) }
}

/** A "Document Type Definition" of an XML file. */
class XMLDTD extends @xmldtd {
  /** The name of the root element of this DTD. */
  string getRoot() { xmlDTDs(this,result,_,_,_) }

  /** The public ID of this DTD. */
  string getPublicId() { xmlDTDs(this,_,result,_,_) }

  /** The system ID of this DTD. */
  string getSystemId() { xmlDTDs(this,_,_,result,_) }

  /** Whether this DTD is public. */
  predicate isPublic() { not xmlDTDs(this,_,"",_,_) }

  /** The parent of this DTD. */
  XMLParent getParent() { xmlDTDs(this,_,_,_,result) }

  /** A printable representation of this DTD. */
  string toString() {
    (this.isPublic() and result = this.getRoot() + " PUBLIC '" +
                                  this.getPublicId() + "' '" +
                                  this.getSystemId() + "'") or
    (not this.isPublic() and result = this.getRoot() +
                                      " SYSTEM '" +
                                      this.getSystemId() + "'")
  }
}

/** An XML tag in an XML file. */
class XMLElement extends @xmlelement, XMLParent, XMLLocatable {
  /** Whether this XML element has the given `name`. */
  predicate hasName(string name) { name = getName() }

  /** The name of this XML element. */
  override
  string getName() { xmlElements(this,result,_,_,_) }

  /** The XML file in which this XML element occurs. */
  override
  XMLFile getFile() { xmlElements(this,_,_,_,result) }

  /** The parent of this XML element. */
  XMLParent getParent() { xmlElements(this,_,result,_,_) }

  /** The index of this XML element among its parent's children. */
  int getIndex() { xmlElements(this, _, _, result, _) }

  /** Whether this XML element has a namespace. */
  predicate hasNamespace() { xmlHasNs(this,_,_) }

  /** The namespace of this XML element, if any. */
  XMLNamespace getNamespace() { xmlHasNs(this,result,_) }

  /** The index of this XML element among its parent's children. */
  int getElementPositionIndex() { xmlElements(this,_,_,result,_) }

  /** The depth of this element within the XML file tree structure. */
  override
  int getDepth() { result = this.getParent().getDepth() + 1 }

  /** An XML attribute of this XML element. */
  XMLAttribute getAnAttribute() { result.getElement() = this }

  /** The attribute with the specified `name`, if any. */
  XMLAttribute getAttribute(string name) {
    result.getElement() = this and result.getName() = name
  }

  /** Whether this XML element has an attribute with the specified `name`. */
  predicate hasAttribute(string name) {
    exists(XMLAttribute a| a = this.getAttribute(name))
  }

  /** The value of the attribute with the specified `name`, if any. */
  string getAttributeValue(string name) {
    result = this.getAttribute(name).getValue()
  }

  /** A printable representation of this XML element. */
  override
  string toString() { result = XMLParent.super.toString() }
}

/** An attribute that occurs inside an XML element. */
class XMLAttribute extends @xmlattribute, XMLLocatable {
  /** The name of this attribute. */
  string getName() { xmlAttrs(this,_,result,_,_,_) }

  /** The XML element to which this attribute belongs. */
  XMLElement getElement() { xmlAttrs(this,result,_,_,_,_) }

  /** Whether this attribute has a namespace. */
  predicate hasNamespace() { xmlHasNs(this,_,_) }

  /** The namespace of this attribute, if any. */
  XMLNamespace getNamespace() { xmlHasNs(this,result,_) }

  /** The value of this attribute. */
  string getValue() { xmlAttrs(this,_,_,result,_,_) }

  /** A printable representation of this XML attribute. */
  override string toString() { result = this.getName() + "=" + this.getValue() }
}

/** A namespace used in an XML file */
class XMLNamespace extends @xmlnamespace {
  /** The prefix of this namespace. */
  string getPrefix() { xmlNs(this,result,_,_) }

  /** The URI of this namespace. */
  string getURI() { xmlNs(this,_,result,_) }

  /** Whether this namespace has no prefix. */
  predicate isDefault() { this.getPrefix() = "" }

  /** A printable representation of this XML namespace. */
  string toString() {
    (this.isDefault() and result = this.getURI()) or
    (not this.isDefault() and result = this.getPrefix() + ":" + this.getURI())
  }
}

/** A comment of the form `<!-- ... -->` is an XML comment. */
class XMLComment extends @xmlcomment, XMLLocatable {
  /** The text content of this XML comment. */
  string getText() { xmlComments(this,result,_,_) }

  /** The parent of this XML comment. */
  XMLParent getParent() { xmlComments(this,_,result,_) }

  /** A printable representation of this XML comment. */
  override string toString() { result = this.getText() }
}

/**
 * A sequence of characters that occurs between opening and
 * closing tags of an XML element, excluding other elements.
 */
class XMLCharacters extends @xmlcharacters, XMLLocatable {
  /** The content of this character sequence. */
  string getCharacters() { xmlChars(this,result,_,_,_,_) }

  /** The parent of this character sequence. */
  XMLParent getParent() { xmlChars(this,_,result,_,_,_) }

  /** Whether this character sequence is CDATA. */
  predicate isCDATA() { xmlChars(this,_,_,_,1,_) }

  /** A printable representation of this XML character sequence. */
  override string toString() { result = this.getCharacters() }
}
