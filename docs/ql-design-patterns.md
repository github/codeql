# CodeQL Design Patterns

A list of design patterns you are recommended to follow.

## `::Range` for extensibility and refinement

To allow both extensibility and refinement of classes, we use what is commonly referred to as the `::Range` pattern (since https://github.com/github/codeql/pull/727), but the actual implementation can use different names.

<details>
<summary>Generic example of how to define classes with ::Range</summary>

Instead of
```ql
/** <QLDoc...> */
abstract class MySpecialExpr extends Expr {
  /** <QLDoc...> */
  abstract int memberPredicate();
}
```
with
```ql
class ConcreteSubclass extends MySpecialExpr { ... }
```

use

```ql
/**
 * <QLDoc...>
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `MySpecialExpr::Range` instead.
 */
class MySpecialExpr extends Expr {
  MySpecialExpr::Range self;

  MySpecialExpr() { this = self }

  /** <QLDoc...> */
  int memberPredicate() { result = self.memberPredicate() }
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
with
```ql
class ConcreteSubclass extends MySpecialExpr::Range { ... }
```

</details>

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
