# Improvements to Python analysis


## General improvements

> Changes that affect alerts in many files or from many queries
> For example, changes to file classification

### Representation of the control flow graph

The representation of the control flow graph (CFG) has been modified to better reflect the semantics of Python.

The following statement types no longer have a CFG node for the statement itself, as their sub-expressions already contain all the
semantically significant information:

* `ExprStmt`
* `If`
* `Assign`
* `Import`

For example, the CFG for `if cond: foo else bar` now starts with the CFG node for `cond`.

For the following statement types, the CFG node for the statement now follows the CFG nodes of its sub-expressions to better reflect the semantics:

* `Print`
* `TemplateWrite`
* `ImportStar`

For example the CFG for `print foo` (in Python 2) has changed from `print -> foo` to `foo -> print`, better reflecting the runtime behavior.


The CFG for the `with` statement has been re-ordered to more closely reflect the semantics.
For the `with` statement:
```python
with cm as var:
    body
```
The order of the CFG changes from:

    <with>
    cm
    var
    body

to:

    cm
    <with>
    var
    body

A new predicate `Stmt.getAnEntryNode()` has been added to make it easier to write reachability queries involving statements.


## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Information exposure through an exception (`py/stack-trace-exposure`) | security, external/cwe/cwe-209, external/cwe/cwe-497 | Finds instances where information about an exception may be leaked to an external user. Enabled on LGTM by default. |
| Request without certificate validation (`py/request-without-cert-validation`) | security, external/cwe/cwe-295 | Finds requests where certificate verification has been explicitly turned off, possibly allowing man-in-the-middle attacks. Not enabled on LGTM by default. |

## Changes to existing queries

All taint-tracking queries now support visualization of paths in QL for Eclipse.
Most security alerts are now visible on LGTM by default.

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Assert statement tests the truth value of a literal constant (`py/assert-literal-constant`) | reliability, correctness     | Checks whether an assert statement is testing the truth of a literal constant value. Not shown by default. |
| Code injection (`py/code-injection`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |
| Deserializing untrusted input (`py/unsafe-deserialization`) | Supports path visualization | No change to expected results |
| Encoding error (`py/encoding-error`) | Better alert location | Alert is now shown at the position of the first offending character, rather than at the top of the file. |
| Missing call to \_\_init\_\_ during object initialization (`py/missing-call-to-init`) | Fewer false positive results | Results where it is likely that the full call chain has not been analyzed are no longer reported. |
| Reflected server-side cross-site scripting (`py/reflective-xss`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |
| SQL query built from user-controlled sources (`py/sql-injection`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |
| Uncontrolled data used in path expression (`py/path-injection`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |
| Uncontrolled command line (`py/command-line-injection`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |
| URL redirection from remote source (`py/url-redirection`) | Fewer false positive results and now supports path visualization | Taint is no longer tracked from the right hand side of binary expressions. In other words `SAFE + TAINTED` is now treated as safe. |


## Changes to code extraction

* Improved scalability: Scaling is near linear to at least 20 CPU cores.
* Five levels of logging can be selected: `ERROR`, `WARN`, `INFO`, `DEBUG` and `TRACE`. `WARN` is the stand-alone default, but `INFO` will be used when run by LGTM.
* The `-v` flag can be specified multiple times to increase logging level by one per `-v`.
* The `-q` flag has been added and can be specified multiple times to reduce the logging level by one per `-q`.
* Log lines are now in the `[SEVERITY] message` style and never overlap.
* Extractor now outputs the location of the first offending character when an EncodingError is encountered.

## Changes to QL libraries

* Taint tracking analysis now understands HTTP requests in the `twisted` library.

* The analysis now handles `isinstance` and `issubclass` tests involving the basic abstract base classes better. For example, the test `issubclass(list, collections.Sequence)` is now understood to be `True`
* Taint tracking automatically tracks tainted mappings and collections, without you having to add additional taint kinds. This means that custom taints are tracked from `x` to `y` in the following flow: `l = [x]; y =l[0]`.
