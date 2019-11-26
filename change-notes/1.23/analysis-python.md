# Improvements to Python analysis


## General improvements

### Python 3.8 support

Python 3.8 syntax is now supported. In particular, the following constructs are parsed correctly:

- Assignment expressions using the "walrus" operator, such as `while chunk := file.read(1024): ...`.
- The positional argument separator `/`, such as in `def foo(a, /, b, *, c): ...`.
- Self-documenting expressions in f-strings, such as `f"{var=}"`.

### General query improvements

In an effort to deprecate the `Object` API (e.g. `ClassObject`) in favour of the
`Value` API (e.g. `ClassValue`), many of the standard queries have been updated
to use the `Value` API. This should result in more precise results.

## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
| Clear-text logging of sensitive information (`py/clear-text-logging-sensitive-data`) | security, external/cwe/cwe-312 | Finds instances where sensitive information is logged without encryption or hashing. Results are shown on LGTM by default. |
| Clear-text storage of sensitive information (`py/clear-text-storage-sensitive-data`) | security, external/cwe/cwe-312 | Finds instances where sensitive information is stored without encryption or hashing. Results are shown on LGTM by default. |
| Binding a socket to all network interfaces (`py/bind-socket-all-network-interfaces`) | security | Finds instances where a socket is bound to all network interfaces. Results are shown on LGTM by default. |


## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change** |
|----------------------------|------------------------|------------|
| Unreachable code | Fewer false positives | Analysis now accounts for uses of `contextlib.suppress` to suppress exceptions. |
| `__iter__` method returns a non-iterator | Better alert message | Alert now highlights which class is expected to be an iterator. |
| Explicit return in __init__ method | Fewer false positives | Instances where the `__init__` method returns the value of a call to a procedure are no longer flagged. |
| Non-iterable used in for loop | Fewer false positives | `__aiter__` is now recognized as an iterator method. |
| Unused import | Fewer false positives | Instances where a module is used in a forward-referenced type annotation, or only during type checking are no longer flagged. |
| Module-level cyclic import | Fewer false positives | Instances where one of the links in an import cycle is never actually executed are no longer flagged. |
| Undefined export | Fewer false positives | Instances where an exported value may be defined in a module that lacks points-to information are no longer flagged. |
| Unreachable code | Fewer false positives | Unreachable `else` branches that do nothing but `assert` their non-reachability are no longer flagged. |

## Changes to QL libraries

* Django library now recognizes positional arguments from a `django.conf.urls.url` regex (Django version 1.x)
* Instances of the `Value` class now support the `isAbsent` method, indicating
  whether the `Value` in question is missing points-to information, but has been
  inferred to likely exist anyway. For instance, if a file contains `import
  django`, but `django` was not extracted properly, there will be a
  `ModuleValue` corresponding to this "unknown" module, and the `isAbsent`
  method will hold for this `ModuleValue`.
* The `Expr` class now has a nullary method `pointsTo` that returns the possible
  instances of `Value` that this expression may have.
