private import codeql.swift.generated.KeyPathComponent

class KeyPathComponent extends Generated::KeyPathComponent {
  /**
   * Property access like `.bar` in `\Foo.bar`.
   */
  predicate isProperty() { getKind() = 3 }

  /**
   * Array or dictionary subscript like `[1]` or `["a", "b"]`.
   */
  predicate isSubscript() { getKind() = 4 }

  /**
   * Optional forcing `!`.
   */
  predicate isOptionalForcing() { getKind() = 5 }

  /**
   * Optional chaining `?`.
   */
  predicate isOptionalChaining() { getKind() = 6 }

  /**
   * Implicit optional wrapping component inserted by the compiler when an optional chain ends in a non-optional value.
   */
  predicate isOptionalWrapping() { getKind() = 7 }

  /**
   * Reference to the entire object; the `self` in `\Foo.self`.
   */
  predicate isSelf() { getKind() = 8 }

  /**
   * Tuple indexing like `.1`.
   */
  predicate isTupleIndexing() { getKind() = 9 }
}
