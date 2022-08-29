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
class YamlNode extends @yaml_node, Locatable {
  override Location getLocation() { yaml_locations(this, result) }

  /**
   * Gets the parent node of this node, which is always a collection.
   */
  YamlCollection getParentNode() { yaml(this, _, result, _, _, _) }

  /**
   * Gets the `i`th child node of this node.
   *
   * _Note_: The index of a child node relative to its parent is considered
   * an implementation detail and may change between versions of the extractor.
   */
  YamlNode getChildNode(int i) { yaml(result, _, this, i, _, _) }

  /**
   * Gets a child node of this node.
   */
  YamlNode getAChildNode() { result = this.getChildNode(_) }

  /**
   * Gets the number of child nodes of this node.
   */
  int getNumChild() { result = count(this.getAChildNode()) }

  /**
   * Gets the `i`th child of this node, as a YAML value.
   */
  YamlValue getChild(int i) { result = this.getChildNode(i).eval() }

  /**
   * Gets a child of this node, as a YAML value.
   */
  YamlValue getAChild() { result = this.getChild(_) }

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
  YamlDocument getDocument() { result = this.getParentNode*() }

  /**
   * Gets the YAML value this node corresponds to after resolving aliases and includes.
   */
  YamlValue eval() { result = this }

  override string getAPrimaryQlClass() { result = "YamlNode" }
}

/** DEPRECATED: Alias for YamlNode */
deprecated class YAMLNode = YamlNode;

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
abstract class YamlValue extends YamlNode { }

/** DEPRECATED: Alias for YamlValue */
deprecated class YAMLValue = YamlValue;

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
class YamlScalar extends YamlValue, @yaml_scalar_node {
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

  override string getAPrimaryQlClass() { result = "YamlScalar" }
}

/** DEPRECATED: Alias for YamlScalar */
deprecated class YAMLScalar = YamlScalar;

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
class YamlInteger extends YamlScalar {
  YamlInteger() { this.hasStandardTypeTag("int") }

  /**
   * Gets the value of this scalar, as an integer.
   */
  int getIntValue() { result = this.getValue().toInt() }
}

/** DEPRECATED: Alias for YamlInteger */
deprecated class YAMLInteger = YamlInteger;

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
class YamlFloat extends YamlScalar {
  YamlFloat() { this.hasStandardTypeTag("float") }

  /**
   * Gets the value of this scalar, as a floating point number.
   */
  float getFloatValue() { result = this.getValue().toFloat() }
}

/** DEPRECATED: Alias for YamlFloat */
deprecated class YAMLFloat = YamlFloat;

/**
 * A YAML scalar representing a time stamp.
 *
 * Example:
 *
 * ```
 * 2001-12-15T02:59:43.1Z
 * ```
 */
class YamlTimestamp extends YamlScalar {
  YamlTimestamp() { this.hasStandardTypeTag("timestamp") }

  /**
   * Gets the value of this scalar, as a date.
   */
  date getDateValue() { result = this.getValue().toDate() }
}

/** DEPRECATED: Alias for YamlTimestamp */
deprecated class YAMLTimestamp = YamlTimestamp;

/**
 * A YAML scalar representing a Boolean value.
 *
 * Example:
 *
 * ```
 * true
 * ```
 */
class YamlBool extends YamlScalar {
  YamlBool() { this.hasStandardTypeTag("bool") }

  /**
   * Gets the value of this scalar, as a Boolean.
   */
  boolean getBoolValue() { if this.getValue() = "true" then result = true else result = false }
}

/** DEPRECATED: Alias for YamlBool */
deprecated class YAMLBool = YamlBool;

/**
 * A YAML scalar representing the null value.
 *
 * Example:
 *
 * ```
 * null
 * ```
 */
class YamlNull extends YamlScalar {
  YamlNull() { this.hasStandardTypeTag("null") }
}

/** DEPRECATED: Alias for YamlNull */
deprecated class YAMLNull = YamlNull;

/**
 * A YAML scalar representing a string value.
 *
 * Example:
 *
 * ```
 * "hello"
 * ```
 */
class YamlString extends YamlScalar {
  YamlString() { this.hasStandardTypeTag("str") }
}

/** DEPRECATED: Alias for YamlString */
deprecated class YAMLString = YamlString;

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
class YamlMergeKey extends YamlScalar {
  YamlMergeKey() { this.hasStandardTypeTag("merge") }
}

/** DEPRECATED: Alias for YamlMergeKey */
deprecated class YAMLMergeKey = YamlMergeKey;

/**
 * A YAML scalar representing an `!include` directive.
 *
 * ```
 * !include common.yaml
 * ```
 */
class YamlInclude extends YamlScalar {
  YamlInclude() { this.getTag() = "!include" }

