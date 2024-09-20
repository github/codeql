/**
 * Provides classes for working with YAML data.
 *
 * YAML documents are represented as abstract syntax trees whose nodes
 * are either YAML values or alias nodes referring to another YAML value.
 */

import javascript
private import codeql.yaml.Yaml as LibYaml

private module YamlSig implements LibYaml::InputSig {
  class Location = DbLocation;

  class LocatableBase extends @yaml_locatable, Locatable { }

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

  override string toString() { result = YamlNode.super.toString() }
}
