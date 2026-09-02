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
  TStaticMemberNamespace(ClassLikeDeclaration cls) or
  TInstanceMemberNamespace(ClassLikeDeclaration cls) or
  TLocalNamespace(AstNode n) {
    n = any(TopLevel t).getBody() or // Imported names come in scope here
    n instanceof ClassLikeDeclaration
  } or
  TModuleScope(ModuleScopeRepr repr) or
  TFolderScope(Folder folder) or
  TModuleRoot()

/**
 * A node in a graph, in which name-binding rules are represented as edges between nodes.
 */
class NameBindingNode extends TNameBindingNode {
  predicate isIdentifier(Identifier n) { this = TIdentifier(n) }

  Identifier asIdentifier() { this.isIdentifier(result) }

  predicate isBulkImport(BulkImportingPattern p) { this = TBulkImport(p) }

  predicate isLocalName(LocalName local) { this = TLocalName(local) }

  /** Holds if this represents the set of static members available in the given class. */
  predicate isStaticMemberNamespace(ClassLikeDeclaration cls) { this = TStaticMemberNamespace(cls) }

  /** Holds if this represents the set of instance members available in the given class. */
  predicate isInstanceMemberNamespace(ClassLikeDeclaration cls) {
    this = TInstanceMemberNamespace(cls)
  }

  /** Holds if this represents the set of members that can be accessed unqualified within the given scope. */
  predicate isLocalNamespace(AstNode n) { this = TLocalNamespace(n) }

  /** Holds if this represents the given module scope. */
  predicate isModuleScopeNode(ModuleScopeRepr repr) { this = TModuleScope(repr) }

  /** Holds if this represents the set of members that can be accessed unqualified within the given folder and subfolders. */
  predicate isFolderScope(Folder folder) { this = TFolderScope(folder) }

  /** Holds if this represents the root namespace in which all named modules are members. */
  predicate isModuleRoot() { this = TModuleRoot() }

  /**
   * Gets an AST node wrapped by this name-binding node, if such a node exists.
   *
   * Mainly for debugging purposes.
   */
  AstNode getWrappedAstNode() {
    this.isIdentifier(result)
    or
    this.isBulkImport(result)
    or
    this.isStaticMemberNamespace(result)
    or
    this.isInstanceMemberNamespace(result)
    or
    this.isLocalNamespace(result)
    or
    this.isModuleScopeNode(result)
  }

  string toString() {
    exists(Identifier n | this.isIdentifier(n) and result = "Identifier(" + n + ")")
    or
    exists(BulkImportingPattern p | this.isBulkImport(p) and result = "BulkImport(" + p + ")")
    or
    exists(LocalName local | this.isLocalName(local) and result = "LocalName(" + local + ")")
    or
    exists(ClassLikeDeclaration cls |
      this.isStaticMemberNamespace(cls) and result = "StaticMemberNamespace(" + cls + ")"
    )
    or
    exists(ClassLikeDeclaration cls |
      this.isInstanceMemberNamespace(cls) and result = "InstanceMemberNamespace(" + cls + ")"
    )
    or
    exists(AstNode n | this.isLocalNamespace(n) and result = "LocalNamespace(" + n + ")")
    or
    exists(ModuleScopeRepr repr |
      this.isModuleScopeNode(repr) and result = "ModuleScope(" + repr + ")"
    )
    or
    exists(Folder folder | this.isFolderScope(folder) and result = "FolderScope(" + folder + ")")
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
    exists(ClassLikeDeclaration cls |
      this.isStaticMemberNamespace(cls) and result = cls.getLocation()
    )
    or
    exists(ClassLikeDeclaration cls |
      this.isInstanceMemberNamespace(cls) and result = cls.getLocation()
    )
    or
    exists(AstNode n | this.isLocalNamespace(n) and result = n.getLocation())
    or
    exists(ModuleScopeRepr repr | this.isModuleScopeNode(repr) and result = repr.getLocation())
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
private NameBindingNode getNodeFromUncertainScope(AstNode n) { result.isLocalNamespace(n) }

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
    not access.isDeclarationSite() and
    name = access.getName() and
    node1 = getNodeFromUncertainScope(LocalNameBindingOutput::getAnUncertainScope(access, name)) and
    node2.isIdentifier(access)
  )
  or
  exists(NameExpr expr |
    isImportPrefix(expr) and
    node1.isModuleRoot() and
    name = expr.getIdentifier().getValue() and
    node2 = getNodeFromRef(expr)
  )
}

