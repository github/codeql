# QL Style Guide

## Introduction

This document describes how to format the QL code you contribute to this repository. It covers aspects such as layout, white-space, naming, and documentation. Adhering to consistent standards makes code easier to read and maintain. Of course, these are only guidelines, and can be overridden as the need arises on a case-by-case basis. Where existing code deviates from these guidelines, prefer consistency with the surrounding code.
Note, if you use QL for Eclipse, you can auto-format your query in the (QL editor)[https://help.semmle.com/ql-for-eclipse/Content/WebHelp/ql-editor.html].

Words in *italic* are defined in the [Glossary](#glossary).

## Indentation
1. *Always* use 2 spaces for indentation.
1. *Always* indent:
   - The *body* of a module, newtype, class or predicate
   - The second and subsequent lines after you use a line break to split a long line
   - The *body* of a `from`, `where` or `select` clause where it spans multiple lines
   - The *body* of a *quantifier* that spans multiple lines


### Examples

```ql
module Helpers {
  /** ... */
  class X ... {
    /** ... */
    int getNumberOfChildren () {
      result = count(int child |
        exists(this.getChild(child))
      )
    }
  }
}
```

```ql
from Call c, string reason
where isDeprecated(c, reason)
select c, "This call to '$@' is deprecated because " + reason + ".",
  c.getTarget(), c.getTarget().getName()
```

## Line breaks
1. Use UNIX line endings.
1. Lines *must not* exceed 100 characters.
1. Long lines *should* be split with a line break, and the following lines *must* be indented one level until the next "regular" line break.
1. There *should* be a single blank line:
   - Between the file documentation and the first `import`
   - Before each declaration, except for the first declaration in a *body*
   - Before the `from`-`where`-`select` section in a query file
1. *Avoid* two or more adjacent blank lines.
1. There *must* be a new line after the *annotations* `cached`, `pragma`, `language` and `bindingset`. Other *annotations* do not have a new line.
1. There *should not* be additional blank lines within a predicate.
1. There *may* be a new line:
   - Immediately after the `from`, `where` or `select` keywords in a query.
   - Immediately after `if`, `then`, or `else` keywords.
1. *Avoid* other line breaks in declarations, other than to break long lines.
1. When operands of *binary operators* span two lines, the operator *should* be placed at the end of the first line.
1. If the parameter list needs to be broken across multiple lines then there *must* be a line break after the opening `(`, the parameter declarations indented one level, and the `) {` *must* be on its own line at the outer indentation.

### Examples

```ql
cached
private int getNumberOfParameters() {
  ...
}
```

```ql
predicate methodStats(
  string qualifiedName, string name, int numberOfParameters,
  int numberOfStatements, int numberOfExpressions, int linesOfCode,
  int nestingDepth, int numberOfBranches
) {
  ...
}
```

```ql
from Method main
where main.getName() = "Main"
select main, "This is the program entry point."
```

```ql
from Method main
where
  main.getName() = "Main" and
  main.getNumberOfParameters() = 0
select main, "Main method has no parameters."
```

```ql
  if x.isPublic()
  then result = "public"
  else result = "private"
```

```ql
  if
    x.isPublic()
  then
    result = "public"
  else
    result = "private"
```

```ql
  if x.isPublic()
  then result = "public"
  else
    if x.isPrivate()
    then result = "private"
    else result = "protected"
```


## Braces
1. Braces follow [Stroustrup](https://en.wikipedia.org/wiki/Indentation_style#Variant:_Stroustrup) style. The opening `{` *must* be placed at the end of the preceding line.
1. The closing `}` *must* be placed on its own line, indented to the outer level, or be on the same line as the opening `{`.
1. Braces of empty blocks *may* be placed on a single line, with a single space separating the braces.
1. Short predicates, not exceeding the maximum line width, *may* be placed on a single line, with a space following the opening brace and preceding the closing brace.

### Examples

```ql
class ThrowException extends ThrowExpr {
  Foo() {
    this.getTarget() instanceof ExceptionClass
  }

  override string toString() { result = "Throw Exception" }
}
```

## Spaces
1. There *must* be a space or line break:
   - Surrounding each `=` and `|`
   - After each `,`
1. There *should* be a space or line break:
   - Surrounding each *binary operator*, which *must* be balanced
   - Surrounding `..` in a range
   - Exceptions to this may be made to save space or to improve readability.
1. *Avoid* other spaces, for example:
   - After a *quantifier/aggregation* keyword
   - After the predicate name in a *call*
   - Inside brackets used for *calls*, single-line quantifiers, and parenthesised formulas
   - Surrounding a `.`
   - Inside the opening or closing `[ ]` in a range expression
   - Inside casts `a.(X)`
1. *Avoid* multiple spaces, except for indentation, and *avoid* additional indentation to align formulas, parameters or arguments.
1. *Do not* put whitespace on blank lines, or trailing on the end of a line.
1. *Do not* use tabs.


### Examples

```ql
cached
private predicate foo(Expr e, Expr p) {
  exists(int n |
    n in [0 .. 1] |
    e = p.getChild(n + 1)
  )
}
```

## Naming
1. Use [PascalCase](http://wiki.c2.com/?PascalCase) for:
   - `class` names
   - `module` names
   - `newtype` names
1. Use [camelCase](https://en.wikipedia.org/wiki/Camel_case) for:
   - Predicate names
   - Variable names
1. Newtype predicate names *should* begin with `T`.
1. Predicates that have a result *should* be named `get...`
1. Predicates that can return multiple results *should* be named `getA...` or `getAn...`
1. Predicates that don't have a result or parameters *should* be named `is...` or `has...`
1. *Avoid* underscores in names.
1. *Avoid* short or single-letter names for classes, predicates and fields.
1. Short or single letter names for parameters and *quantifiers* *may* be used provided that they are sufficiently clear.
1. Use names as they are used in the target-language specification.
1. Use American English.

### Examples

```ql
/** ... */
predicate calls(Callable caller, Callable callee) {
  ...
}
```

```ql
/** ... */
class Type extends ... {
  /** ... */
  string getName() { ... }

  /** ... */
  predicate declares(Member m) { ... }

  /** ... */
  predicate isGeneric() { ... }

  /** ... */
  Type getTypeParameter(int n) { ... }

  /** ... */
  Type getATypeParameter() { ... }
}
```

## Documentation

General requirements:

1. Documentation *must* adhere to the [QLDoc specification](https://help.semmle.com/QL/QLDocSpecification.html).
1. Use `/** ... */` for documentation, even for single line comments.
1. For single-line documentation, the `/**` and `*/` are written on the same line as the comment.
1. For multi-line documentation, the `/**` and `*/` are written on separate lines. There is a `*` preceding each comment line, aligned on the first `*`.
1. Use full sentences, with capital letters and full stops.
1. Use American English.
1. Documentation comments *should* be appropriate for users of the code.
1. Documentation for maintainers of the code *must* use normal comments.

Documentation for specific items:

1. Public declarations *must* be documented.
1. Non-public declarations *should* be documented.
1. Declarations in query files *should* be documented.
1. Library files (`.qll` files) *should* be have a documentation comment at the top of the file.
1. Query files, except for tests, *must* have a QLDoc query documentation comment at the top of the file.
1. Predicates that do not have a result *should* be documented `/** Holds if ... */`
1. Predicates that have a result *should* be documented `/** Gets ... */`
1. All predicate parameters *should* be referred to in the predicate documentation.
1. Reference names, such as types and parameters, using backticks `` ` ``.
1. Give examples of code in the target language, enclosed in ```` ``` ````  or `` ` ``.
1. Classes *should* be documented in the singular, for example `/* An expression. */`
1. Where a class denotes a generic concept with subclasses, list those subclasses.
1. Declarations that are deprecated *should* be documented as `DEPRECATED: ...`
1. Declarations that are for internal use *should* be documented as `INTERNAL: Do not use`.

### Examples

```ql
/** Provides logic for determining constant expressions. */
```

```ql
/**
 * Holds if the qualifier of this call has type `qualifierType`.
 * `isExactType` indicates whether the type is exact, that is, whether
 * the qualifier is guaranteed not to be a subtype of `qualifierType`.
 */
```
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

```ql
/** DEPRECATED: Use `getAnExpr()` instead. */
deprecated Expr getInitializer()
```

```ql
/**
 * INTERNAL: Do not use.
 */
```

## Formulas
1. *Prefer* one *conjunct* per line.
1. Write the `and` at the end of the line. This also applies in `where` clauses.
1. *Prefer* to write the `or` keyword on its own line.
1. The `or` keyword *may* be written at the end of a line, or within a line, provided that it has no `and` operands.
1. Single-line formulas *may* be used in order to save space or add clarity, particularly in the *body* of a *quantifier/aggregation*.
1. *Always* use brackets to clarify the precedence of:
   - `implies`
   - `if`-`then`-`else`
1. *Avoid* using brackets to clarify the precedence of:
   - `not`
   - `and`
   - `or`
1. Parenthesised formulas *can* be written:
   - Within a single line. There *should not* be an additional space following the opening parenthesis or preceding the closing parenthesis.
   - Spanning multiple lines. The opening parenthesis *should* be placed at the end of the preceding line, the body should be indented one level, and the closing bracket should be placed on a new line at the outer indentation.
1. *Quantifiers/aggregations* *can* be written:
   - Within a single line. In this case, there is no space to the inside of the parentheses, or after the quantifier keyword.
   - Across multiple lines. In this case, type declarations are on the same line as the quantifier with the first `|` at the same line as the quantifier, the second `|` *must* be at the end of the same line as the quantifier or on its own line at the outer indentation, and the body of the quantifier *must* be indented one level. The closing `)` is written on a new line, at the outer indentation. If the type declarations need to be broken across multiple lines then there must *must* be a line break after the opening `(`, the type declarations indented one level, and the first `|` on its own line at the outer indentation.
1. `if`-`then`-`else` *can* be written:
   - On a single line
   - With the *body* after the `if`/`then`/`else` keyword
   - With the *body* indented on the next line
   - *Always* parenthesise the `else` part if it is a compound formula.
1. If an `if`-`then`-`else` is broken across multiple lines then the `then` and `else` keywords *should* be at the start of lines aligned with the `if`.
1. The `and` and `else` keywords *may* be placed on the same line as the closing parenthesis.
1. The `and` and `else` keywords *may* be "cuddled": `) else (`
1. *Always* qualify *calls* to predicates of the same class with `this`.
2. *Prefer* postfix casts `a.(Expr)` to prefix casts `(Expr)a`.

### Examples

```ql
  argumentType.isImplicitlyConvertibleTo(parameterType)
  or
  argumentType instanceof NullType and
  result.getParameter(i).isOut() and
  parameterType instanceof SimpleType
  or
  reflectionOrDynamicArg(argumentType, parameterType)
```

```ql
  this.getName() = "Finalize" and not exists(this.getAParameter())
```

```ql
  e1.getType() instanceof BoolType and (
    b1 = true
    or
    b1 = false
  ) and (
    b2 = true
    or
    b2 = false
  )
```

```ql
  if e1 instanceof BitwiseOrExpr or e1 instanceof LogicalOrExpr
  then (
    impliesSub(e1.(BinaryOperation).getAnOperand(), e2, b1, b2) and
    b1 = false
  ) else (
    e1.getType() instanceof BoolType and
    e1 = e2 and
    b1 = b2 and
    (b1 = true or b1 = false)
  )
```

```ql
  (x instanceof Exception implies x.isPublic()) and y instanceof Exception
```

```ql
  x instanceof Exception implies (x.isPublic() and y instanceof Exception)
```

```ql
  exists(Type arg | arg = this.getAChild() | arg instanceof TypeParameter)
```

```ql
  exists(Type qualifierType |
    this.hasNonExactQualifierType(qualifierType)
  |
    result = getANonExactQualifierSubType(qualifierType)
  )
```

```ql
  methods = count(Method m | t = m.getDeclaringType() and not ilc(m))
```

```ql
  if n = 0 then result = 1 else result = n * f(n - 1)
```

```ql
  if n = 0
  then result = 1
  else result = n * f(n - 1)
```

```ql
  if
    n = 0
  then
    result = 1
  else
    result = n * f(n - 1)
```

```ql
  if exists(this.getContainingType())
  then (
    result = "A nested class" and
    parentName = this.getContainingType().getFullyQualifiedName()
  ) else (
    result = parentName + "." + this.getName() and
    parentName = this.getNamespace().getFullyQualifiedName()
  )
```

## Glossary

| Phrase      | Meaning  |
|-------------|----------|
| *[annotation](https://help.semmle.com/QL/QLLanguageSpecification.html#annotations)* | An additional specifier used to modify a declaration, such as `private`, `override`, `deprecated`, `pragma`, `bindingset`, or `cached`. |
| *body* | The text inside `{ }`, `( )`, or each section of an `if`-`then`-`else` or `from`-`where`-`select`. |
| *binary operator* | An operator with two operands, such as comparison operators, `and`, `or`, `implies`, or arithmetic operators. |
| *call* | A *formula* that invokes a predicate, e.g. `this.isStatic()` or `calls(a,b)`. |
| *[conjunct](https://help.semmle.com/QL/QLLanguageSpecification.html#conjunctions)* | A formula that is an operand to an `and`. |
| *declaration* | A class, module, predicate, field or newtype. |
| *[disjunct](https://help.semmle.com/QL/QLLanguageSpecification.html#disjunctions)* | A formula that is an operand to an `or`. |
| *[formula](https://help.semmle.com/QL/QLLanguageSpecification.html#formulas)* | A logical expression, such as `A = B`, a *call*, a *quantifier*, `and`, `or`, `not`, `in` or `instanceof`. |
| *should/should not/avoid/prefer* | Adhere to this rule wherever possible, where it makes sense. |
| *may/can* | This is a reasonable alternative, to be used with discretion. |
| *must/always/do not* | Always adhere to this rule. |
| *[quantifier/aggregation](https://help.semmle.com/QL/QLLanguageSpecification.html#aggregations)* | `exists`, `count`, `strictcount`, `any`, `forall`, `forex` and so on. |
| *variable* | A parameter to a predicate, a field, a from variable, or a variable introduced by a *quantifier* or *aggregation*. |
