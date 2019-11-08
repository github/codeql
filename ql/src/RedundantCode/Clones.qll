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
    getParent() instanceof HashableNode
  }

  /**
   * An opaque integer describing the type of this AST node.
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
    literals(this, result, _)
    or
    not literals(this, _, _) and
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
  HashableNullaryNode() { not exists(getAChild()) }

  predicate unpack(int kind, string value) { kind = getKind() and value = getValue() }

  override HashedNode hash() {
    exists(int kind, string value | unpack(kind, value) | result = MkHashedNullaryNode(kind, value))
  }
}

/**
 * An AST node with exactly one child, which is at position zero.
 */
class HashableUnaryNode extends HashableNode {
  HashableUnaryNode() { getNumChild() = 1 and exists(getChild(0)) }

  predicate unpack(int kind, string value, HashedNode child) {
    kind = getKind() and value = getValue() and child = getChild(0).(HashableNode).hash()
  }

  override HashedNode hash() {
    exists(int kind, string value, HashedNode child | unpack(kind, value, child) |
      result = MkHashedUnaryNode(kind, value, child)
    )
  }
}

/**
 * An AST node with exactly two children, which are at positions zero and one.
 */
class HashableBinaryNode extends HashableNode {
  HashableBinaryNode() { getNumChild() = 2 and exists(getChild(0)) and exists(getChild(1)) }

  predicate unpack(int kind, string value, HashedNode left, HashedNode right) {
    kind = getKind() and
    value = getValue() and
    left = getChild(0).(HashableNode).hash() and
    right = getChild(1).(HashableNode).hash()
  }

  override HashedNode hash() {
    exists(int kind, string value, HashedNode left, HashedNode right |
      unpack(kind, value, left, right)
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
    exists(int n | n = strictcount(getAChild()) | n > 2 or not exists(getChild([0 .. n - 1])))
  }

  predicate unpack(int kind, string value, HashedChildren children) {
    kind = getKind() and value = getValue() and children = hashChildren()
  }

  predicate childAt(int i, HashedNode child, HashedChildren rest) {
    child = getChild(i).(HashableNode).hash() and rest = hashChildren(i + 1)
  }

  override HashedNode hash() {
    exists(int kind, string value, HashedChildren children | unpack(kind, value, children) |
      result = MkHashedNAryNode(kind, value, children)
    )
  }

  HashedChildren hashChildren() { result = hashChildren(0) }

  HashedChildren hashChildren(int i) {
    i = max(int n | exists(getChild(n))) + 1 and result = Nil()
    or
    exists(HashedNode child, HashedChildren rest | childAt(i, child, rest) |
      result = AHashedChild(i, child, rest)
    )
  }
}

newtype HashedNode =
  MkHashedNullaryNode(int kind, string value) { any(HashableNullaryNode nd).unpack(kind, value) } or
  MkHashedUnaryNode(int kind, string value, HashedNode child) {
    any(HashableUnaryNode nd).unpack(kind, value, child)
  } or
  MkHashedBinaryNode(int kind, string value, HashedNode left, HashedNode right) {
    any(HashableBinaryNode nd).unpack(kind, value, left, right)
  } or
  MkHashedNAryNode(int kind, string value, HashedChildren children) {
    any(HashableNAryNode nd).unpack(kind, value, children)
  }

newtype HashedChildren =
  Nil() or
  AHashedChild(int i, HashedNode child, HashedChildren rest) {
    exists(HashableNAryNode nd | nd.childAt(i, child, rest))
  }
