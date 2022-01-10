/*
 * For internal use only.
 *
 * Extracts data about the functions in the database for use in adaptive threat modeling (ATM).
 */

module Raw {
  private import javascript as raw

  class RawAstNode = raw::ASTNode;

  class Entity = raw::Function;

  class Location = raw::Location;

  /**
   * Exposed as a tool for defining anchors for semantic search.
   */
  class UnderlyingFunction = raw::Function;

  /**
   * Determines whether an entity should be omitted from ATM.
   */
  predicate isEntityIgnored(Entity entity) {
    // Ignore entities which don't have definitions, for example those in TypeScript
    // declaration files.
    not exists(entity.getBody())
    or
    // Ignore entities with an empty body, for example the JavaScript function () => {}.
    entity.getNumBodyStmt() = 0 and not exists(entity.getAReturnedExpr())
  }

  newtype WrappedAstNode = TAstNode(RawAstNode rawNode)

  /**
   * This class represents nodes in the AST.
   */
  class AstNode extends TAstNode {
    RawAstNode rawNode;

    AstNode() { this = TAstNode(rawNode) }

    AstNode getAChildNode() { result = TAstNode(rawNode.getAChild()) }

    AstNode getParentNode() { result = TAstNode(rawNode.getParent()) }

    /**
     * Holds if the AST node has `result` as its `index`th attribute.
     *
     * The index is not intended to mean anything, and is only here for disambiguation.
     * There are no guarantees about any particular index being used (or not being used).
     */
    string astNodeAttribute(int index) {
      (
        // NB: Unary and binary operator expressions e.g. -a, a + b and compound
        // assignments e.g. a += b can be identified by the expression type.
        result = rawNode.(raw::Identifier).getName()
        or
        // Computed property accesses for which we can predetermine the property being accessed.
        // NB: May alias with operators e.g. could have '+' as a property name.
        result = rawNode.(raw::IndexExpr).getPropertyName()
        or
        // We use `getRawValue` to give us distinct representations for `0xa`, `0xA`, and `10`.
        result = rawNode.(raw::NumberLiteral).getRawValue()
        or
        // We use `getValue` rather than `getRawValue` so we assign `"a"` and `'a'` the same representation.
        not rawNode instanceof raw::NumberLiteral and
        result = rawNode.(raw::Literal).getValue()
        or
        result = rawNode.(raw::TemplateElement).getRawValue()
      ) and
      index = 0
    }

    /**
     * Returns a string indicating the "type" of the AST node.
     */
    string astNodeType() {
      // The definition of this method should correspond with that of the `@ast_node` entry in the
      // dbscheme.
      result = "js_exprs." + any(int kind | exprs(rawNode, kind, _, _, _))
      or
      result = "js_properties." + any(int kind | properties(rawNode, _, _, kind, _))
      or
      result = "js_stmts." + any(int kind | stmts(rawNode, kind, _, _, _))
      or
      result = "js_toplevel" and rawNode instanceof raw::TopLevel
      or
      result = "js_typeexprs." + any(int kind | typeexprs(rawNode, kind, _, _, _))
    }

    /**
     * Holds if `result` is the `index`'th child of the AST node, for some arbitrary indexing.
     * A root of the AST should be its own child, with an arbitrary (though conventionally
     * 0) index.
     *
     * Notably, the order in which child nodes are visited is not required to be meaningful,
     * and no particular index is required to be meaningful. However, `(parent, index)`
     * should be a keyset.
     */
    pragma[nomagic]
    AstNode astNodeChild(int index) {
      result =
        rank[index - 1](AstNode child, raw::Location l |
          child = this.getAChildNode() and l = child.getLocation()
        |
          child
          order by
            l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn(),
            child.astNodeType()
        )
      or
      not exists(result.getParentNode()) and this = result and index = 0
    }

    raw::Location getLocation() { result = rawNode.getLocation() }

    string toString() { result = rawNode.toString() }

    predicate isEntityNameNode(Entity entity) {
      exists(int index |
        TAstNode(entity) = this.getParentNode() and
        this = this.getParentNode().astNodeChild(index) and
        // An entity name node must be the first child of the entity.
        index = min(int otherIndex | exists(this.getParentNode().astNodeChild(otherIndex))) and
        entity.getName() = rawNode.(raw::VarDecl).getName()
      )
    }
  }

  /**
   * Holds if `result` is the `index`'th child of the `parent` entity. Such
   * a node is a root of an AST associated with this entity.
   */
  AstNode entityChild(AstNode parent, int index) {
    // In JavaScript, entities appear in the AST parent/child relationship.
    result = parent.astNodeChild(index)
  }

  /**
   * Holds if `node` is contained in `entity`. Note that a single node may be contained
   * in multiple entities, if they are nested. An entity, in particular, should be
   * reported as contained within itself.
   */
  predicate entityContains(Entity entity, AstNode node) {
    node.getParentNode*() = TAstNode(entity) and not node.isEntityNameNode(entity)
  }

