/**
 * Provides classes for working with YAML data.
 *
 * YAML documents are represented as abstract syntax trees whose nodes
 * are either YAML values or alias nodes referring to another YAML value.
 */

import javascript
private import codeql.yaml.Yaml as LibYaml

private module YamlSig implements LibYaml::InputSig {
  class LocatableBase extends @yaml_locatable, Locatable {
    override Location getLocation() { yaml_locations(this, result) }
  }

  import javascript

  class NodeBase extends Locatable, LocatableBase, @yaml_node {
    NodeBase getChildNode(int i) { yaml(result, _, this, i, _, _) }

    string getTag() { yaml(this, _, _, _, result, _) }

    string getAnchor() { yaml_anchors(this, result) }

    override string toString() { yaml(this, _, _, _, _, result) }
  }

  class ScalarNodeBase extends NodeBase, @yaml_scalar_node {
    int getStyle() { yaml_scalars(this, result, _) }

    string getValue() { yaml_scalars(this, _, result) }
  }

  class CollectionNodeBase extends NodeBase, @yaml_collection_node { }

  class MappingNodeBase extends CollectionNodeBase, @yaml_mapping_node { }

  class SequenceNodeBase extends CollectionNodeBase, @yaml_sequence_node { }

  class AliasNodeBase extends NodeBase, @yaml_alias_node {
    string getTarget() { yaml_aliases(this, result) }
  }

  class ParseErrorBase extends LocatableBase, @yaml_error {
    string getMessage() { yaml_errors(this, result) }
  }
}

import LibYaml::Make<YamlSig>

// private class to forward the `toString` etc. predicates from `YamlNode` to `Locatable`.
private class MyYmlNode extends Locatable instanceof YamlNode {
  override string getAPrimaryQlClass() { result = YamlNode.super.getAPrimaryQlClass() }

  override Location getLocation() { result = YamlNode.super.getLocation() }

  override string toString() { result = YamlNode.super.toString() }
}

/** DEPRECATED: Alias for YamlNode */
deprecated class YAMLNode = YamlNode;

/** DEPRECATED: Alias for YamlValue */
deprecated class YAMLValue = YamlValue;

/** DEPRECATED: Alias for YamlScalar */
deprecated class YAMLScalar = YamlScalar;

/** DEPRECATED: Alias for YamlInteger */
deprecated class YAMLInteger = YamlInteger;

/** DEPRECATED: Alias for YamlFloat */
deprecated class YAMLFloat = YamlFloat;

/** DEPRECATED: Alias for YamlTimestamp */
deprecated class YAMLTimestamp = YamlTimestamp;

/** DEPRECATED: Alias for YamlBool */
deprecated class YAMLBool = YamlBool;

/** DEPRECATED: Alias for YamlNull */
deprecated class YAMLNull = YamlNull;

/** DEPRECATED: Alias for YamlString */
deprecated class YAMLString = YamlString;

/** DEPRECATED: Alias for YamlMergeKey */
deprecated class YAMLMergeKey = YamlMergeKey;

/** DEPRECATED: Alias for YamlInclude */
deprecated class YAMLInclude = YamlInclude;

/** DEPRECATED: Alias for YamlCollection */
deprecated class YAMLCollection = YamlCollection;

/** DEPRECATED: Alias for YamlMapping */
deprecated class YAMLMapping = YamlMapping;

/** DEPRECATED: Alias for YamlSequence */
deprecated class YAMLSequence = YamlSequence;

/** DEPRECATED: Alias for YamlAliasNode */
deprecated class YAMLAliasNode = YamlAliasNode;

/** DEPRECATED: Alias for YamlDocument */
deprecated class YAMLDocument = YamlDocument;

/** DEPRECATED: Alias for YamlParseError */
deprecated class YAMLParseError = YamlParseError;

/** DEPRECATED: Alias for YamlMappingLikeNode */
deprecated class YAMLMappingLikeNode = YamlMappingLikeNode;
