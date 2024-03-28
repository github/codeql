/**
 * Provides classes and predicates for working with XML files and their content.
 */

private import codeql.util.Location
private import codeql.util.FileSystem

/** Provides the input specification of the XML implementation. */
signature module InputSig<FileSig File, LocationSig Location> {
  class XmlLocatableBase;

  predicate xmllocations_(XmlLocatableBase e, Location loc);

  class XmlParentBase;

  class XmlNamespaceableBase instanceof XmlLocatableBase;

  class XmlElementBase instanceof XmlParentBase, XmlNamespaceableBase;

  class XmlFileBase extends File instanceof XmlParentBase;

  predicate xmlEncoding_(XmlFileBase f, string enc);

  class XmlDtdBase instanceof XmlLocatableBase;

  predicate xmlDTDs_(XmlDtdBase e, string root, string publicId, string systemId, XmlFileBase file);

  predicate xmlElements_(
    XmlElementBase e, string name, XmlParentBase parent, int idx, XmlFileBase file
  );

  class XmlAttributeBase instanceof XmlNamespaceableBase;

  predicate xmlAttrs_(
    XmlAttributeBase e, XmlElementBase elementid, string name, string value, int idx,
    XmlFileBase file
  );

  class XmlNamespaceBase instanceof XmlLocatableBase;

  predicate xmlNs_(XmlNamespaceBase e, string prefixName, string uri, XmlFileBase file);

  predicate xmlHasNs_(XmlNamespaceableBase e, XmlNamespaceBase ns, XmlFileBase file);

  class XmlCommentBase instanceof XmlLocatableBase;

  predicate xmlComments_(XmlCommentBase e, string text, XmlParentBase parent, XmlFileBase file);

  class XmlCharactersBase instanceof XmlLocatableBase;

  predicate xmlChars_(
    XmlCharactersBase e, string text, XmlParentBase parent, int idx, int isCDATA, XmlFileBase file
  );
}

/** Provides a class hierarchy for working with XML files. */
module Make<FileSig File, LocationSig Location, InputSig<File, Location> Input> {
  private import Input

  final private class XmlLocatableBaseFinal = XmlLocatableBase;

  /** An XML element that has a location. */
  abstract private class XmlLocatableImpl extends XmlLocatableBaseFinal {
    /** Gets the location of this element. */
    Location getLocation() { xmllocations_(this, result) }

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
      this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    /** Gets a textual representation of this element. */
    abstract string toString();
  }

  final class XmlLocatable = XmlLocatableImpl;

  final private class XmlParentBaseFinal = XmlParentBase;

  final private class XmlElementBaseFinal = XmlElementBase;

  /**
   * An `XmlParent` is either an `XmlElement` or an `XmlFile`,
   * both of which can contain other elements.
   */
  abstract private class XmlParentImpl extends XmlParentBaseFinal {
    XmlParentImpl() {
      // explicitly restrict `this` to be either an `XmlElement` or an `XmlFile`;
      // the type `@xmlparent` currently also includes non-XML files
      this instanceof XmlElementBaseFinal or xmlEncoding_(this, _)
    }

    /** Gets a printable representation of this XML parent. */
    abstract string getName();

    /** Gets the file to which this XML parent belongs. */
    XmlFile getFile() { result = this or xmlElements_(this, _, _, _, result) }

    /** Gets the child element at a specified index of this XML parent. */
    XmlElement getChild(int index) { xmlElements_(result, _, this, index, _) }

    /** Gets a child element of this XML parent. */
    XmlElement getAChild() { xmlElements_(result, _, this, _, _) }

    /** Gets a child element of this XML parent with the given `name`. */
    XmlElement getAChild(string name) {
      xmlElements_(result, _, this, _, _) and result.hasName(name)
    }

    /** Gets a comment that is a child of this XML parent. */
    XmlComment getAComment() { xmlComments_(result, _, this, _) }

    /** Gets a character sequence that is a child of this XML parent. */
    XmlCharacters getACharactersSet() { xmlChars_(result, _, this, _, _, _) }

    /** Gets the depth in the tree. (Overridden in XmlElement.) */
    int getDepth() { result = 0 }

