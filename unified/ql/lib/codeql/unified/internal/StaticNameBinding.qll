/**
 * Provides classes for reasoning about static references to the members of classes and top-levels.
 */

private import unified
private import codeql.unified.internal.LocalNameBinding
private import codeql.unified.internal.NameBindingPlugin

private newtype TNameBindingNode =
  TIdentifier(Identifier n) or
  TBulkImport(BulkImportingPattern p) or
  TLocalName(LocalName local) or
  TExportedNamespace(ClassLikeDeclaration cls) or
  TLocalNamespace(AstNode n) {
    n = any(TopLevel t) or // Module names come in scope here
    n = any(TopLevel t).getBody() or // Imported names come in scope here (shadowing module names)
    n instanceof ClassLikeDeclaration
  } or
  TModuleScope(ModuleScopeRepr repr) or
  TModuleRoot()

/**
 * A node in a graph, in which name-binding rules are represented as edges between nodes.
 */
class NameBindingNode extends TNameBindingNode {
  predicate isIdentifier(Identifier n) { this = TIdentifier(n) }

  Identifier asIdentifier() { this.isIdentifier(result) }

  predicate isBulkImport(BulkImportingPattern p) { this = TBulkImport(p) }

  predicate isLocalName(LocalName local) { this = TLocalName(local) }

  /** Holds if this represents the set of static members available in the given namespace. */
  predicate isExportedNamespace(ClassLikeDeclaration cls) { this = TExportedNamespace(cls) }

  /** Holds if this represents the set of members that can be accessed unqualified within the given scope. */
  predicate isLocalNamespace(AstNode n) { this = TLocalNamespace(n) }

  /** Holds if this represents the given module scope. */
  predicate isModuleScopeNode(ModuleScopeRepr repr) { this = TModuleScope(repr) }

  /** Holds if this represents the root namespace in which all named modules are members. */
  predicate isModuleRoot() { this = TModuleRoot() }

  string toString() {
    exists(Identifier n | this.isIdentifier(n) and result = "Identifier(" + n + ")")
    or
    exists(BulkImportingPattern p | this.isBulkImport(p) and result = "BulkImport(" + p + ")")
    or
    exists(LocalName local | this.isLocalName(local) and result = "LocalName(" + local + ")")
    or
    exists(ClassLikeDeclaration cls |
      this.isExportedNamespace(cls) and result = "ExportedNamespace(" + cls + ")"
    )
    or
    exists(AstNode n | this.isLocalNamespace(n) and result = "LocalNamespace(" + n + ")")
    or
    exists(ModuleScopeRepr repr |
      this.isModuleScopeNode(repr) and result = "ModuleScope(" + repr + ")"
    )
    or
    this.isModuleRoot() and result = "ModuleRoot"
  }

  Location getLocation() {
    exists(Identifier n | this.isIdentifier(n) and result = n.getLocation())
    or
    exists(BulkImportingPattern p | this.isBulkImport(p) and result = p.getLocation())
    or
    exists(LocalName local | this.isLocalName(local) and result = local.getLocation())
    or
    exists(ClassLikeDeclaration cls | this.isExportedNamespace(cls) and result = cls.getLocation())
    or
    exists(AstNode n | this.isLocalNamespace(n) and result = n.getLocation())
    or
    exists(ModuleScopeRepr repr | this.isModuleScopeNode(repr) and result = repr.getLocation())
    or
    this.isModuleRoot() and
    exists(ModuleScopeRepr repr | result = repr.getLocation())
  }
}

Identifier getIdentifierFromRef(AstNode n) {
  result = n.(NameExpr).getIdentifier()
  or
  result = n.(NamePattern).getIdentifier()
  or
  result = n.(MemberAccessExpr).getMember()
  or
  result = n.(NamedTypeExpr).getName()
}

NameBindingNode getNodeFromRef(AstNode n) {
  result.isIdentifier(getIdentifierFromRef(n))
  or
  result.isBulkImport(n)
}

NameBindingNode getModuleNodeFromFile(File f) {
  exists(ModuleScopeRepr mod |
    mod.getAnIncludedFile() = f and
    result.isModuleScopeNode(mod)
  )
}

/** Gets the name-binding node associated with the given uncertain scope node. */
private NameBindingNode getNodeFromUncertainScope(AstNode n) {
  exists(ClassLikeDeclaration cls |
    n = cls.getAMember() and // note: must align with LocalNameBindingInput::uncertainScope
    result.isLocalNamespace(cls)
  )
  or
  result.isLocalNamespace(n)
}

