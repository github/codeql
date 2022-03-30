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
 *
 * Examples:
 *
 * ```
 * # a mapping
 * x: 1
 * << : *DEFAULTS  # an alias node referring to anchor `DEFAULTS`
 * ```
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
  YAMLNode getAChildNode() { result = this.getChildNode(_) }

  /**
   * Gets the number of child nodes of this node.
   */
  int getNumChild() { result = count(this.getAChildNode()) }

  /**
   * Gets the `i`th child of this node, as a YAML value.
   */
  YAMLValue getChild(int i) { result = this.getChildNode(i).eval() }

  /**
   * Gets a child of this node, as a YAML value.
   */
  YAMLValue getAChild() { result = this.getChild(_) }

  /**
   * Gets the tag of this node.
   */
  string getTag() { yaml(this, _, _, _, result, _) }

  /**
   * Holds if this node is tagged with a standard type tag of the form
   * `tag:yaml.org,2002:<t>`.
   */
  predicate hasStandardTypeTag(string t) {
    t = this.getTag().regexpCapture("tag:yaml.org,2002:(.*)", 1)
  }

  override string toString() { yaml(this, _, _, _, _, result) }

  /**
   * Gets the anchor associated with this node, if any.
   */
  string getAnchor() { yaml_anchors(this, result) }

  /**
   * Gets the toplevel document to which this node belongs.
   */
  YAMLDocument getDocument() { result = this.getParentNode*() }

  /**
   * Gets the YAML value this node corresponds to after resolving aliases and includes.
   */
  YAMLValue eval() { result = this }

  override string getAPrimaryQlClass() { result = "YAMLNode" }
}

/**
 * A YAML value; that is, either a scalar or a collection.
 *
 * Examples:
 *
 * ```
 * ---
 * "a string"
 * ---
 * - a
 * - sequence
 * ```
 */
abstract class YAMLValue extends YAMLNode { }

/**
 * A YAML scalar.
 *
 * Examples:
 *
 * ```
 * 42
 * 1.0
 * 2001-12-15T02:59:43.1Z
 * true
 * null
 * "hello"
 * ```
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

  override string getAPrimaryQlClass() { result = "YAMLScalar" }
}

/**
 * A YAML scalar representing an integer value.
 *
 * Examples:
 *
 * ```
 * 42
 * 0xffff
 * ```
 */
class YAMLInteger extends YAMLScalar {
  YAMLInteger() { this.hasStandardTypeTag("int") }

  /**
   * Gets the value of this scalar, as an integer.
   */
  int getIntValue() { result = this.getValue().toInt() }
}

/**
 * A YAML scalar representing a floating point value.
 *
 * Examples:
 *
 * ```
 * 1.0
 * 6.626e-34
 * ```
 */
class YAMLFloat extends YAMLScalar {
  YAMLFloat() { this.hasStandardTypeTag("float") }

  /**
   * Gets the value of this scalar, as a floating point number.
   */
  float getFloatValue() { result = this.getValue().toFloat() }
}

/**
 * A YAML scalar representing a time stamp.
 *
 * Example:
 *
 * ```
 * 2001-12-15T02:59:43.1Z
 * ```
 */
class YAMLTimestamp extends YAMLScalar {
  YAMLTimestamp() { this.hasStandardTypeTag("timestamp") }

  /**
   * Gets the value of this scalar, as a date.
   */
  date getDateValue() { result = this.getValue().toDate() }
}

/**
 * A YAML scalar representing a Boolean value.
 *
 * Example:
 *
 * ```
 * true
 * ```
 */
class YAMLBool extends YAMLScalar {
  YAMLBool() { this.hasStandardTypeTag("bool") }

  /**
   * Gets the value of this scalar, as a Boolean.
   */
  boolean getBoolValue() { if this.getValue() = "true" then result = true else result = false }
}

/**
 * A YAML scalar representing the null value.
 *
 * Example:
 *
 * ```
 * null
 * ```
 */
class YAMLNull extends YAMLScalar {
  YAMLNull() { this.hasStandardTypeTag("null") }
}

/**
 * A YAML scalar representing a string value.
 *
 * Example:
 *
 * ```
 * "hello"
 * ```
 */
class YAMLString extends YAMLScalar {
  YAMLString() { this.hasStandardTypeTag("str") }
}

/**
 * A YAML scalar representing a merge key.
 *
 * Example:
 *
 * ```
 * x: 1
 * << : *DEFAULTS  # merge key
 * ```
 */
