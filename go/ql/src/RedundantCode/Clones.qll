/**
 * Provides predicates for hashing AST nodes by structure.
 */

import go

/**
 * The root of a sub-AST that should be hashed.
 */
abstract class HashRoot extends AstNode { }

/**
 * An AST node that can be hashed.
 */
class HashableNode extends AstNode {
  HashableNode() {
    this instanceof HashRoot or
    this.getParent() instanceof HashableNode
  }

  /**
   * Gets an opaque integer describing the type of this AST node.
   */
  int getKind() {
    exists(int baseKind |
      // map expression kinds to even positive numbers
      baseKind = this.(Expr).getKind() and
      result = (baseKind + 1) * 2
      or
      // map statement kinds to odd positive numbers
      baseKind = this.(Stmt).getKind() and
      result = baseKind * 2 + 1
      or
      // map declaration kinds to even negative numbers
      baseKind = this.(Decl).getKind() and
      result = -(baseKind + 1) * 2
      or
      // map declaration specifier kinds to odd negative numbers
      baseKind = this.(Spec).getKind() and
      result = -(baseKind * 2 + 1)
      or
      // give files kind zero
      this instanceof File and
      baseKind = 0 and
      result = 0
    )
  }

  /**
   * Gets the value of this AST node, or the empty string if it does not have one.
   */
  string getValue() {
    // for literals, get the exact value if available
    if exists(this.(BasicLit).getExactValue())
    then result = this.(BasicLit).getExactValue()
    else
      // for identifiers, get the name
      if this instanceof Ident
      then result = this.(Ident).getName()
      else
        // for everything else, give up
        result = ""
  }

  /**
   * Computes a hash for this AST node based on its structure.
   */
  abstract HashedNode hash();
}

/**
 * An AST node without any children.
 */
class HashableNullaryNode extends HashableNode {
  HashableNullaryNode() { not exists(this.getAChild()) }

  /** Holds if this node has the given `kind` and `value`. */
  predicate unpack(int kind, string value) { kind = this.getKind() and value = this.getValue() }

  override HashedNode hash() {
    exists(int kind, string value | this.unpack(kind, value) |
      result = MkHashedNullaryNode(kind, value)
    )
  }
}

/**
 * An AST node with exactly one child, which is at position zero.
 */
class HashableUnaryNode extends HashableNode {
  HashableUnaryNode() { this.getNumChild() = 1 and exists(this.getChild(0)) }

  /** Holds if this node has the given `kind` and `value`, and `child` is its only child. */
  predicate unpack(int kind, string value, HashedNode child) {
    kind = this.getKind() and
    value = this.getValue() and
    child = this.getChild(0).(HashableNode).hash()
  }

  override HashedNode hash() {
    exists(int kind, string value, HashedNode child | this.unpack(kind, value, child) |
      result = MkHashedUnaryNode(kind, value, child)
    )
  }
}

/**
 * An AST node with exactly two children, which are at positions zero and one.
 */
class HashableBinaryNode extends HashableNode {
  HashableBinaryNode() {
    this.getNumChild() = 2 and exists(this.getChild(0)) and exists(this.getChild(1))
  }

  /** Holds if this node has the given `kind` and `value`, and `left` and `right` are its children. */
  predicate unpack(int kind, string value, HashedNode left, HashedNode right) {
    kind = this.getKind() and
    value = this.getValue() and
    left = this.getChild(0).(HashableNode).hash() and
    right = this.getChild(1).(HashableNode).hash()
  }

  override HashedNode hash() {
    exists(int kind, string value, HashedNode left, HashedNode right |
      this.unpack(kind, value, left, right)
    |
      result = MkHashedBinaryNode(kind, value, left, right)
    )
  }
}

/**
 * An AST node with more than two children, or with non-consecutive children.
 */
class HashableNAryNode extends HashableNode {
  HashableNAryNode() {
    exists(int n | n = strictcount(this.getAChild()) |
      n > 2 or not exists(this.getChild([0 .. n - 1]))
    )
  }

  /** Holds if this node has the given `kind`, `value`, and `children`. */
  predicate unpack(int kind, string value, HashedChildren children) {
    kind = this.getKind() and value = this.getValue() and children = this.hashChildren()
  }

  /** Holds if `child` is the `i`th child of this node, and `rest` are its subsequent children. */
  predicate childAt(int i, HashedNode child, HashedChildren rest) {
    child = this.getChild(i).(HashableNode).hash() and rest = this.hashChildren(i + 1)
  }

  override HashedNode hash() {
    exists(int kind, string value, HashedChildren children | this.unpack(kind, value, children) |
      result = MkHashedNAryNode(kind, value, children)
    )
  }

  /** Gets the hash of this node's children. */
  private HashedChildren hashChildren() { result = this.hashChildren(0) }

  /** Gets the hash of this node's children, starting with the `i`th child. */
  private HashedChildren hashChildren(int i) {
    i = max(int n | exists(this.getChild(n))) + 1 and result = Nil()
    or
    exists(HashedNode child, HashedChildren rest | this.childAt(i, child, rest) |
      result = AHashedChild(i, child, rest)
    )
  }
}

/**
 * A normalized ("hashed") representation of an AST node.
 *
 * The normalized representation only captures the tree structure of the AST, discarding
 * any information about source location or node identity. Thus, if two parts of the AST
 * have identical hashes they are structurally identical.
 */
newtype HashedNode =
  /** A hashed representation of an AST node without any child nodes. */
  MkHashedNullaryNode(int kind, string value) { any(HashableNullaryNode nd).unpack(kind, value) } or
  /** A hashed representation of an AST node with a single child node. */
  MkHashedUnaryNode(int kind, string value, HashedNode child) {
    any(HashableUnaryNode nd).unpack(kind, value, child)
  } or
  /** A hashed representation of an AST node with two child nodes. */
  MkHashedBinaryNode(int kind, string value, HashedNode left, HashedNode right) {
    any(HashableBinaryNode nd).unpack(kind, value, left, right)
  } or
  /** A hashed representation of an AST node with three or more child nodes. */
  MkHashedNAryNode(int kind, string value, HashedChildren children) {
    any(HashableNAryNode nd).unpack(kind, value, children)
  }

/** A normalized ("hashed") representation of some or all of the children of a node. */
private newtype HashedChildren =
  Nil() or
  AHashedChild(int i, HashedNode child, HashedChildren rest) {
    exists(HashableNAryNode nd | nd.childAt(i, child, rest))
  }