predicate readStep(NameBindingNode node1, string name, NameBindingNode node2) {
  exists(MemberAccessExpr expr |
    node1 = getNodeFromRef(expr.getBase()) and
    name = expr.getMember().getValue() and
    node2 = getNodeFromRef(expr)
  )
  or
  exists(NamedTypeExpr expr |
    node1 = getNodeFromRef(expr.getQualifier()) and
    name = expr.getName().getValue() and
    node2 = getNodeFromRef(expr)
  )
  or
  exists(PotentialLocalNameAccess access |
    name = access.getName() and
    node1 = getNodeFromUncertainScope(LocalNameBindingOutput::getAnUncertainScope(access, name)) and
    node2.isIdentifier(access)
  )
}

predicate storeStep(NameBindingNode node1, string name, NameBindingNode node2) {
  exists(ClassLikeDeclaration cls, Member member, NameDeclaration nameDecl |
    member = cls.getAMember() and
    not isInstanceMember(member) and
    not isPrivateToLocalScope(member) and
    nameDecl.getDeclaration() = member
  |
    node1.isIdentifier(nameDecl) and
    name = nameDecl.getName() and
    node2.isExportedNamespace(cls)
  )
  or
  exists(TopLevel top, Stmt stmt, NameDeclaration nameDecl |
    stmt = top.getBody().getAStmt() and
    not isPrivateToLocalScope(stmt) and
    nameDecl.getDeclaration() = stmt
  |
    node1.isIdentifier(nameDecl) and
    name = nameDecl.getName() and
    node2 = getModuleNodeFromFile(top.getFile())
  )
  or
  exists(ModuleScopeRepr mod |
    node1.isModuleScopeNode(mod) and
    mod.hasImportableName(name) and
    node2.isModuleRoot()
  )
}

predicate valueStep(NameBindingNode node1, NameBindingNode node2) {
  exists(PotentialLocalNameAccess access |
    access.isDeclarationSite() and
    node1.isIdentifier(access) and
    node2.isLocalName(access.getLocalName())
    or
    node1.isLocalName(access.getLocalName()) and
    node2.isIdentifier(access)
  )
  or
  exists(ClassLikeDeclaration cls |
    node1.isExportedNamespace(cls) and
    node2.isIdentifier(cls.getName())
  )
  or
  exists(ClassLikeDeclaration cls |
    node1.isExportedNamespace(cls) and
    node2.isLocalNamespace(cls)
  )
  or
  exists(TopLevel top |
    node1.isModuleRoot() and
    node2.isLocalNamespace(top) // module names in outermost scope
    or
    node1 = getModuleNodeFromFile(top.getFile()) and
    node2.isLocalNamespace(top.getBody()) // implicitly import own module
  )
  or
  exists(ImportDeclaration imprt |
    node1 = getNodeFromRef(imprt.getImportedExpr()) and
    node2 = getNodeFromRef(imprt.getPattern())
  )
  or
  exists(BulkImportingPattern p, AstNode scope, AstNode declaration |
    bindingContext(p, scope, declaration) and
    node1 = getNodeFromRef(p)
  |
    node2 = getNodeFromUncertainScope(scope)
    or
    // Bulk re-exporting declarations
    exists(TopLevel top |
      declaration = top.getBody().getAStmt() and
      not isPrivateToLocalScope(declaration) and
      node2 = getModuleNodeFromFile(top.getFile())
    )
  )
}

predicate inheritanceStep(NameBindingNode supertype, NameBindingNode subtype) {
  exists(ClassLikeDeclaration cls, BaseType base |
    base = cls.getABaseType() and
    supertype = getNodeFromRef(base.getType()) and
    subtype.isExportedNamespace(cls)
  )
}

signature module TrackInputSig {
  /** Holds if the forward-flow of `node` should be tracked. */
  predicate shouldTrack(NameBindingNode node);

  default predicate additionalValueStep(NameBindingNode node1, NameBindingNode node2) { none() }
}

/** Creates a module for tracking flow through the name-binding graph. */
module Track<TrackInputSig Input> {
  private import Input

  /** Gets a name-binding node to which `node` can flow. */
  NameBindingNode track(NameBindingNode node) {
    shouldTrack(node) and
    result = node
    or
    exists(NameBindingNode prev | prev = track(node) | valueStepEx(prev, result))
  }