    /** Gets the number of child XML elements of this XML parent. */
    int getNumberOfChildren() { result = count(XmlElement e | xmlElements_(e, _, this, _, _)) }

    /** Gets the number of places in the body of this XML parent where text occurs. */
    int getNumberOfCharacterSets() { result = count(int pos | xmlChars_(_, _, this, pos, _, _)) }

    /**
     * Gets the result of appending all the character sequences of this XML parent from
     * left to right, separated by a space.
     */
    string allCharactersString() {
      result =
        concat(string chars, int pos |
          xmlChars_(_, chars, this, pos, _, _)
        |
          chars, " " order by pos
        )
    }

    /** Gets the text value contained in this XML parent. */
    string getTextValue() { result = this.allCharactersString() }

    /** Gets a printable representation of this XML parent. */
    string toString() { result = this.getName() }
  }

  final class XmlParent = XmlParentImpl;

  final private class XmlFileBaseFinal = XmlFileBase;

  // needed for the `toString` override in `XmlFileImpl`
  private class XmlFileBaseMid extends XmlFileBaseFinal {
    /** Gets a printable representation of this XML file. */
    string toString() { none() }
  }

  /** An XML file. */
  private class XmlFileImpl extends XmlParentImpl, XmlFileBaseMid {
    XmlFileImpl() { xmlEncoding_(this, _) }

    override string toString() { result = this.getName() }

    /** Gets the name of this XML file. */
    override string getName() { result = super.getAbsolutePath() }

    /** Gets the encoding of this XML file. */
    string getEncoding() { xmlEncoding_(this, result) }

    /** Gets the XML file itself. */
    override XmlFile getFile() { result = this }

    /** Gets a top-most element in an XML file. */
    XmlElement getARootElement() { result = this.getAChild() }

    /** Gets a DTD associated with this XML file. */
    XmlDtd getADtd() { xmlDTDs_(result, _, _, _, this) }
  }

  final class XmlFile = XmlFileImpl;

  final private class XmlDtdBaseFinal = XmlDtdBase;

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
  private class XmlDtdImpl extends XmlLocatableImpl, XmlDtdBaseFinal {
    /** Gets the name of the root element of this DTD. */
    string getRoot() { xmlDTDs_(this, result, _, _, _) }

    /** Gets the public ID of this DTD. */
    string getPublicId() { xmlDTDs_(this, _, result, _, _) }

    /** Gets the system ID of this DTD. */
    string getSystemId() { xmlDTDs_(this, _, _, result, _) }

    /** Holds if this DTD is public. */
    predicate isPublic() { not xmlDTDs_(this, _, "", _, _) }

    /** Gets the parent of this DTD. */
    XmlParent getParent() { xmlDTDs_(this, _, _, _, result) }

    override string toString() {
      this.isPublic() and
      result = this.getRoot() + " PUBLIC '" + this.getPublicId() + "' '" + this.getSystemId() + "'"
      or
      not this.isPublic() and
      result = this.getRoot() + " SYSTEM '" + this.getSystemId() + "'"
    }
  }

  final class XmlDtd = XmlDtdImpl;

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
  private class XmlElementImpl extends XmlElementBaseFinal, XmlParentImpl, XmlLocatableImpl {
    /** Holds if this XML element has the given `name`. */
    predicate hasName(string name) { name = this.getName() }

    /** Gets the name of this XML element. */
    override string getName() { xmlElements_(this, result, _, _, _) }

    /** Gets the XML file in which this XML element occurs. */
    override XmlFile getFile() { xmlElements_(this, _, _, _, result) }

    /** Gets the parent of this XML element. */
    XmlParent getParent() { xmlElements_(this, _, result, _, _) }

    /** Gets the index of this XML element among its parent's children. */
    int getIndex() { xmlElements_(this, _, _, result, _) }

    /** Holds if this XML element has a namespace. */
    predicate hasNamespace() { xmlHasNs_(this, _, _) }

    /** Gets the namespace of this XML element, if any. */
    XmlNamespace getNamespace() { xmlHasNs_(this, result, _) }

    /** Gets the index of this XML element among its parent's children. */
    int getElementPositionIndex() { xmlElements_(this, _, _, result, _) }

