# CodeQL Design Patterns

A list of design patterns you are recommended to follow.

## `::Range` for extensibility and refinement

To allow both extensibility and refinement of classes, we use what is commonly referred to as the `::Range` pattern (since https://github.com/github/codeql/pull/727), but the actual implementation can use different names.

This pattern should be used when you want to model a user-extensible set of values ("extensibility"), while allowing restrictive subclasses, typically for the purposes of overriding predicates ("refinement"). Using a simple `abstract` class gives you the former, but makes it impossible to create overriding methods for all contributing extensions at once. Using a non-`abstract` class provides refinement-based overriding, but requires the original class to range over a closed, non-extensible set.
<details>
<summary>Generic example of how to define classes with ::Range</summary>

Using a single `abstract` class looks like this:
```ql
/** <QLDoc...> */
abstract class MySpecialExpr extends Expr {
  /** <QLDoc...> */
  abstract int memberPredicate();
}
class ConcreteSubclass extends MySpecialExpr { ... }
```

While this allows users of the library to add new types of `MySpecialExpr` (like, in this case, `ConcreteSubclass`), there is no way to override the implementations of `memberPredicate` of all extensions at once.

Applying the `::Range` pattern yields the following:

```ql
/**
 * <QLDoc...>
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `MySpecialExpr::Range` instead.
 */
class MySpecialExpr extends Expr instanceof MySpecialExpr::Range {
  /** <QLDoc...> */
  int memberPredicate() { result = super.memberPredicate() }
}

/** Provides a class for modeling new <...> APIs. */
module MySpecialExpr {
  /**
   * <QLDoc...>
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `MySpecialExpr` instead.
   */
  abstract class Range extends Expr {
    /** <QLDoc...> */
    abstract int memberPredicate();
  }
}
```
Now, a concrete subclass can derive from `MySpecialExpr::Range` if it wants to extend the set of values in `MySpecialExpr`, and it will be required to implement the abstract `memberPredicate()`. Conversely, if it wants to refine `MySpecialExpr` and override `memberPredicate` for all extensions, it can do so by deriving from `MySpecialExpr` directly.

</details>

### Rationale

Let's use an example from the Python libraries: https://github.com/github/codeql/blob/46751e515c40c6b4c9b61758cc840eec1894a624/python/ql/lib/semmle/python/Concepts.qll#L601-L683

`Escaping`, as the name suggests, models various APIs that escape meta-characters. It has a member-predicate `getKind()` that tells you what sort of escaping the modeled function does. For example, if the result of that predicate is `"html"`, then this means that the escaping function is meant to make things safe to embed inside HTML.
`Escaping::Range` is subclassed to model various APIs, and `kind()` is implemented accordingly (this typically happens in library models).
But we can also subclass `Escaping`, as in the above example, where `HtmlEscaping` represents all HTML-escaping functions.

You can, of course, do the same without the `::Range` pattern, but it's a little cumbersome:
If you only had an `abstract class Escaping { ... }`, then `HtmlEscaping` would need to be implemented in a slightly tricky way to prevent it from extending `Escaping` (instead of refining it). You would have to give it a charpred `this instanceof Escaping`, which looks useless but isn't. And additionally, you'd have to provide trivial `none()` overrides of all the abstract predicates defined in `Escaping`. This is all pretty awkward, and we can avoid it by distinguishing between `Escaping` and `Escaping::Range`.


## Importing all subclasses of a class

Importing new files can modify the behaviour of the standard library, by introducing new subtypes of `abstract` classes, by introducing new multiple inheritance relationships, or by overriding predicates. This can change query results and force evaluator cache misses.

Therefore, unless you have good reason not to, you should ensure that all subclasses are included when the base-class is (to the extent possible).


## Abstract classes as open or closed unions

A class declared as `abstract` in QL represents a union of its direct subtypes (restricted by the intersections of its supertypes and subject to its characteristic predicate). Depending on context, we may want this union to be considered "open" or "closed".

An open union is generally used for extensibility. For example, the abstract classes suggested by the `::Range` design pattern are explicitly intended as extension hooks.

A closed union is a class for which we do not expect users of the library to add more values. Historically, we have occasionally modelled this as `abstract` classes in QL, but these days that would be considered an anti-pattern: Abstract classes that are intended to be closed behave in surprising ways when subclassed by library users, and importing libraries that include derived classes can invalidate compilation caches and subvert the meaning of the program.

As an example, suppose we want to define a `BinaryExpr` class, which has subtypes of `PlusExpr`, `MinusExpr`, and so on. Morally, this represents a closed union: We do not anticipate new kinds of `BinaryExpr` being added. Therefore, it would be undesirable to model it as an abstract class:

```ql
/** ANTI-PATTERN */
abstract class BinaryExpr extends Expr {
  Expr getLhs() { result = this.getChild(0) }
  Expr getRight() { result = this.getChild(1) }
}

class PlusExpr extends BinaryExpr {}
class MinusExpr extends BinaryExpr {}
...
```

Instead, the `BinaryExpr` class should be non-`abstract`, and we have the following options for specifying its extent:

- Define a dbscheme type `@binary_expr = @plus_expr | @minus_expr | ...` and add it as an additional super-class for `BinaryExpr`.
- Define a type alias `class RawBinaryExpr = @plus_expr | @minus_expr | ...` and add it as an additional super-class for `BinaryExpr`.
- Add a characteristic predicate of `BinaryExpr() { this instanceof PlusExpr or this instanceof MinusExpr or ... }`.
