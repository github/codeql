/**
 * Provides classes for working with YAML data.
 *
 * YAML documents are represented as abstract syntax trees whose nodes
 * are either YAML values or alias nodes referring to another YAML value.
 */

private import codeql.yaml.Yaml as LibYaml

private module YamlSig implements LibYaml::InputSig {
  import semmle.python.Files

  class LocatableBase extends @yaml_locatable {
    Location getLocation() { yaml_locations(this, result) }

    string toString() { none() }
  }

  class NodeBase extends LocatableBase, @yaml_node {
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
