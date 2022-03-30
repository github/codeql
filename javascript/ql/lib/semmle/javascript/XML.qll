/**
 * Provides classes and predicates for working with XML files and their content.
 */

import semmle.files.FileSystem

private class TXmlLocatable =
  @xmldtd or @xmlelement or @xmlattribute or @xmlnamespace or @xmlcomment or @xmlcharacters;

/** An XML element that has a location. */
class XMLLocatable extends @xmllocatable, TXmlLocatable {
  /** Gets the source location for this element. */
  Location getLocation() { xmllocations(this, result) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(File f, Location l | l = this.getLocation() |
      locations_default(l, f, startline, startcolumn, endline, endcolumn) and
      filepath = f.getAbsolutePath()
    )
  }

  /** Gets a textual representation of this element. */
  string toString() { none() } // overridden in subclasses
}

/**
 * An `XMLParent` is either an `XMLElement` or an `XMLFile`,
 * both of which can contain other elements.
 */
class XMLParent extends @xmlparent {
  XMLParent() {
    // explicitly restrict `this` to be either an `XMLElement` or an `XMLFile`;
    // the type `@xmlparent` currently also includes non-XML files
    this instanceof @xmlelement or xmlEncoding(this, _)
  }

  /**
   * Gets a printable representation of this XML parent.
   * (Intended to be overridden in subclasses.)
   */
  string getName() { none() } // overridden in subclasses

  /** Gets the file to which this XML parent belongs. */
  XMLFile getFile() { result = this or xmlElements(this, _, _, _, result) }

  /** Gets the child element at a specified index of this XML parent. */
  XMLElement getChild(int index) { xmlElements(result, _, this, index, _) }

  /** Gets a child element of this XML parent. */
  XMLElement getAChild() { xmlElements(result, _, this, _, _) }

  /** Gets a child element of this XML parent with the given `name`. */
  XMLElement getAChild(string name) { xmlElements(result, _, this, _, _) and result.hasName(name) }

  /** Gets a comment that is a child of this XML parent. */
  XMLComment getAComment() { xmlComments(result, _, this, _) }

  /** Gets a character sequence that is a child of this XML parent. */
  XMLCharacters getACharactersSet() { xmlChars(result, _, this, _, _, _) }

  /** Gets the depth in the tree. (Overridden in XMLElement.) */
  int getDepth() { result = 0 }

  /** Gets the number of child XML elements of this XML parent. */
  int getNumberOfChildren() { result = count(XMLElement e | xmlElements(e, _, this, _, _)) }

  /** Gets the number of places in the body of this XML parent where text occurs. */
  int getNumberOfCharacterSets() { result = count(int pos | xmlChars(_, _, this, pos, _, _)) }

  /**
   * Gets the result of appending all the character sequences of this XML parent from
   * left to right, separated by a space.
   */
  string allCharactersString() {
    result =
      concat(string chars, int pos | xmlChars(_, chars, this, pos, _, _) | chars, " " order by pos)
  }

  /** Gets the text value contained in this XML parent. */
  string getTextValue() { result = this.allCharactersString() }

  /** Gets a printable representation of this XML parent. */
  string toString() { result = this.getName() }
}

/** An XML file. */
class XMLFile extends XMLParent, File {
  XMLFile() { xmlEncoding(this, _) }

  /** Gets a printable representation of this XML file. */
  override string toString() { result = this.getName() }

  /** Gets the name of this XML file. */
  override string getName() { result = File.super.getAbsolutePath() }

  /**
   * DEPRECATED: Use `getAbsolutePath()` instead.
   *
   * Gets the path of this XML file.
   */
  deprecated string getPath() { result = this.getAbsolutePath() }

  /**
   * DEPRECATED: Use `getParentContainer().getAbsolutePath()` instead.
   *
   * Gets the path of the folder that contains this XML file.
   */
  deprecated string getFolder() { result = this.getParentContainer().getAbsolutePath() }

  /** Gets the encoding of this XML file. */
  string getEncoding() { xmlEncoding(this, result) }

  /** Gets the XML file itself. */
  override XMLFile getFile() { result = this }

  /** Gets a top-most element in an XML file. */
  XMLElement getARootElement() { result = this.getAChild() }

  /** Gets a DTD associated with this XML file. */
  XMLDTD getADTD() { xmlDTDs(result, _, _, _, this) }
}

/**
 * An XML document type definition (DTD).
 *
 * Example:
 *
 * ```
 * <!ELEMENT person (firstName, lastName?)>
 * <!ELEMENT firstName (#PCDATA)>
 * <!ELEMENT lastName (#PCDATA)>
 * ```
 */
class XMLDTD extends XMLLocatable, @xmldtd {
  /** Gets the name of the root element of this DTD. */
  string getRoot() { xmlDTDs(this, result, _, _, _) }

  /** Gets the public ID of this DTD. */
  string getPublicId() { xmlDTDs(this, _, result, _, _) }

  /** Gets the system ID of this DTD. */
  string getSystemId() { xmlDTDs(this, _, _, result, _) }

  /** Holds if this DTD is public. */
  predicate isPublic() { not xmlDTDs(this, _, "", _, _) }

  /** Gets the parent of this DTD. */
  XMLParent getParent() { xmlDTDs(this, _, _, _, result) }