    /** Gets the depth of this element within the XML file tree structure. */
    override int getDepth() { result = this.getParent().getDepth() + 1 }

    /** Gets an XML attribute of this XML element. */
    XmlAttribute getAnAttribute() { result.getElement() = this }

    /** Gets the attribute with the specified `name`, if any. */
    XmlAttribute getAttribute(string name) {
      result.getElement() = this and result.getName() = name
    }

    /** Holds if this XML element has an attribute with the specified `name`. */
    predicate hasAttribute(string name) { exists(this.getAttribute(name)) }

    /** Gets the value of the attribute with the specified `name`, if any. */
    string getAttributeValue(string name) { result = this.getAttribute(name).getValue() }

    /** Gets a printable representation of this XML element. */
    override string toString() { result = this.getName() }
  }

  final class XmlElement = XmlElementImpl;

  final private class XmlAttributeBaseFinal = XmlAttributeBase;

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
  private class XmlAttributeImpl extends XmlAttributeBaseFinal, XmlLocatableImpl {
    /** Gets the name of this attribute. */
    string getName() { xmlAttrs_(this, _, result, _, _, _) }

    /** Gets the XML element to which this attribute belongs. */
    XmlElement getElement() { xmlAttrs_(this, result, _, _, _, _) }

    /** Holds if this attribute has a namespace. */
    predicate hasNamespace() { xmlHasNs_(this, _, _) }

    /** Gets the namespace of this attribute, if any. */
    XmlNamespace getNamespace() { xmlHasNs_(this, result, _) }

    /** Gets the value of this attribute. */
    string getValue() { xmlAttrs_(this, _, _, result, _, _) }

    /** Gets a printable representation of this XML attribute. */
    override string toString() { result = this.getName() + "=" + this.getValue() }
  }

  final class XmlAttribute = XmlAttributeImpl;

  final private class XmlNamespaceBaseFinal = XmlNamespaceBase;

  /**
   * A namespace used in an XML file.
   *
   * Example:
   *
   * ```
   * xmlns:android="http://schemas.android.com/apk/res/android"
   * ```
   */
  private class XmlNamespaceImpl extends XmlLocatableImpl, XmlNamespaceBaseFinal {
    /** Gets the prefix of this namespace. */
    string getPrefix() { xmlNs_(this, result, _, _) }

    /** Gets the URI of this namespace. */
    string getUri() { xmlNs_(this, _, result, _) }

    /** Holds if this namespace has no prefix. */
    predicate isDefault() { this.getPrefix() = "" }

    override string toString() {
      this.isDefault() and result = this.getUri()
      or
      not this.isDefault() and result = this.getPrefix() + ":" + this.getUri()
    }
  }

  final class XmlNamespace = XmlNamespaceImpl;

  final private class XmlCommentBaseFinal = XmlCommentBase;

  /**
   * A comment in an XML file.
   *
   * Example:
   *
   * ```
   * <!-- This is a comment. -->
   * ```
   */
  private class XmlCommentImpl extends XmlCommentBaseFinal, XmlLocatableImpl {
    /** Gets the text content of this XML comment. */
    string getText() { xmlComments_(this, result, _, _) }

    /** Gets the parent of this XML comment. */
    XmlParent getParent() { xmlComments_(this, _, result, _) }

    /** Gets a printable representation of this XML comment. */
    override string toString() { result = this.getText() }
  }

  final class XmlComment = XmlCommentImpl;

  final private class XmlCharactersBaseFinal = XmlCharactersBase;

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
  private class XmlCharactersImpl extends XmlCharactersBaseFinal, XmlLocatableImpl {
    /** Gets the content of this character sequence. */
    string getCharacters() { xmlChars_(this, result, _, _, _, _) }

    /** Gets the parent of this character sequence. */
    XmlParent getParent() { xmlChars_(this, _, result, _, _, _) }

    /** Holds if this character sequence is CDATA. */
    predicate isCDATA() { xmlChars_(this, _, _, _, 1, _) }

    /** Gets a printable representation of this XML character sequence. */
    override string toString() { result = this.getCharacters() }
  }

  final class XmlCharacters = XmlCharactersImpl;
}
