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
class MySpecialExpr extends Expr {
  MySpecialExpr::Range range;

  MySpecialExpr() { this = range }

  /** <QLDoc...> */
  int memberPredicate() { result = range.memberPredicate() }
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

The key element of the pattern is to provide a field of type `MySpecialExpr::Range`, equating it to `this` in the characteristic predicate of `MySpecialExpr`. In member predicates, we can use either `this` or `range`, depending on which type has the API we need.

</details>

Note that in some libraries, the `range` field is in fact called `self`. While we do recommend using `range` for consistency, the name of the field does not matter (and using `range` avoids confusion in contexts like Python analysis that has strong usage of `self`).

### Rationale

Let's use an example from the Go libraries: https://github.com/github/codeql-go/blob/2ba9bbfd8ba1818b5ee9f6009c86a605189c9ef3/ql/src/semmle/go/Concepts.qll#L119-L157

`EscapeFunction`, as the name suggests, models various APIs that escape meta-characters. It has a member-predicate `kind()` that tells you what sort of escaping the modelled function does. For example, if the result of that predicate is `"js"`, then this means that the escaping function is meant to make things safe to embed inside JavaScript.
`EscapeFunction::Range` is subclassed to model various APIs, and `kind()` is implemented accordingly.
But we can also subclass `EscapeFunction` to, as in the above example, talk about all JS-escaping functions.

You can, of course, do the same without the `::Range` pattern, but it's a little cumbersome:
If you only had an `abstract class EscapeFunction { ... }`, then `JsEscapeFunction` would need to be implemented in a slightly tricky way to prevent it from extending `EscapeFunction` (instead of refining it). You would have to give it a charpred `this instanceof EscapeFunction`, which looks useless but isn't. And additionally, you'd have to provide trivial `none()` overrides of all the abstract predicates defined in `EscapeFunction`. This is all pretty awkward, and we can avoid it by distinguishing between `EscapeFunction` and `EscapeFunction::Range`.


## Importing all subclasses of abstract base class

When providing an abstract class, you should ensure that all subclasses are included when the abstract class is (unless you have good reason not to). Otherwise you risk having different meanings of the abstract class depending on what you happen to import.

One example where this _does not_ apply: `DataFlow::Configuration` and its variants are abstract, but we generally do not want to import all configurations into the same scope at once.
