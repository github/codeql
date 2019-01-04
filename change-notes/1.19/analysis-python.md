# Improvements to Python analysis

## General improvements

### Representation of the control flow graph

The representation of the control flow graph (CFG) has been modified to better reflect the semantics of Python. As part of these changes, a new predicate `Stmt.getAnEntryNode()` has been added to make it easier to write reachability queries involving statements.

#### CFG nodes removed

The following statement types no longer have a CFG node for the statement itself, as their sub-expressions already contain all the
semantically significant information:

* `ExprStmt`
* `If`
* `Assign`
* `Import`

For example, the CFG for `if cond: foo else bar` now starts with the CFG node for `cond`.

#### CFG nodes reordered

For the following statement types, the CFG node for the statement now follows the CFG nodes of its sub-expressions to follow Python semantics:

* `Print`
* `TemplateWrite`
* `ImportStar`

For example the CFG for `print foo` (in Python 2) has changed from `print -> foo` to `foo -> print`, to reflect the runtime behavior.

The CFG for the `with` statement has been re-ordered to more closely reflect the semantics.
For the `with` statement:
```python
with cm as var:
    body
```

* Previous CFG node order: `<with>` -> `cm` -> `var` -> `body`
* New CFG node order: `cm` -> `<with>` -> `var` -> `body`

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Assert statement tests the truth value of a literal constant (`py/assert-literal-constant`) | reliability, correctness     | Checks whether an assert statement is testing the truth of a literal constant value. Results are hidden on LGTM by default. |
| Flask app is run in debug mode (`py/flask-debug`) | security, external/cwe/cwe-215, external/cwe/cwe-489 | Finds instances where a Flask application is run in debug mode. Results are shown on LGTM by default. |
| Information exposure through an exception (`py/stack-trace-exposure`) | security, external/cwe/cwe-209, external/cwe/cwe-497 | Finds instances where information about an exception may be leaked to an external user. Results are shown on LGTM by default. |
| Jinja2 templating with autoescape=False (`py/jinja2/autoescape-false`) | security, external/cwe/cwe-079 | Finds instantiations of `jinja2.Environment` with `autoescape=False` which may allow XSS attacks. Results are hidden on LGTM by default. |
| Request without certificate validation (`py/request-without-cert-validation`) | security, external/cwe/cwe-295 | Finds requests where certificate verification has been explicitly turned off, possibly allowing man-in-the-middle attacks. Results are hidden on LGTM by default. |
| Use of weak cryptographic key (`py/weak-crypto-key`) | security, external/cwe/cwe-326 | Finds creation of weak cryptographic keys. Results are shown on LGTM by default. |

## Changes to existing queries

All taint-tracking queries now support visualization of paths in QL for Eclipse.
Most security alerts are now visible on LGTM by default. This means that you may see results that were previously hidden for the following queries: 

* Code injection (`py/code-injection`)
* Reflected server-side cross-site scripting (`py/reflective-xss`)
* SQL query built from user-controlled sources (`py/sql-injection`)
* Uncontrolled data used in path expression (`py/path-injection`)
* Uncontrolled command line (`py/command-line-injection`)

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Command injection (`py/command-line-injection`) | More results | Additional sinks in the `os`, and `popen` modules may find more results in some projects. |
| Encoding error (`py/encoding-error`) | Better alert location | Alerts are now shown at the start of the encoding error, rather than at the top of the file. |
| Missing call to \_\_init\_\_ during object initialization (`py/missing-call-to-init`) | Fewer false positive results | Results where it is likely that the full call chain has not been analyzed are no longer reported. |
| URL redirection from remote source (`py/url-redirection`) | Fewer false positive results | Taint is no longer tracked from the right-hand side of binary expressions. In other words `SAFE + TAINTED` is now treated as safe. |


## Changes to code extraction

## Improved reporting of encoding errors

The extractor now outputs the location of the first character that triggers an `EncodingError`. 
Any queries that report encoding errors will now show results at the location of the character that caused the error.

### Improved scalability

Scaling is near linear to at least 20 CPU cores.

### Improved logging

* Five levels of logging are available: `CRITICAL`, `ERROR`, `WARN`, `INFO` and `DEBUG`. `WARN` is the default.
* LGTM uses `INFO` level logging. QL tools use `WARN` level logging by default.
* The `--verbose` flag can be specified specified multiple times to increase the logging level once per flag added.
* The `--quiet` flag can be specified multiple times to reduce the logging level once per flag added.
* Log lines are now in the `[SEVERITY] message` style and never overlap.

## Changes to QL libraries

* Taint-tracking analysis now understands HTTP requests in the `twisted` library.
* The analysis now handles `isinstance` and `issubclass` tests involving the basic abstract base classes better. For example, the test `issubclass(list, collections.Sequence)` is now understood to be `True`
* Taint tracking automatically tracks tainted mappings and collections, without you having to add additional taint kinds. This means that custom taints are tracked from `x` to `y` in the following flow: `l = [x]; y =l[0]`.