  override string toString() {
    this.isPublic() and
    result = this.getRoot() + " PUBLIC '" + this.getPublicId() + "' '" + this.getSystemId() + "'"
    or
    not this.isPublic() and
    result = this.getRoot() + " SYSTEM '" + this.getSystemId() + "'"
  }
}

/**
 * An XML element in an XML file.
 *
 * Example:
 *
 * ```
 * <manifest xmlns:android="http://schemas.android.com/apk/res/android"
 *           package="com.example.exampleapp" android:versionCode="1">
 * </manifest>
 * ```
 */
class XMLElement extends @xmlelement, XMLParent, XMLLocatable {
  /** Holds if this XML element has the given `name`. */
  predicate hasName(string name) { name = this.getName() }

  /** Gets the name of this XML element. */
  override string getName() { xmlElements(this, result, _, _, _) }

  /** Gets the XML file in which this XML element occurs. */
  override XMLFile getFile() { xmlElements(this, _, _, _, result) }

  /** Gets the parent of this XML element. */
  XMLParent getParent() { xmlElements(this, _, result, _, _) }

  /** Gets the index of this XML element among its parent's children. */
  int getIndex() { xmlElements(this, _, _, result, _) }

  /** Holds if this XML element has a namespace. */
  predicate hasNamespace() { xmlHasNs(this, _, _) }

  /** Gets the namespace of this XML element, if any. */
  XMLNamespace getNamespace() { xmlHasNs(this, result, _) }

  /** Gets the index of this XML element among its parent's children. */
  int getElementPositionIndex() { xmlElements(this, _, _, result, _) }

  /** Gets the depth of this element within the XML file tree structure. */
  override int getDepth() { result = this.getParent().getDepth() + 1 }

  /** Gets an XML attribute of this XML element. */
  XMLAttribute getAnAttribute() { result.getElement() = this }

  /** Gets the attribute with the specified `name`, if any. */
  XMLAttribute getAttribute(string name) { result.getElement() = this and result.getName() = name }

  /** Holds if this XML element has an attribute with the specified `name`. */
  predicate hasAttribute(string name) { exists(this.getAttribute(name)) }

  /** Gets the value of the attribute with the specified `name`, if any. */
  string getAttributeValue(string name) { result = this.getAttribute(name).getValue() }

  /** Gets a printable representation of this XML element. */
  override string toString() { result = this.getName() }
}

/**
 * An attribute that occurs inside an XML element.
 *
 * Examples:
 *
 * ```
 * package="com.example.exampleapp"
 * android:versionCode="1"
 * ```
 */
class XMLAttribute extends @xmlattribute, XMLLocatable {
  /** Gets the name of this attribute. */
  string getName() { xmlAttrs(this, _, result, _, _, _) }

  /** Gets the XML element to which this attribute belongs. */
  XMLElement getElement() { xmlAttrs(this, result, _, _, _, _) }

  /** Holds if this attribute has a namespace. */
  predicate hasNamespace() { xmlHasNs(this, _, _) }

  /** Gets the namespace of this attribute, if any. */
  XMLNamespace getNamespace() { xmlHasNs(this, result, _) }

  /** Gets the value of this attribute. */
  string getValue() { xmlAttrs(this, _, _, result, _, _) }

  /** Gets a printable representation of this XML attribute. */
  override string toString() { result = this.getName() + "=" + this.getValue() }
}

/**
 * A namespace used in an XML file.
 *
 * Example:
 *
 * ```
 * xmlns:android="http://schemas.android.com/apk/res/android"
 * ```
 */
class XMLNamespace extends XMLLocatable, @xmlnamespace {
  /** Gets the prefix of this namespace. */
  string getPrefix() { xmlNs(this, result, _, _) }

  /** Gets the URI of this namespace. */
  string getURI() { xmlNs(this, _, result, _) }

  /** Holds if this namespace has no prefix. */
  predicate isDefault() { this.getPrefix() = "" }

  override string toString() {
    this.isDefault() and result = this.getURI()
    or
    not this.isDefault() and result = this.getPrefix() + ":" + this.getURI()
  }
}

/**
 * A comment in an XML file.
 *
 * Example:
 *
 * ```
 * <!-- This is a comment. -->
 * ```
 */
class XMLComment extends @xmlcomment, XMLLocatable {
  /** Gets the text content of this XML comment. */
  string getText() { xmlComments(this, result, _, _) }

  /** Gets the parent of this XML comment. */
  XMLParent getParent() { xmlComments(this, _, result, _) }

  /** Gets a printable representation of this XML comment. */
  override string toString() { result = this.getText() }
}

/**
 * A sequence of characters that occurs between opening and
 * closing tags of an XML element, excluding other elements.
 *
 * Example:
 *
 * ```
 * <content>This is a sequence of characters.</content>
 * ```
 */
class XMLCharacters extends @xmlcharacters, XMLLocatable {
  /** Gets the content of this character sequence. */
  string getCharacters() { xmlChars(this, result, _, _, _, _) }

  /** Gets the parent of this character sequence. */
  XMLParent getParent() { xmlChars(this, _, result, _, _, _) }

  /** Holds if this character sequence is CDATA. */
  predicate isCDATA() { xmlChars(this, _, _, _, 1, _) }

  /** Gets a printable representation of this XML character sequence. */
  override string toString() { result = this.getCharacters() }
}
