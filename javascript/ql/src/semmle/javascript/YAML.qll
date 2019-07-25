/**
 * Provides classes for working with YAML data.
 *
 * YAML documents are represented as abstract syntax trees whose nodes
 * are either YAML values or alias nodes referring to another YAML value.
 */

import javascript

/**
 * A node in the AST representation of a YAML file, which may either be
 * a YAML value (such as a scalar or a collection) or an alias node
 * referring to some other YAML value.
 */
class YAMLNode extends @yaml_node, Locatable {
  override Location getLocation() { yaml_locations(this, result) }

  /**
   * Gets the parent node of this node, which is always a collection.
   */
  YAMLCollection getParentNode() { yaml(this, _, result, _, _, _) }

  /**
   * Gets the `i`th child node of this node.
   *
   * _Note_: The index of a child node relative to its parent is considered
   * an implementation detail and may change between versions of the extractor.
   */
  YAMLNode getChildNode(int i) { yaml(result, _, this, i, _, _) }

  /**
   * Gets a child node of this node.
   */
  YAMLNode getAChildNode() { result = getChildNode(_) }

  /**
   * Gets the number of child nodes of this node.
   */
  int getNumChild() { result = count(getAChildNode()) }

  /**
   * Gets the `i`th child of this node, as a YAML value.
   */
  YAMLValue getChild(int i) { result = getChildNode(i).eval() }

  /**
   * Gets a child of this node, as a YAML value.
   */
  YAMLValue getAChild() { result = getChild(_) }

  /**
   * Gets the tag of this node.
   */
  string getTag() { yaml(this, _, _, _, result, _) }

  /**
   * Holds if this node is tagged with a standard type tag of the form
   * `tag:yaml.org,2002:<t>`.
   */
  predicate hasStandardTypeTag(string t) { t = getTag().regexpCapture("tag:yaml.org,2002:(.*)", 1) }

  override string toString() { yaml(this, _, _, _, _, result) }

  /**
   * Gets the anchor associated with this node, if any.
   */
  string getAnchor() { yaml_anchors(this, result) }

  /**
   * Gets the toplevel document to which this node belongs.
   */
  YAMLDocument getDocument() { result = getParentNode*() }

  /**
   * Gets the YAML value this node corresponds to after resolving aliases and includes.
   */
  YAMLValue eval() { result = this }
}

/**
 * A YAML value; that is, either a scalar or a collection.
 */
abstract class YAMLValue extends YAMLNode { }

/**
 * A YAML scalar.
 */
class YAMLScalar extends YAMLValue, @yaml_scalar_node {
  /**
   * Gets the style of this scalar, which is one of the following:
   *
   * - `""` (empty string): plain style
   * - `"\""` (double quote): double quoted style
   * - `"'"` (single quote): single quoted style
   * - `">"` (greater-than): folded style
   * - `"|"` (pipe): literal style
   */
  string getStyle() {
    exists(int s | yaml_scalars(this, s, _) |
      s = 0 and result = ""
      or
      s = 34 and result = "\""
      or
      s = 39 and result = "'"
      or
      s = 62 and result = ">"
      or
      s = 124 and result = "|"
    )
  }

  /**
   * Gets the value of this scalar, as a string.
   */
  string getValue() { yaml_scalars(this, _, result) }
}

/**
 * A YAML scalar representing an integer value.
 */
class YAMLInteger extends YAMLScalar {
  YAMLInteger() { hasStandardTypeTag("int") }

  /**
   * Gets the value of this scalar, as an integer.
   */
  int getIntValue() { result = getValue().toInt() }
}

/**
 * A YAML scalar representing a floating point value.
 */
class YAMLFloat extends YAMLScalar {
  YAMLFloat() { hasStandardTypeTag("float") }

  /**
   * Gets the value of this scalar, as a floating point number.
   */
  float getFloatValue() { result = getValue().toFloat() }
}

/**
 * A YAML scalar representing a time stamp.
 */
class YAMLTimestamp extends YAMLScalar {
  YAMLTimestamp() { hasStandardTypeTag("timestamp") }

  /**
   * Gets the value of this scalar, as a date.
   */
  date getDateValue() { result = getValue().toDate() }
}

