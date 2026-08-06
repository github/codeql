/**
 * Provides classes for reasoning about static references to the members of classes and top-levels.
 */

private import unified
private import codeql.unified.internal.LocalNameBinding
private import codeql.unified.internal.NameBindingPlugin

private newtype TNameBindingNode =
  TIdentifier(Identifier n) or
  TLocalName(LocalName local) or
  TExportedNamespace(ClassLikeDeclaration cls)

/**
 * A node in a graph, in which name-binding rules are represented as edges between nodes.
 */
class NameBindingNode extends TNameBindingNode {
  predicate isIdentifier(Identifier n) { this = TIdentifier(n) }

  Identifier asIdentifier() { this.isIdentifier(result) }

  predicate isLocalName(LocalName local) { this = TLocalName(local) }

  /** Holds if this represents the set of static members available in the given namespace (currently restricted to classes) */
  predicate isExportedNamespace(ClassLikeDeclaration cls) { this = TExportedNamespace(cls) }

  string toString() {
    exists(Identifier n | this.isIdentifier(n) and result = "Identifier(" + n + ")")
    or
    exists(LocalName local | this.isLocalName(local) and result = "LocalName(" + local + ")")
    or
    exists(ClassLikeDeclaration cls |
      this.isExportedNamespace(cls) and result = "ExportedNamespace(" + cls + ")"
    )
  }

  Location getLocation() {
    exists(Identifier n | this.isIdentifier(n) and result = n.getLocation())
    or
    exists(LocalName local | this.isLocalName(local) and result = local.getLocation())
    or
    exists(ClassLikeDeclaration cls | this.isExportedNamespace(cls) and result = cls.getLocation())
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

NameBindingNode getNodeFromRef(AstNode n) { result.isIdentifier(getIdentifierFromRef(n)) }

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
  NamespaceNode() { storeStep(_, _, this) }

  /** Gets a name-binding node that may refer to this namespace. */
  NameBindingNode ref() { result = TrackNamespace::track(this) }

  /** Gets a member of this namespace of the given name. */
  NameBindingNode getMember(string name) { storeStep(result, name, this) }
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

private module TrackNameDeclarationInput implements TrackInputSig {
  predicate shouldTrack(NameBindingNode node) { node.isIdentifier(any(NameDeclaration d)) }
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
    )
  }
}