  /**
   * Get the name of the entity.
   *
   * We attempt to assign unnamed entities approximate names if they are passed to a likely
   * external library function. If we can't assign them an approximate name, we give them the name
   * `""`, so that these entities are included in `AdaptiveThreatModeling.qll`.
   *
   * For entities which have multiple names, we choose the lexically smallest name.
   */
  string getEntityName(Entity entity) {
    if exists(entity.getName())
    then
      // https://github.com/github/ml-ql-adaptive-threat-modeling/issues/244 discusses making use
      // of all the names during training.
      result = min(entity.getName())
    else
      if exists(getApproximateNameForEntity(entity))
      then result = getApproximateNameForEntity(entity)
      else result = ""
  }

  /**
   * Holds if the call `call` has `entity` is its `argumentIndex`th argument.
   */
  private predicate entityUsedAsArgumentToCall(
    Entity entity, raw::DataFlow::CallNode call, int argumentIndex
  ) {
    raw::DataFlow::localFlowStep*(call.getArgument(argumentIndex), entity.flow())
  }

  /**
   * Returns a generated name for the entity. This name is generated such that
   * entities with the same names have similar behavior.
   */
  private string getApproximateNameForEntity(Entity entity) {
    count(raw::DataFlow::CallNode call, int index | entityUsedAsArgumentToCall(entity, call, index)) =
      1 and
    exists(raw::DataFlow::CallNode call, int index, string basePart |
      entityUsedAsArgumentToCall(entity, call, index) and
      (
        if count(getReceiverName(call)) = 1
        then basePart = getReceiverName(call) + "."
        else basePart = ""
      ) and
      result = basePart + call.getCalleeName() + "#functionalargument"
    )
  }

  private string getReceiverName(raw::DataFlow::CallNode call) {
    result = call.getReceiver().asExpr().(raw::VarAccess).getName()
  }

  /** Consistency checks: these predicates should each have no results */
  module Consistency {
    /** `getEntityName` should assign each entity a single name. */
    query predicate entityWithManyNames(Entity entity, string name) {
      name = getEntityName(entity) and
      count(getEntityName(entity)) > 1
    }

    query predicate nodeWithNoType(AstNode node) { not exists(node.astNodeType()) }

    query predicate nodeWithManyTypes(AstNode node, string type) {
      type = node.astNodeType() and
      count(node.astNodeType()) > 1
    }

    query predicate nodeWithNoParent(AstNode node, string type) {
      not node = any(AstNode parent).astNodeChild(_) and
      type = node.astNodeType() and
      not exists(RawAstNode rawNode | node = TAstNode(rawNode) and rawNode instanceof raw::Module)
    }

    query predicate duplicateChildIndex(AstNode parent, int index, AstNode child) {
      child = parent.astNodeChild(index) and
      count(parent.astNodeChild(index)) > 1
    }

    query predicate duplicateAttributeIndex(AstNode node, int index) {
      exists(node.astNodeAttribute(index)) and
      count(node.astNodeAttribute(index)) > 1
    }
  }
}

module Wrapped {
  /*
   * We require any node with attributes to be a leaf. Where a non-leaf node
   * has an attribute, we instead create a synthetic leaf node that has that
   * attribute.
   */

  /**
   * Holds if the AST node `e` is a leaf node.
   */
  private predicate isLeaf(Raw::AstNode e) { not exists(e.astNodeChild(_)) }

  newtype WrappedEntity =
    TEntity(Raw::Entity entity) {
      exists(entity.getLocation().getFile().getRelativePath()) and
      Raw::entityContains(entity, _)
    }

  /**
   * A type ranging over the kinds of entities for which we want to consider embeddings.
   */
  class Entity extends WrappedEntity {
    Raw::Entity rawEntity;

    Entity() { this = TEntity(rawEntity) and not Raw::isEntityIgnored(rawEntity) }

    string getName() { result = Raw::getEntityName(rawEntity) }

    AstNode getAstRoot(int index) {
      result = TAstNode(rawEntity, Raw::entityChild(Raw::TAstNode(rawEntity), index))
    }

    string toString() { result = rawEntity.toString() }

    Raw::Location getLocation() { result = rawEntity.getLocation() }

    Raw::UnderlyingFunction getDefinedFunction() { result = rawEntity }
  }

  newtype WrappedAstNode =
    TAstNode(Raw::Entity enclosingEntity, Raw::AstNode node) {
      Raw::entityContains(enclosingEntity, node)
    } or
    TSyntheticNode(
      Raw::Entity enclosingEntity, Raw::AstNode node, int syntheticChildIndex, int attrIndex
    ) {
      Raw::entityContains(enclosingEntity, node) and
      exists(node.astNodeAttribute(attrIndex)) and
      not isLeaf(node) and
      if exists(node.astNodeChild(_))
      then
        syntheticChildIndex =
          attrIndex - min(int other | exists(node.astNodeAttribute(other))) +
            max(int other | exists(node.astNodeChild(other))) + 1
      else syntheticChildIndex = attrIndex
    }

