private import codeql.swift.generated.KeyPathComponent
private import swift

module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A component of a `KeyPathExpr`.
   */
  class KeyPathComponent extends Generated::KeyPathComponent {
    /**
     * Property access like `.bar` in `\Foo.bar`.
     */
    predicate isProperty() { this.getKind() = 3 }

    /**
     * Array or dictionary subscript like `[1]` or `["a", "b"]`.
     */
    predicate isSubscript() { this.getKind() = 4 }

    /**
     * Optional forcing `!`.
     */
    predicate isOptionalForcing() { this.getKind() = 5 }

    /**
     * Optional chaining `?`.
     */
    predicate isOptionalChaining() { this.getKind() = 6 }

    /**
     * Implicit optional wrapping component inserted by the compiler when an optional chain ends in a non-optional value.
     */
    predicate isOptionalWrapping() { this.getKind() = 7 }

    /**
     * Reference to the entire object; the `self` in `\Foo.self`.
     */
    predicate isSelf() { this.getKind() = 8 }

    /**
     * Tuple indexing like `.1`.
     */
    predicate isTupleIndexing() { this.getKind() = 9 }

    /** Gets the underlying key-path expression which this is a component of. */
    KeyPathExpr getKeyPathExpr() { result.getAComponent() = this }

    /** Holds if this component is the i'th component of the underling key-path expression. */
    predicate hasIndex(int i) { any(KeyPathExpr e).getComponent(i) = this }

    /** Gets the next component of the underlying key-path expression. */
    KeyPathComponent getNextComponent() {
      exists(int i, KeyPathExpr e |
        hasKeyPathExprAndIndex(e, i, this) and
        hasKeyPathExprAndIndex(e, i + 1, result)
      )
    }
  }

  pragma[nomagic]
  private predicate hasKeyPathExprAndIndex(KeyPathExpr e, int i, KeyPathComponent c) {
    e.getComponent(i) = c
  }
}
