private import codeql.swift.generated.KeyPathComponent

class KeyPathComponent extends Generated::KeyPathComponent {
  /**
   * Property access like `.bar` in `\Foo.bar`.
   */
  predicate is_property() { getKind() = 3 }

  /**
   * Array or dictionary subscript like `[1]` or `["a", "b"]`.
   */
  predicate is_subscript() { getKind() = 4 }

  /**
   * Optional forcing `!`.
   */
  predicate is_optional_forcing() { getKind() = 5 }

  /**
   * Optional chaining `?`.
   */
  predicate is_optional_chaining() { getKind() = 6 }

  /**
   * Implicit optional wrapping component inserted by the compiler when an optional chain ends in a non-optional value.
   */
  predicate is_optional_wrapping() { getKind() = 7 }

  /**
   * Reference to the entire object; the `self` in `\Foo.self`.
   */
  predicate is_self() { getKind() = 8 }

  /**
   * Tuple indexing like `.1`.
   */
  predicate is_tuple_indexing() { getKind() = 9 }
}