class YAMLMergeKey extends YAMLScalar {
  YAMLMergeKey() { this.hasStandardTypeTag("merge") }
}

/**
 * A YAML scalar representing an `!include` directive.
 *
 * ```
 * !include common.yaml
 * ```
 */
class YAMLInclude extends YAMLScalar {
  YAMLInclude() { this.getTag() = "!include" }

  override YAMLValue eval() {
    exists(YAMLDocument targetDoc |
      targetDoc.getFile().getAbsolutePath() = this.getTargetPath() and
      result = targetDoc.eval()
    )
  }

  /**
   * Gets the absolute path of the file included by this directive.
   */
  private string getTargetPath() {
    exists(string path | path = this.getValue() |
      if path.matches("/%")
      then result = path
      else result = this.getDocument().getFile().getParentContainer().getAbsolutePath() + "/" + path
    )
  }
}

/**
 * A YAML collection, that is, either a mapping or a sequence.
 *
 * Examples:
 *
 * ```
 * ---
 * # a mapping
 * x: 0
 * y: 1
 * ---
 * # a sequence
 * - red
 * - green
 * - -blue
 * ```
 */
class YAMLCollection extends YAMLValue, @yaml_collection_node {
  override string getAPrimaryQlClass() { result = "YAMLCollection" }
}

/**
 * A YAML mapping.
 *
 * Example:
 *
 * ```
 * x: 0
 * y: 1
 * ```
 */
class YAMLMapping extends YAMLCollection, @yaml_mapping_node {
  /**
   * Gets the `i`th key of this mapping.
   */
  YAMLNode getKeyNode(int i) {
    i >= 0 and
    exists(int j | i = j - 1 and result = this.getChildNode(j))
  }

  /**
   * Gets the `i`th value of this mapping.
   */
  YAMLNode getValueNode(int i) {
    i >= 0 and
    exists(int j | i = -j - 1 and result = this.getChildNode(j))
  }

  /**
   * Gets the `i`th key of this mapping, as a YAML value.
   */
  YAMLValue getKey(int i) { result = this.getKeyNode(i).eval() }

  /**
   * Gets the `i`th value of this mapping, as a YAML value.
   */
  YAMLValue getValue(int i) { result = this.getValueNode(i).eval() }

  /**
   * Holds if this mapping maps `key` to `value`.
   */
  predicate maps(YAMLValue key, YAMLValue value) {
    exists(int i | key = this.getKey(i) and value = this.getValue(i))
    or
    exists(YAMLMergeKey merge, YAMLMapping that | this.maps(merge, that) | that.maps(key, value))
  }

  /**
   * Gets the value that this mapping maps `key` to.
   */
  YAMLValue lookup(string key) { exists(YAMLScalar s | s.getValue() = key | this.maps(s, result)) }

  override string getAPrimaryQlClass() { result = "YAMLMapping" }
}

/**
 * A YAML sequence.
 *
 * Example:
 *
 * ```
 * - red
 * - green
 * - blue
 * ```
 */
class YAMLSequence extends YAMLCollection, @yaml_sequence_node {
  /**
   * Gets the `i`th element in this sequence.
   */
  YAMLNode getElementNode(int i) { result = this.getChildNode(i) }

  /**
   * Gets the `i`th element in this sequence, as a YAML value.
   */
  YAMLValue getElement(int i) { result = this.getElementNode(i).eval() }

  override string getAPrimaryQlClass() { result = "YAMLSequence" }
}

/**
 * A YAML alias node referring to a target anchor.
 *
 * Example:
 *
 * ```
 * *DEFAULTS
 * ```
 */
class YAMLAliasNode extends YAMLNode, @yaml_alias_node {
  override YAMLValue eval() {
    result.getAnchor() = this.getTarget() and
    result.getDocument() = this.getDocument()
  }

  /**
   * Gets the target anchor this alias refers to.
   */
  string getTarget() { yaml_aliases(this, result) }

  override string getAPrimaryQlClass() { result = "YAMLAliasNode" }
}

/**
 * A YAML document.
 *
 * Example:
 *
 * ```
 * ---
 * x: 0
 * y: 1
 * ```
 */
class YAMLDocument extends YAMLNode {
  YAMLDocument() { not exists(this.getParentNode()) }
}

/**
 * An error message produced by the YAML parser while processing a YAML file.
 */
class YAMLParseError extends @yaml_error, Error {
  override Location getLocation() { yaml_locations(this, result) }

  override string getMessage() { yaml_errors(this, result) }

  override string toString() { result = this.getMessage() }
}