predicate storeStep(NameBindingNode node1, string name, NameBindingNode node2) {
  exists(ClassLikeDeclaration cls, Member member, NameDeclaration nameDecl |
    member = cls.getAMember() and
    not isPrivateToLocalScope(nameDecl) and
    nameDecl.getDeclaration() = member and
    node1.isIdentifier(nameDecl) and
    name = nameDecl.getName() and
    if isInstanceMember(member)
    then node2.isInstanceMemberNamespace(cls)
    else node2.isStaticMemberNamespace(cls)
  )
  or
  exists(TopLevel top, Stmt stmt, NameDeclaration nameDecl |
    stmt = top.getBody().getAStmt() and
    not isPrivateToLocalScope(nameDecl) and
    nameDecl.getDeclaration() = stmt and
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
  or
  FolderHeuristic::storeStep(node1, name, node2)
}

predicate valueStep(NameBindingNode node1, NameBindingNode node2) {
  exists(PotentialLocalNameAccess access |
    access.isDeclarationSite() and
    node1.isIdentifier(access) and
    node2.isLocalName(access.getLocalName())
    or
    not access.isDeclarationSite() and
    node1.isLocalName(access.getLocalName()) and
    node2.isIdentifier(access)
  )
  or
  exists(ClassLikeDeclaration cls |
    node1.isStaticMemberNamespace(cls) and
    node2.isIdentifier(cls.getName())
  )
  or
  exists(ClassLikeDeclaration cls |
    node1.isStaticMemberNamespace(cls) and
    node2.isLocalNamespace(cls)
  )
  or
  exists(TopLevel top |
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
      not isPrivateToLocalScope(p) and
      node2 = getModuleNodeFromFile(top.getFile())
    )
  )
  or
  exists(NamePattern p |
    node1 = getNodeFromRef(p) and
    node2 = getNodeFromRef(p.getSubPattern())
  )
  or
  FolderHeuristic::valueStep(node1, node2)
}

private predicate isImportPrefix(Expr e) {
  e = any(ImportDeclaration impr).getImportedExpr()
  or
  exists(MemberAccessExpr member |
    isImportPrefix(member) and
    e = member.getBase()
  )
}

