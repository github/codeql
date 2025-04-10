/**
 * Provides classes for working with YAML data.
 *
 * YAML documents are represented as abstract syntax trees whose nodes
 * are either YAML values or alias nodes referring to another YAML value.
 */

private import codeql.yaml.Yaml as LibYaml
private import codeql.files.FileSystem

private module YamlSig implements LibYaml::InputSig {
  import codeql.Locations

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

/** A `qlpack.yml` document. */
class QlPackDocument extends YamlDocument {
  QlPackDocument() { this.getFile().getBaseName() = ["qlpack.yml", "qlpack.test.yml"] }

  /** Gets the name of this QL pack. */
  string getPackName() {
    exists(YamlMapping n |
      n.getDocument() = this and
      result = n.lookup("name").(YamlScalar).getValue()
    )
  }

  private string getADependencyName() {
    exists(YamlMapping n, YamlScalar key |
      n.getDocument() = this and
      n.lookup("dependencies").(YamlMapping).maps(key, _) and
      result = key.getValue()
    )
  }

  /** Gets a dependency of this QL pack. */
  QlPackDocument getADependency() { result.getPackName() = this.getADependencyName() }

  private Folder getRootFolder() { result = this.getFile().getParentContainer() }

  /** Gets a folder inside this QL pack. */
  pragma[nomagic]
  Folder getAFolder() {
    result = this.getRootFolder()
    or
    exists(Folder mid |
      mid = this.getAFolder() and
      result.getParentContainer() = mid and
      not result = any(QlPackDocument other).getRootFolder()
    )
  }
}

private predicate shouldAppend(QlRefDocument qlref, Folder f, string relativePath) {
  relativePath = qlref.getRelativeQueryPath() and
  (
    exists(QlPackDocument pack |
      pack.getAFolder() = qlref.getFile().getParentContainer() and
      f = [pack, pack.getADependency()].getFile().getParentContainer()
    )
    or
    f = qlref.getFile().getParentContainer()
  )
}

private predicate shouldAppend(Folder f, string relativePath) { shouldAppend(_, f, relativePath) }

/** A `.qlref` YAML document. */
class QlRefDocument extends YamlDocument {
  QlRefDocument() { this.getFile().getExtension() = "qlref" }

  /** Holds if this `.qlref` file uses inline test expectations. */
  predicate usesInlineExpectations() {
    exists(YamlMapping n, YamlScalar value |
      n.getDocument() = this and
      value.getValue().matches("%InlineExpectations%")
    |
      value = n.lookup("postprocess")
      or
      value = n.lookup("postprocess").(YamlSequence).getElement(_)
    )
  }

  /** Gets the relative path of the query in this `.qlref` file. */
  string getRelativeQueryPath() {
    exists(YamlMapping n | n.getDocument() = this |
      result = n.lookup("query").(YamlScalar).getValue()
    )
    or
    not exists(YamlMapping n | n.getDocument() = this) and
    result = this.eval().(YamlScalar).getValue()
  }

  /** Gets the query file referenced in this `.qlref` file. */
  File getQueryFile() {
    exists(Folder f, string relativePath |
      shouldAppend(this, f, relativePath) and
      result = Folder::Append<shouldAppend/2>::append(f, relativePath)
    )
  }

  predicate isPrintAst() {
    this.getFile().getStem() = "PrintAst"
    or
    exists(YamlMapping n, YamlScalar value |
      n.getDocument() = this and
      value.getValue().matches("%PrintAst%")
    |
      value = n.lookup("query")
    )
  }
}