  override YamlValue eval() {
    exists(YamlDocument targetDoc |
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

/** DEPRECATED: Alias for YamlInclude */
deprecated class YAMLInclude = YamlInclude;

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
class YamlCollection extends YamlValue, @yaml_collection_node {
  override string getAPrimaryQlClass() { result = "YamlCollection" }
}

/** DEPRECATED: Alias for YamlCollection */
deprecated class YAMLCollection = YamlCollection;

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
class YamlMapping extends YamlCollection, @yaml_mapping_node {
  /**
   * Gets the `i`th key of this mapping.
   */
  YamlNode getKeyNode(int i) {
    i >= 0 and
    exists(int j | i = j - 1 and result = this.getChildNode(j))
  }

  /**
   * Gets the `i`th value of this mapping.
   */
  YamlNode getValueNode(int i) {
    i >= 0 and
    exists(int j | i = -j - 1 and result = this.getChildNode(j))
  }

  /**
   * Gets the `i`th key of this mapping, as a YAML value.
   */
  YamlValue getKey(int i) { result = this.getKeyNode(i).eval() }

  /**
   * Gets the `i`th value of this mapping, as a YAML value.
   */
  YamlValue getValue(int i) { result = this.getValueNode(i).eval() }

  /**
   * Holds if this mapping maps `key` to `value`.
   */
  predicate maps(YamlValue key, YamlValue value) {
    exists(int i | key = this.getKey(i) and value = this.getValue(i))
    or
    exists(YamlMergeKey merge, YamlMapping that | this.maps(merge, that) | that.maps(key, value))
  }

  /**
   * Gets the value that this mapping maps `key` to.
   */
  YamlValue lookup(string key) { exists(YamlScalar s | s.getValue() = key | this.maps(s, result)) }

  override string getAPrimaryQlClass() { result = "YamlMapping" }
}

/** DEPRECATED: Alias for YamlMapping */
deprecated class YAMLMapping = YamlMapping;

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
class YamlSequence extends YamlCollection, @yaml_sequence_node {
  /**
   * Gets the `i`th element in this sequence.
   */
  YamlNode getElementNode(int i) { result = this.getChildNode(i) }

  /**
   * Gets the `i`th element in this sequence, as a YAML value.
   */
  YamlValue getElement(int i) { result = this.getElementNode(i).eval() }

  override string getAPrimaryQlClass() { result = "YamlSequence" }
}

/** DEPRECATED: Alias for YamlSequence */
deprecated class YAMLSequence = YamlSequence;

/**
 * A YAML alias node referring to a target anchor.
 *
 * Example:
 *
 * ```
 * *DEFAULTS
 * ```
 */
class YamlAliasNode extends YamlNode, @yaml_alias_node {
  override YamlValue eval() {
    result.getAnchor() = this.getTarget() and
    result.getDocument() = this.getDocument()
  }

  /**
   * Gets the target anchor this alias refers to.
   */
  string getTarget() { yaml_aliases(this, result) }

  override string getAPrimaryQlClass() { result = "YamlAliasNode" }
}

/** DEPRECATED: Alias for YamlAliasNode */
deprecated class YAMLAliasNode = YamlAliasNode;

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
class YamlDocument extends YamlNode {
  YamlDocument() { not exists(this.getParentNode()) }
}

/** DEPRECATED: Alias for YamlDocument */
deprecated class YAMLDocument = YamlDocument;

/**
 * An error message produced by the YAML parser while processing a YAML file.
 */
class YamlParseError extends @yaml_error, Error {
  override Location getLocation() { yaml_locations(this, result) }

  override string getMessage() { yaml_errors(this, result) }

  override string toString() { result = this.getMessage() }
}

/** DEPRECATED: Alias for YamlParseError */
deprecated class YAMLParseError = YamlParseError;

/**
 * A YAML node that may contain sub-nodes that can be identified by a name.
 * I.e. a mapping, sequence, or scalar.
 *
 * Is used in e.g. GithHub Actions, which is quite flexible in parsing YAML.
 *
 * For example:
 * ```
 * on: pull_request
 * ```
 * and
 * ```
 * on: [pull_request]
 * ```
 * and
 * ```
 * on:
 *   pull_request:
 * ```
 *
 * are equivalent.
 */
class YamlMappingLikeNode extends YamlNode {
  YamlMappingLikeNode() {
    this instanceof YamlMapping
    or
    this instanceof YamlSequence
    or
    this instanceof YamlScalar
  }

  /** Gets sub-name identified by `name`. */
  YamlNode getNode(string name) {
    exists(YamlMapping mapping |
      mapping = this and
      result = mapping.lookup(name)
    )
    or
    exists(YamlSequence sequence, YamlNode node |
      sequence = this and
      sequence.getAChildNode() = node and
      node.eval().toString() = name and
      result = node
    )
    or
    exists(YamlScalar scalar |
      scalar = this and
      scalar.getValue() = name and
      result = scalar
    )
  }

  /** Gets the number of elements in this mapping or sequence. */
  int getElementCount() {
    exists(YamlMapping mapping |
      mapping = this and
      result = mapping.getNumChild() / 2
    )
    or
    exists(YamlSequence sequence |
      sequence = this and
      result = sequence.getNumChild()
    )
    or
    exists(YamlScalar scalar |
      scalar = this and
      result = 1
    )
  }
}

/** DEPRECATED: Alias for YamlMappingLikeNode */
deprecated class YAMLMappingLikeNode = YamlMappingLikeNode;