predicate inheritanceStep(NameBindingNode supertype, NameBindingNode subtype) {
  exists(ClassLikeDeclaration cls, BaseType base |
    base = cls.getABaseType() and
    supertype = getNodeFromRef(base.getType()) and
    subtype.isStaticMemberNamespace(cls)
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
 * Holds if `node1 -> node2` is derived by combining a store and a read step, with zero or more value steps and inheritance steps in-between.
 */
pragma[nomagic]
private predicate derivedStoreReadStep(NameBindingNode node1, NameBindingNode node2) {
  exists(NamespaceNode namespace, string name |
    node1 = namespace.getMember(name) and // getMember() combines a store step with subsequent inheritance steps
    readStep(namespace.ref(), name, node2) and
    node1 != node2
  )
}

/** Holds if the member represented by `node` can be inherited. */
pragma[nomagic]
private predicate isInheritableMemberNode(NameBindingNode node) {
  exists(NameDeclaration decl |
    node.isIdentifier(decl) and
    isInheritableMember(decl.getDeclaration())
  )
}

/** A name-binding node that can have members. */
class NamespaceNode extends NameBindingNode {
  NamespaceNode() {
    storeStep(_, _, this) or
    inheritanceStep(_, this) or
    this.isInstanceMemberNamespace(_) or
    this.isStaticMemberNamespace(_)
  }

  /** Gets a name-binding node that may refer to this namespace. */
  NameBindingNode ref() { result = TrackNamespace::track(this) }

  /** Gets an own (non-inherited) member of this namespace of the given name. */
  NameBindingNode getOwnMember(string name) { storeStep(result, name, this) }

  /** Holds if this namespace has an own-member of the given name */
  predicate hasOwnMember(string name) { exists(this.getOwnMember(name)) }

  /** If this is the static namespace for a class, gets the corresponding instance namespace. */
  NamespaceNode toInstanceNamespace() {
    exists(ClassLikeDeclaration cls |
      this.isStaticMemberNamespace(cls) and
      result.isInstanceMemberNamespace(cls)
    )
  }

  /** If this is the instance namespace for a class, gets the corresponding static namespace. */
  NamespaceNode toStaticNamespace() { result.toInstanceNamespace() = this }

  private NamespaceNode getAnInheritanceParent1() { inheritanceStep(result.ref(), this) }

  /** Gets a namespace from which this namespace inherits directly. */
  NamespaceNode getAnInheritanceParent() {
    result = this.getAnInheritanceParent1()
    or
    // `inheritanceStep` connects the static namespaces of classes.
    // Add the corresponding inheritance relation between the instance namespaces.
    result = this.toStaticNamespace().getAnInheritanceParent1().toInstanceNamespace()
  }

  /** Gets a namespace that directly inherits from this one. */
  NamespaceNode getAnInheritanceChild() { result.getAnInheritanceParent() = this }

  /** Gets a member of this namespace of the given name. */
  pragma[nomagic]
  NameBindingNode getMember(string name) {
    result = this.getOwnMember(name)
    or
    not this.hasOwnMember(name) and
    result = this.getAnInheritanceParent().getMember(name) and
    isInheritableMemberNode(result)
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
private signature predicate relevantNodeSig(AstNode node);

module DebugGraph<relevantNodeSig/1 relevantNode> {
  private predicate relevantNameBindingNode(NameBindingNode node) {
    relevantNode(node.getWrappedAstNode())
    or
    // Also consider LocalName to be relevant if any of its accesses are relevant
    exists(LocalName name |
      node.isLocalName(name) and
      relevantNode(any(PotentialLocalNameAccess ac | ac.getLocalName() = name))
    )
    or
    // Always include module root
    node.isModuleRoot()
  }

  query predicate nodes(NameBindingNode node, string key, string value) {
    relevantNameBindingNode(node) and
    key = "semmle.label" and
    value = node.toString()
  }

  query predicate edges(NameBindingNode node1, NameBindingNode node2, string key, string value) {
    key = "semmle.label" and
    relevantNameBindingNode(node1) and
    relevantNameBindingNode(node2) and
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

/**
 * Implements a folder-based heuristic for linking up top-level names
 * between files that are not included in any module scope.
 */
private module FolderHeuristic {
  private predicate topLevelNameDef(File file, string name, NameBindingNode node) {
    exists(TopLevel top, Stmt stmt, NameDeclaration nameDecl |
      top.getFile() = file and
      stmt = top.getBody().getAStmt() and
      not isPrivateToLocalScope(nameDecl) and
      nameDecl.getDeclaration() = stmt and
      name = nameDecl.getName() and
      node.isIdentifier(nameDecl)
    )
  }

  private predicate uniqueTopLevelName(File file, string name) {
    file = unique(File f | topLevelNameDef(f, name, _))
  }

  /**
   * Holds if `file` has one of the definitions of the given ambiguous name.
   *
   * A name is considered "ambiguous" if there is more than one file exporting it.
   */
  private predicate ambiguousTopLevelName(File file, string name) {
    topLevelNameDef(file, name, _) and
    not uniqueTopLevelName(file, name)
  }

  /** Holds if `folder` contains one or more definitions of the given ambiguous name */
  private predicate containsDef(Folder folder, string name) {
    exists(File f |
      ambiguousTopLevelName(f, name) and
      folder = f.getParentContainer+()
    )
  }

  /**
   * Holds if `folder` has two or more subfolders containing a definition of `name`.
   */
  private predicate hasConflictingDefs(Folder folder, string name) {
    // Check for "two or more" using `exists(X) and not exists(unique(X))`
    containsDef(folder.getAFolder(), name) and
    not exists(unique(Folder child | child = folder.getAFolder() and containsDef(child, name)))
  }

  /**
   * Holds if `folder` is an outermost folder containing exactly one definition of `name`.
   *
   * This means `folder` should act as the scope of that definition.
   */
  private predicate isOutermostNonConflictingScope(Folder folder, string name) {
    containsDef(folder, name) and
    hasConflictingDefs(folder.getParentContainer(), name) and
    not hasConflictingDefs(folder, name)
  }

  /**
   * Gets the scope into which a definition of `name` appearing in `folder` should target.
   */
  private Folder getOutermostNonConflictingScope(Folder folder, string name) {
    isOutermostNonConflictingScope(folder, name) and
    result = folder
    or
    result = getOutermostNonConflictingScope(folder.getParentContainer(), name) and
    containsDef(folder, name) // Prune to the subfolder actually containing the definition
  }

  predicate storeStep(NameBindingNode node1, string name, NameBindingNode node2) {
    exists(File file | topLevelNameDef(file, name, node1) |
      node2.isFolderScope(getOutermostNonConflictingScope(file.getParentContainer(), name))
      or
      uniqueTopLevelName(file, name) and
      node2.isFolderScope(any(Folder f | f.getRelativePath() = ""))
    )
  }

  predicate valueStep(NameBindingNode node1, NameBindingNode node2) {
    exists(TopLevel top |
      node1.isFolderScope(top.getFile().getParentContainer()) and
      node2.isLocalNamespace(top.getBody()) and
      not top.getFile() = any(ModuleScopeRepr r).getAnIncludedFile()
    )
    or
    exists(Folder folder |
      node1.isFolderScope(folder.getParentContainer()) and
      node2.isFolderScope(folder)
    )
  }
}

/**
 * Holds if `access` may resolve to `target` through the enclosing `accessingClass`.
 *
 * `instanceAccess` indicates whether this member should be accessed as an instance of `accessingClass`
 * or as a static member.
 */
private predicate unqualifiedMemberAccessCand(
  PotentialLocalNameAccess access, boolean instanceAccess, NameDeclaration target,
  ClassLikeDeclaration accessingClass
) {
  not access instanceof NameDeclaration and
  (
    // Resolved by local scoping
    exists(LocalName local |
      target.getLocalName() = local and
      access.getLocalName() = local and
      target.getDeclaration() = accessingClass.getAMember()
    |
      instanceAccess = true and
      isInstanceMember(target.getDeclaration())
      or
      instanceAccess = false and
      isStaticMember(target.getDeclaration())
    )
    or
    // Resolved in an uncertain scope
    exists(NamespaceNode namespace, string name |
      name = access.getName() and
      accessingClass = LocalNameBindingOutput::getAnUncertainScope(access, name)
    |
      instanceAccess = true and
      namespace.isInstanceMemberNamespace(accessingClass) and
      namespace.getMember(name).isIdentifier(target)
      or
      instanceAccess = false and
      namespace.isStaticMemberNamespace(accessingClass) and
      namespace.getMember(name).isIdentifier(target)
    )
  )
}

private int unqualifiedMemberAccessDepth(PotentialLocalNameAccess access) {
  result = max(AstNode scope | unqualifiedMemberAccessCand(access, _, _, scope) | scope.getDepth())
}

/**
 * Holds if `access` is an unqualified access to `target`.
 *
 * `accessingClass` is the enclosing class in which the member was found, and
 * `instanceAccess` indicates if it is an instance member or static member.
 */
predicate unqualifiedMemberAccess(
  PotentialLocalNameAccess access, boolean instanceAccess, NameDeclaration target,
  ClassLikeDeclaration accessingClass
) {
  unqualifiedMemberAccessCand(access, instanceAccess, target, accessingClass) and
  accessingClass.getDepth() = unqualifiedMemberAccessDepth(access)
}

/**
 * An identifier appearing in a unqualified position, referring to a member of an enclosing class.
 */
class UnqualifiedMemberAccess extends Identifier {
  private boolean instanceAccess;
  private NameDeclaration target;
  private ClassLikeDeclaration accessingClass;

  UnqualifiedMemberAccess() {
    unqualifiedMemberAccess(this, instanceAccess, target, accessingClass)
  }

  /** Gets the name declaration of the member being accessed. */
  NameDeclaration getTarget() { result = target }

  /** Gets the enclosing class whose (possibly inherited) member is being accessed. */
  ClassLikeDeclaration getAccessingClass() { result = accessingClass }

  /** Holds if this is an instance access on the accessing class. */
  predicate isInstanceAccess() { instanceAccess = true }
}

/** Gets the declaration being accessed by `access`, as determined by static name binding. */
NameDeclaration getStaticBindingTarget(Identifier access) {
  // For unqualified accesses, use the shadowing-aware lookup
  result = access.(UnqualifiedMemberAccess).getTarget()
  or
  // For others, just follow the name binding graph
  not access instanceof UnqualifiedMemberAccess and
  trackNameDeclaration(result).asIdentifier() = access
}