/**
 * A YAML scalar representing a Boolean value.
 */
class YAMLBool extends YAMLScalar {
  YAMLBool() { hasStandardTypeTag("bool") }

  /**
   * Gets the value of this scalar, as a Boolean.
   */
  boolean getBoolValue() { if getValue() = "true" then result = true else result = false }
}

/**
 * A YAML scalar representing the null value.
 */
class YAMLNull extends YAMLScalar {
  YAMLNull() { hasStandardTypeTag("null") }
}

/**
 * A YAML scalar representing a string value.
 */
class YAMLString extends YAMLScalar {
  YAMLString() { hasStandardTypeTag("str") }
}

/**
 * A YAML scalar representing a merge key.
 */
class YAMLMergeKey extends YAMLScalar {
  YAMLMergeKey() { hasStandardTypeTag("merge") }
}

/**
 * A YAML scalar representing an `!include` directive.
 */
class YAMLInclude extends YAMLScalar {
  YAMLInclude() { getTag() = "!include" }

  override YAMLValue eval() {
    exists(YAMLDocument targetDoc |
      targetDoc.getFile().getAbsolutePath() = getTargetPath() and
      result = targetDoc.eval()
    )
  }

  /**
   * Gets the absolute path of the file included by this directive.
   */
  private string getTargetPath() {
    exists(string path | path = getValue() |
      if path.matches("/%")
      then result = path
      else result = getDocument().getFile().getParentContainer().getAbsolutePath() + "/" + path
    )
  }
}

/**
 * A YAML collection, that is, either a mapping or a sequence.
 */
class YAMLCollection extends YAMLValue, @yaml_collection_node { }

/**
 * A YAML mapping.
 */
class YAMLMapping extends YAMLCollection, @yaml_mapping_node {
  /**
   * Gets the `i`th key of this mapping.
   */
  YAMLNode getKeyNode(int i) {
    i >= 0 and
    exists(int j | i = j - 1 and result = getChildNode(j))
  }

  /**
   * Gets the `i`th value of this mapping.
   */
  YAMLNode getValueNode(int i) {
    i >= 0 and
    exists(int j | i = -j - 1 and result = getChildNode(j))
  }

  /**
   * Gets the `i`th key of this mapping, as a YAML value.
   */
  YAMLValue getKey(int i) { result = getKeyNode(i).eval() }

  /**
   * Gets the `i`th value of this mapping, as a YAML value.
   */
  YAMLValue getValue(int i) { result = getValueNode(i).eval() }

  /**
   * Holds if this mapping maps `key` to `value`.
   */
  predicate maps(YAMLValue key, YAMLValue value) {
    exists(int i | key = getKey(i) and value = getValue(i))
    or
    exists(YAMLMergeKey merge, YAMLMapping that | maps(merge, that) | that.maps(key, value))
  }

  /**
   * Gets the value that this mapping maps `key` to.
   */
  YAMLValue lookup(string key) { exists(YAMLScalar s | s.getValue() = key | maps(s, result)) }
}

/**
 * A YAML sequence.
 */
class YAMLSequence extends YAMLCollection, @yaml_sequence_node {
  /**
   * Gets the `i`th element in this sequence.
   */
  YAMLNode getElementNode(int i) { result = getChildNode(i) }

  /**
   * Gets the `i`th element in this sequence, as a YAML value.
   */
  YAMLValue getElement(int i) { result = getElementNode(i).eval() }
}

/**
 * A YAML alias node referring to a target anchor.
 */
class YAMLAliasNode extends YAMLNode, @yaml_alias_node {
  override YAMLValue eval() {
    result.getAnchor() = getTarget() and
    result.getDocument() = this.getDocument()
  }

  /**
   * Gets the target anchor this alias refers to.
   */
  string getTarget() { yaml_aliases(this, result) }
}

/**
 * A YAML document.
 */
class YAMLDocument extends YAMLNode {
  YAMLDocument() { not exists(getParentNode()) }
}

/**
 * An error message produced by the YAML parser while processing a YAML file.
 */
class YAMLParseError extends @yaml_error, Error {
  override Location getLocation() { yaml_locations(this, result) }

  override string getMessage() { yaml_errors(this, result) }

  override string toString() { result = getMessage() }
}
