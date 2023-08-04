/**
 * Provides classes for working with YAML data.
 *
 * YAML documents are represented as abstract syntax trees whose nodes
 * are either YAML values or alias nodes referring to another YAML value.
 */

/** Provides the input specification of YAML implementation. */
signature module InputSig {
  class Container {
    string getAbsolutePath();

    Container getParentContainer();
  }

  class File extends Container;

  class Location {
    File getFile();
  }

  class LocatableBase {
    /**
     * Gets the `Location` of this node.
     *
     * Typically `yaml_locations(this, result)`.
     */
    Location getLocation();
  }

  /**
   * A base class for Nodes.
   *
   * Typically `@yaml_node`.
   */
  class NodeBase extends LocatableBase {
    /**
     * Gets the `i`th child node of this node.
     *
     * Typically `yaml(result, _, this, i, _, _)`.
     */
    NodeBase getChildNode(int i);

    /**
     * Gets the tag of this node.
     *
     * Typically `yaml(this, _, _, _, result, _)`.
     */
    string getTag();

    /**
     * Gets the anchor associated with this node, if any.
     *
     * Typically `yaml_anchors(this, result)`.
     */
    string getAnchor();

    /**
     * Gets a textual representation of this node.
     *
     * Typically `yaml(this, _, _, _, _, result)`.
     */
    string toString();
  }

  /**
   * A base class for scalar nodes.
   *
   * Typically `@yaml_scalar_node`.
   */
  class ScalarNodeBase extends NodeBase {
    /**
     * Gets the style of this scalar.
     *
     * Typically `yaml_scalars(this, result, _)`.
     */
    int getStyle();

    /**
     * Gets the value of this scalar, as a string.
     *
     * Typically `yaml_scalars(this, _, result)`.
     */
    string getValue();
  }

  /**
   * A base class for collections.
   *
   * Typically `@yaml_collection_node`.
   */
  class CollectionNodeBase extends NodeBase;

  /**
   * A base class for objects.
   *
   * Typically `@yaml_mapping_node`.
   */
  class MappingNodeBase extends CollectionNodeBase;

  /**
   * A base class for arrays.
   *
   * Typically `@yaml_sequence_node`.
   */
  class SequenceNodeBase extends CollectionNodeBase;

  /**
   * A base class for aliases.
   *
   * Typically `@yaml_alias_node`.
   */
  class AliasNodeBase extends NodeBase {
    /**
     * Gets the target anchor this alias refers to.
     *
     * Typically `yaml_aliases(this, result)`.
     */
    string getTarget();
  }

  /**
   * A base class for parse errors.
   *
   * Typically `@yaml_parse_error`.
   */
  class ParseErrorBase extends LocatableBase {
    /**
     * Gets the message of this parse error.
     *
     * Typically `yaml_errors(this, result)`.
     */
    string getMessage();
  }
}

/** Provides a class hierarchy for working with YAML files. */
module Make<InputSig Input> {
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
  class YamlNode instanceof Input::NodeBase {
    /** Gets the file this node comes from. */
    Input::File getFile() { result = this.getLocation().getFile() }

    /**
     * Gets the `Location` of this node.
     */
    Input::Location getLocation() { result = super.getLocation() }

    /**
     * Gets the parent node of this node, which is always a collection.
     */
    YamlCollection getParentNode() { this = result.getChildNode(_) }

    /**
     * Gets the `i`th child node of this node.
     *
     * _Note_: The index of a child node relative to its parent is considered
     * an implementation detail and may change between versions of the extractor.
     */
    YamlNode getChildNode(int i) { result = super.getChildNode(i) }

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
    string getTag() { result = super.getTag() }

    /**
     * Holds if this node is tagged with a standard type tag of the form
     * `tag:yaml.org,2002:<t>`.
     */
    predicate hasStandardTypeTag(string t) {
      t = this.getTag().regexpCapture("tag:yaml.org,2002:(.*)", 1)
    }

    /** Gets a textual representation of this node. */
    string toString() { result = super.toString() }

    /**
     * Gets the anchor associated with this node, if any.
     */
    string getAnchor() { result = super.getAnchor() }

    /**
     * Gets the toplevel document to which this node belongs.
     */
    YamlDocument getDocument() { result = this.getParentNode*() }

    /**
     * Gets the YAML value this node corresponds to after resolving aliases and includes.
     */
    YamlValue eval() { result = this }

    /**
     * Gets the primary QL class for this node.
     */
    string getAPrimaryQlClass() { result = "YamlNode" }
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
  abstract class YamlValue extends YamlNode { }

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
  class YamlScalar extends YamlValue instanceof Input::ScalarNodeBase {
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
      exists(int s | s = super.getStyle() |
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
    string getValue() { result = super.getValue() }

    override string getAPrimaryQlClass() { result = "YamlScalar" }
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
  class YamlInteger extends YamlScalar {
    YamlInteger() { this.hasStandardTypeTag("int") }

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
  class YamlFloat extends YamlScalar {
    YamlFloat() { this.hasStandardTypeTag("float") }

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
  class YamlTimestamp extends YamlScalar {
    YamlTimestamp() { this.hasStandardTypeTag("timestamp") }

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
  class YamlBool extends YamlScalar {
    YamlBool() { this.hasStandardTypeTag("bool") }

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
  class YamlNull extends YamlScalar {
    YamlNull() { this.hasStandardTypeTag("null") }
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
  class YamlString extends YamlScalar {
    YamlString() { this.hasStandardTypeTag("str") }
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
  class YamlMergeKey extends YamlScalar {
    YamlMergeKey() { this.hasStandardTypeTag("merge") }
  }

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
        targetDoc.getLocation().getFile().getAbsolutePath() = this.getTargetPath() and
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
        else
          result =
            this.getDocument().getLocation().getFile().getParentContainer().getAbsolutePath() + "/" +
              path
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
  class YamlCollection extends YamlValue instanceof Input::CollectionNodeBase {
    override string getAPrimaryQlClass() { result = "YamlCollection" }
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
  class YamlMapping extends YamlCollection instanceof Input::MappingNodeBase {
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
    YamlValue lookup(string key) {
      exists(YamlScalar s | s.getValue() = key | this.maps(s, result))
    }

    override string getAPrimaryQlClass() { result = "YamlMapping" }
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
  class YamlSequence extends YamlCollection instanceof Input::SequenceNodeBase {
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

  /**
   * A YAML alias node referring to a target anchor.
   *
   * Example:
   *
   * ```
   * *DEFAULTS
   * ```
   */
  class YamlAliasNode extends YamlNode instanceof Input::AliasNodeBase {
    override YamlValue eval() {
      result.getAnchor() = this.getTarget() and
      result.getDocument() = this.getDocument()
    }

    /**
     * Gets the target anchor this alias refers to.
     */
    string getTarget() { result = super.getTarget() }

    override string getAPrimaryQlClass() { result = "YamlAliasNode" }
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
  class YamlDocument extends YamlNode {
    YamlDocument() { not exists(this.getParentNode()) }
  }

  /**
   * An error message produced by the YAML parser while processing a YAML file.
   */
  class YamlParseError instanceof Input::ParseErrorBase {
    /**
     * Gets the `Location` of this error.
     */
    Input::Location getLocation() { result = super.getLocation() }

    /**
     * Gets the message of this error.
     */
    string getMessage() { result = super.getMessage() }

    /**
     * Get the string representation of this error.
     */
    string toString() { result = super.getMessage() }
  }

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
}
