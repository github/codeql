# Improvements to Python analysis

## General improvements

### Extractor changes

The extractor now parses all Python code from a single unified grammar. This means that almost all Python code will be successfully parsed, even if mutually incompatible Python code is present in the same project. This also means that Python code for any version can be correctly parsed on a worker running any other supported version of Python. For example, Python 3.7 code is parsed correctly, even if the installed version of Python is only 3.5. This will reduce the number of syntax errors found in many projects.

### Regular expression analysis improvements

The Python `re` (regular expressions) module library has a couple of constants called `MULTILINE` and `VERBOSE` which determine the parsing of regular expressions. Python 3.6 changed the implementation of these constants, which resulted in false positive results for some queries. The relevant QL libraries have been updated to support both implementations which will remove false positive results from projects that use Python 3.6 and later versions.

### API improvements

The API has been improved to declutter the global namespace and improve discoverability and readability.
 * New predicates `ModuleObject::named(name)` and `ModuleObject.attr(name)` have been added, allowing more readable access to common objects. For example, `(any ModuleObject m | m.getName() = "sys").getAttribute("exit")` can be replaced with `ModuleObject::named("sys").attr("exit")`
 * The API for accessing builtin functions has been improved. Predicates of the form `theXXXFunction()`, such as `theLenFunction()`, have been deprecated in favor of `Object::builtin(name)`.
 * A configuration based API has been added for writing data flow and taint tracking queries. This is provided as a convenience for query authors who have written data flow or taint tracking queries for other languages, so they can use a similar format of query across multiple languages.

## New queries

 | **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Default version of SSL/TLS may be insecure (`py/insecure-default-protocol`) | security, external/cwe/cwe-327 | Finds instances where an insecure default protocol may be used. Results are shown on LGTM by default. |
| Incomplete regular expression for hostnames (`py/incomplete-hostname-regexp`) | security, external/cwe/cwe-020 | Finds instances where a hostname is incompletely sanitized because a regular expression contains an unescaped character. Results are shown on LGTM by default. |
| Incomplete URL substring sanitization (`py/incomplete-url-substring-sanitization`) | security, external/cwe/cwe-020 | Finds instances where a URL is incompletely sanitized due to insufficient checks. Results are shown on LGTM by default. |
| Insecure temporary file (`py/insecure-temporary-file`) | security, external/cwe/cwe-377 | Finds uses of the insecure and deprecated `tempfile.mktemp`, `os.tempnam`, and `os.tmpnam` functions. Results are shown on LGTM by default. |
| Overly permissive file permissions (`py/overly-permissive-file`) | security, external/cwe/cwe-732 | Finds instances where a file is created with overly permissive permissions. Results are not shown on LGTM by default. |
| Use of insecure SSL/TLS version (`py/insecure-protocol`) | security, external/cwe/cwe-327 | Finds instances where a known insecure protocol has been specified. Results are shown on LGTM by default. |

## Changes to existing queries

 | **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Comparison using is when operands support \_\_eq\_\_ (`py/comparison-using-is`) | Fewer false positive results | Results where one of the objects being compared is an enum member are no longer reported. |
| Modification of parameter with default (`py/modification-of-default-value`) | More true positive results | Instances where the mutable default value is mutated inside other functions are now also reported. |
| Mutation of descriptor in \_\_get\_\_ or \_\_set\_\_ method (`py/mutable-descriptor`) | Fewer false positive results | Results where the mutation does not occur when calling one of the  `__get__`, `__set__` or `__delete__` methods are no longer reported. |
| Redundant comparison (`py/redundant-comparison`) | Fewer false positive results | Results in chained comparisons are no longer reported. |
| Unused import (`py/unused-import`) | Fewer false positive results | Results where the imported module is used in a `doctest` string are no longer reported. |
| Unused import (`py/unused-import`) | Fewer false positive results | Results where the imported module is used in a type-hint comment are no longer reported. |


## Changes to QL libraries

 * Added support for the `dill` pickle library.
 * Added support for the `bottle` web framework.
 * Added support for the `CherryPy` web framework.
 * Added support for the `falcon` web API framework.
 * Added support for the `turbogears` web framework.

 
