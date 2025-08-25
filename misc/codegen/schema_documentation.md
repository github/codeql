# Documenting `schema.py` entities

## Classes

Classes can be documented with plain python docstrings, for example

```
class ErrorElement(Locatable):
    '''The superclass of all elements indicating some kind of error.'''
    pass
```

This gets copied verbatim as QL doc comments for the class (with some internal handling for preservation of indentation,
as explained in https://peps.python.org/pep-0257/#handling-docstring-indentation).

## Properties

Properties by default get a generated doc comment created from the name of the property and the enclosing class. So for
example property `name` in class `File` will get documented as

```
/**
 * Gets the name of this file.
 */
```

This documentation generation will expand common abbreviations. The list of expanded abbreviations can be found
in [`codegen/generators/qlgen.py`](./codegen/generators/qlgen.py) as a dictionary under the `abbreviations` variable.

The `name of this file` part in the example above can be customized by appending `| doc("<replacement>")` to the
property specification, for example

```
class Locatable(Element):
    location: optional[Location] | doc("location associated with this element in the code")
```

When keeping the default documentation header, the name used for the class (for example `file` above) can be customized
at the class level by applying to the class the `@ql.default_doc_name("<replacement>")` decorator, for example

```
@ql.default_doc_name("function type")
class AnyFunctionType(Type):
  ...
```

Additionally, a description can be given which will be added after the documentation header
using `| desc("<description>")`. For example

```
class PoundDiagnosticDecl(Decl):
    kind: int | desc("This is 1 for `#error` and 2 for `#warning`.")
```

will result in

```
/**
 * Gets the kind of this pound diagnostic declaration.
 *
 * This is 1 for `#error` and 2 for `#warning`.
 */
```

### Plural/singular

Notice that for repeated properties both the plural and the singular forms will be present in documentation. What term
is taken to be pluralized/singularized depends on customization:

* for auto-generated documentation headers, the _last_ word of the property name will be taken;
* for headers overridden with `doc("<override>")`, the _first_ word of the override will be taken.

So for example:

```
generic_type_params: list[GenericTypeParamDecl]
   -> generic type parameter/generic type parameters of this generic context
arguments: list[Argument] | doc("arguments passed to the applied function")
   -> argument/arguments passed to the applied function
```

If this behaviour is not wanted, this can be overridden by enclosing the term to be pluralized/singularized in `{ }`
within `doc`. So for example

```
class Foo:
    names_of_the_things: list[string] | doc("{names} of the things in this foo")
    silly_cats_or_dogs: list[Animal] | doc("silly {cats} or {dogs} in this foo")
```

## Predicates

Similarly as properties, predicates get by default an automatically generated doc comment from the class name and the
predicate name. For example

```
class ImportDecl(Decl):
    is_exported: predicate
```

will generate the doc

```
/**
 * Holds if this import declaration is exported.
 */
```

And similarly to properties, one can:

* customize everything that comes strictly after `if` with `| doc("<replacement>")`;
* customize the default name for used for the class (`import declaration` in the example above) with
  the `@ql.default_doc_name("<replacement>")` class decorator;
* add a more in-depth description with `| desc("<description>")`.