  pragma[nomagic]
  private AstNode injectedChild(Raw::Entity enclosingEntity, Raw::AstNode parent, int index) {
    result = TAstNode(enclosingEntity, parent.astNodeChild(index)) or
    result = TSyntheticNode(enclosingEntity, parent, index, _)
  }

  /**
   * A type ranging over AST nodes. Ultimately, only nodes contained in entities will
   * be considered.
   */
  class AstNode extends WrappedAstNode {
    Raw::Entity enclosingEntity;
    Raw::AstNode rawNode;

    AstNode() {
      (
        this = TAstNode(enclosingEntity, rawNode) or
        this = TSyntheticNode(enclosingEntity, rawNode, _, _)
      ) and
      not Raw::isEntityIgnored(enclosingEntity)
    }

    string getAttribute(int index) {
      result = rawNode.astNodeAttribute(index) and
      not exists(TSyntheticNode(enclosingEntity, rawNode, _, index))
    }

    string getType() { result = rawNode.astNodeType() }

    AstNode getChild(int index) { result = injectedChild(enclosingEntity, rawNode, index) }

    string toString() { result = this.getType() }

    Raw::Location getLocation() { result = rawNode.getLocation() }
  }

  /**
   * A synthetic AST node, created to be a leaf for an otherwise non-leaf attribute.
   */
  class SyntheticAstNode extends AstNode, TSyntheticNode {
    int childIndex;
    int attributeIndex;

    SyntheticAstNode() {
      this = TSyntheticNode(enclosingEntity, rawNode, childIndex, attributeIndex)
    }

    override string getAttribute(int index) {
      result = rawNode.astNodeAttribute(attributeIndex) and index = attributeIndex
    }

    override string getType() {
      result = rawNode.astNodeType() + "::<synthetic " + childIndex + ">"
    }

    override AstNode getChild(int index) { none() }
  }
}

module DatabaseFeatures {
  /**
   * Exposed as a tool for defining anchors for semantic search.
   */
  class UnderlyingFunction = Raw::UnderlyingFunction;

  private class Location = Raw::Location;

  private newtype TEntityOrAstNode =
    TEntity(Wrapped::Entity entity) or
    TAstNode(Wrapped::AstNode astNode)

  class EntityOrAstNode extends TEntityOrAstNode {
    abstract string getType();

    abstract string toString();

    abstract Location getLocation();
  }

  class Entity extends EntityOrAstNode, TEntity {
    Wrapped::Entity entity;

    Entity() { this = TEntity(entity) }

    string getName() { result = entity.getName() }

    AstNode getAstRoot(int index) { result = TAstNode(entity.getAstRoot(index)) }

    override string getType() { result = "javascript function" }

    override string toString() { result = "Entity: " + this.getName() }

    override Location getLocation() { result = entity.getLocation() }

    UnderlyingFunction getDefinedFunction() { result = entity.getDefinedFunction() }
  }

  class AstNode extends EntityOrAstNode, TAstNode {
    Wrapped::AstNode rawNode;

    AstNode() { this = TAstNode(rawNode) }

    AstNode getChild(int index) { result = TAstNode(rawNode.getChild(index)) }

    string getAttribute(int index) { result = rawNode.getAttribute(index) }

    override string getType() { result = rawNode.getType() }

    override string toString() { result = this.getType() }

    override Location getLocation() { result = rawNode.getLocation() }
  }

  /** Consistency checks: these predicates should each have no results */
  module Consistency {
    query predicate nonLeafAttribute(AstNode node, int index, string attribute) {
      attribute = node.getAttribute(index) and
      exists(node.getChild(_))
    }
  }

  query predicate entities(
    Entity entity, string entity_name, string entity_type, string path, int startLine,
    int startColumn, int endLine, int endColumn, string absolutePath
  ) {
    entity_name = entity.getName() and
    entity_type = entity.getType() and
    exists(Location l | l = entity.getLocation() |
      path = l.getFile().getRelativePath() and
      absolutePath = l.getFile().getAbsolutePath() and
      l.hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
    )
  }

  query predicate astNodes(
    Entity enclosingEntity, EntityOrAstNode parent, int index, AstNode node, string node_type
  ) {
    node = enclosingEntity.getAstRoot(index) and
    parent = enclosingEntity and
    node_type = node.getType()
    or
    astNodes(enclosingEntity, _, _, parent, _) and
    node = parent.(AstNode).getChild(index) and
    node_type = node.getType()
  }

  query predicate nodeAttributes(AstNode node, string attr) {
    // Only get attributes of AST nodes we extract.
    // This excludes nodes in standard libraries since the standard library files
    // are located outside the source root.
    astNodes(_, _, _, node, _) and
    attr = node.getAttribute(_)
  }
}