  /** Holds if there is an effective value step `node1 -> node2`. */
  pragma[inline]
  private predicate valueStepEx(NameBindingNode node1, NameBindingNode node2) {
    valueStep(node1, node2)
    or
    derivedStoreReadStep(node1, node2)
    or
    additionalValueStep(node1, node2)
  }
}

/**
 * Holds if `node1 -> node2` is derived by combining a store and a read step.
 */
pragma[nomagic]
private predicate derivedStoreReadStep(NameBindingNode node1, NameBindingNode node2) {
  exists(NamespaceNode namespace, string name |
    node1 = namespace.getMember(name) and
    readStep(namespace.ref(), name, node2)
  )
}

/** A name-binding node that has members. */
class NamespaceNode extends NameBindingNode {
  NamespaceNode() { storeStep(_, _, this) or inheritanceStep(_, this) }

  /** Gets a name-binding node that may refer to this namespace. */
  NameBindingNode ref() { result = TrackNamespace::track(this) }

  /** Gets an own (non-inherited) member of this namespace of the given name. */
  NameBindingNode getOwnMember(string name) { storeStep(result, name, this) }

  /** Holds if this namespace has an own-member of the given name */
  predicate hasOwnMember(string name) { exists(this.getOwnMember(name)) }

  /** Gets a namespace from which this namespace inherits directly. */
  NamespaceNode getAnInheritanceParent() { inheritanceStep(result.ref(), this) }

  /** Gets a namespace that directly inherits from this one. */
  NamespaceNode getAnInheritanceChild() { result.getAnInheritanceParent() = this }

  /** Gets a member of this namespace of the given name. */
  pragma[nomagic]
  NameBindingNode getMember(string name) {
    result = this.getOwnMember(name)
    or
    not this.hasOwnMember(name) and
    result = this.getAnInheritanceParent().getMember(name)
  }
}

private module TrackNamespaceInput implements TrackInputSig {
  predicate shouldTrack(NameBindingNode node) { node instanceof NamespaceNode }

  predicate additionalValueStep(NameBindingNode node1, NameBindingNode node2) {
    // Namespace-tracking goes through aliases, but declaration-tracking does not
    exists(TypeAliasDeclaration decl |
      node1 = getNodeFromRef(decl.getType()) and
      node2.isIdentifier(decl.getName())
    )
  }
}

private module TrackNamespace = Track<TrackNamespaceInput>;

/**
 * Holds if `decl` is a trivial local alias for an imported name.
 *
 * Declaration-tracking usually stops at type-aliases, but trivial aliases
 * will be passed through.
 */
predicate isTrivialNameAlias(NameDeclaration decl) {
  exists(ImportDeclaration imprt |
    decl = getIdentifierFromRef(imprt.getPattern()) and
    decl.getName() = getIdentifierFromRef(imprt.getImportedExpr()).getValue()
  )
}

private module TrackNameDeclarationInput implements TrackInputSig {
  predicate shouldTrack(NameBindingNode node) {
    exists(NameDeclaration decl |
      node.isIdentifier(decl) and
      not isTrivialNameAlias(decl)
    )
  }
}

private module TrackNameDeclaration = Track<TrackNameDeclarationInput>;

/** Gets a name-binding node that may refer to the given declaration. */
NameBindingNode trackNameDeclaration(NameDeclaration decl) {
  exists(NameBindingNode start |
    start.isIdentifier(decl) and
    result = TrackNameDeclaration::track(start)
  )
}

/** Holds if `node` should be included in the debug view. */
private signature predicate relevantFileSig(File node);

module DebugGraph<relevantFileSig/1 relevantFile> {
  private predicate relevantNode(NameBindingNode node) {
    relevantFile(node.getLocation().getFile())
  }

  query predicate nodes(NameBindingNode node, string key, string value) {
    relevantNode(node) and
    key = "semmle.label" and
    value = node.toString()
  }

  query predicate edges(NameBindingNode node1, NameBindingNode node2, string key, string value) {
    key = "semmle.label" and
    (
      valueStep(node1, node2) and value = ""
      or
      exists(string name |
        readStep(node1, name, node2) and
        value = "read(" + name + ")"
        or
        storeStep(node1, name, node2) and
        value = "store(" + name + ")"
      )
      or
      inheritanceStep(node1, node2) and
      value = "inheritedBy"
    )
  }
}
