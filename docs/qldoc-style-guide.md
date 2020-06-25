# QLDoc style guide 

## Introduction

Valid QL comments are known as QLDoc. This document describes the recommended styles and conventions you should use when writing QLDoc for code contributions in this repository. If there is a conflict between any of the recommendations in this guide and clarity, then clarity should take precedence.

### General requirements

1. Documentation must adhere to the [QLDoc specification](https://help.semmle.com/QL/ql-handbook/qldoc.html).
1. Documentation comments should be appropriate for users of the code.
1. Documentation for maintainers of the code must use normal comments.
1. Use `/** ... */` for documentation, even for single line comments.
   - For single-line documentation, the `/**` and `*/` are written on the same line as the comment.
   - For multi-line documentation, the `/**` and `*/` are written on separate lines. There is a `*` preceding each comment line, aligned on the first `*`.
1. Use code formatting (backticks) within comments for code from the source language, and also for QL code (for example, names of classes, predicates, and variables).
1. Give explanatory examples of code in the target language, enclosed in ```` ```<target language> ````  or `` ` ``.


### Language requirements

1. Use American English.
1. Use full sentences, with capital letters and periods, except for the initial sentence of the comment, which may be fragmentary as described below.
1. Use simple sentence structures and avoid complex or academic language.
1. Avoid colloquialisms and contractions.
1. Use words that are in common usage.


### Requirements for specific items

1. Public declarations must be documented.
1. Non-public declarations should be documented.
1. Declarations in query files should be documented.
1. Library files (`.qll` files) should be have a documentation comment at the top of the file.
1. Query files, except for tests, must have a QLDoc query documentation comment at the top of the file.

## QLDoc for predicates

1. Refer to all predicate parameters in the predicate documentation.
1. Reference names, such as types and parameters, using backticks `` ` ``.
1. Give examples of code in the target language, enclosed in ```` ```<target language> ````  or `` ` ``.
1. Predicates that override a single predicate don't need QLDoc, as they will inherit it.

### Predicates without result

1. Use a third-person verb phrase of the form ``Holds if `arg` has <property>.``
1. Avoid:
   - `/** Whether ... */`
   - `/**" Relates ... */`
   - Question forms:
     - ``/** Is `x` a foo? */``
     - ``/** Does `x` have a bar? */``

#### Example

```ql
/**
 * Holds if the qualifier of this call has type `qualifierType`.
 * `isExactType` indicates whether the type is exact, that is, whether
 * the qualifier is guaranteed not to be a subtype of `qualifierType`.
 */
```

### Predicates with result

1. Use a third-person verb phrase of the form `Gets (a|the) <thing>.`
1. Use "if any" if the item is usually unique but might be missing. For example
`Gets the body of this method, if any.`
1. If the predicate has more complex behaviour, for example multiple arguments are conceptually "outputs", it can be described like a predicate without a result. For example
``Holds if `result` is a child of this expression.``
1. Avoid:
   - `Get a ...`
   - `The ...`
   - `Results in ...`
   - Any use of `return`

#### Example
```ql
/**
 * Gets the expression denoting the super class of this class,
 * or nothing if this is an interface or a class without an `extends` clause.
 */
```

### Deprecated predicates

The documentation for deprecated predicates should be updated to emphasize the deprecation and specify what predicate to use as an alternative.
Insert a sentence of the form `DEPRECATED: Use <other predicate> instead.` at the start of the QLDoc comment. 

#### Example

```ql
/** DEPRECATED: Use `getAnExpr()` instead. */
deprecated Expr getInitializer()
```

### Internal predicates

Some predicates are internal-only declarations that cannot be made private. The documentation for internal predicates should begin with `INTERNAL: Do not use.`

#### Example

```ql
/**
 * INTERNAL: Do not use.
 */
```

### Special predicates

Certain special predicates should be documented consistently.

- Always document `toString` as 
  
  ```ql
  /** Gets a textual representation of this element. */
  string toString() { ... } 
  ```

- Always document `hasLocationInfo` as

  ```ql
  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/locations.html).
   */

  predicate hasLocationInfo(string filepath, int startline, int startcolumn, int endline, int endcolumn) { ... }
  ```
## QLDoc for classes

1. Document classes using a noun phrase of the form `A <domain element> that <has property>.`
1. Use "that", not "which".
1. Refer to member elements in the singular.
1. Where a class denotes a generic concept with subclasses, list those subclasses.

#### Example

```ql
/**
 * A delegate declaration, for example
 * ```
 * delegate void Logger(string text);
 * ```
 */
class Delegate extends ...
```

```ql
/**
 * An element that can be called.
 *
 * Either a method (`Method`), a constructor (`Constructor`), a destructor
 * (`Destructor`), an operator (`Operator`), an accessor (`Accessor`),
 * an anonymous function (`AnonymousFunctionExpr`), or a local function
 * (`LocalFunction`).
 */
class Callable extends ...
```

## QLDoc for modules

Modules should be documented using a third-person verb phrase of the form `Provides <classes and predicates to do something>.` 

#### Example

```ql
/** Provides logic for determining constant expressions. */
```
```ql
/** Provides classes representing the control flow graph within functions. */
```

## Special variables

When referring to `this`, you may either refer to it as `` `this` `` or `this <type>`. For example:
- ``Holds if `this` is static.``
- `Holds if this method is static.`

When referring to `result`, you may either refer to it as `` `result` `` or as `the result`. For example:
- ``Holds if `result` is a child of this expression.``
- `Holds if the result is a child of this expression.`
