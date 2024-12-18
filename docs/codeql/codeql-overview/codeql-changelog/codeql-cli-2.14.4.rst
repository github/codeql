.. _codeql-cli-2.14.4:

==========================
CodeQL 2.14.4 (2023-09-12)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.14.4 runs a total of 394 security queries when configured with the Default suite (covering 155 CWE). The Extended suite enables an additional 129 queries (covering 35 more CWE). 3 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   The CodeQL CLI no longer supports the :code:`SEMMLE_JAVA_ARGS` environment variable.
    All previous versions of the CodeQL CLI perform command substitution on the
    :code:`SEMMLE_JAVA_ARGS` value (for example, replacing :code:`'$(echo foo)'` with :code:`'foo'`)
    when starting a new Java virtual machine, which, depending on the execution environment, may have security implications.  Users are advised to check their environments for possible :code:`SEMMLE_JAVA_ARGS` misuse.

Bug Fixes
~~~~~~~~~

*   :code:`codeql database init` (and :code:`github/codeql-action/init@v2` on GitHub Actions)
    should no longer hang or crash for traced languages on 64-bit Windows machines when certain antivirus software is installed.
*   During :code:`codeql pack create` and :code:`codeql pack publish`, a source version of a pack coming from :code:`--additional-packs` can explicitly be used to override a requested pack version even if this source version is incompatible with the requested version in the pack file. Previously, this would fail with a confusing error message.
*   Fixed a bug where :code:`codeql database interpret-results` hangs when a path query produces a result that has no paths from source to sink.

New Features
~~~~~~~~~~~~

*   The Java extractor now supports files that use Lombok.

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is bundled with the CodeQL CLI has been updated to version 17.0.8.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed an extractor crash that would occur in rare cases when a TypeScript file contains a self-referential namespace alias.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Comparison where assignment was intended" query (:code:`cpp/compare-where-assign-meant`) no longer reports comparisons that appear in macro expansions.
*   Some queries that had repeated results corresponding to different levels of indirection for :code:`argv` now only have a single result.
*   The :code:`cpp/non-constant-format` query no longer considers an assignment on the right-hand side of another assignment to be a source of non-constant format strings. As a result, the query may now produce fewer results.

Java/Kotlin
"""""""""""

*   The queries "Resolving XML external entity in user-controlled data" (:code:`java/xxe`) and "Resolving XML external entity in user-controlled data from local source" (:code:`java/xxe-local`) now recognize sinks in the MDHT library.

JavaScript/TypeScript
"""""""""""""""""""""

*   Files larger than 10 MB are no longer be extracted or analyzed.
*   Imports can now be resolved in more cases, where a non-constant string expression is passed to a :code:`require()` call.

Python
""""""

*   Improved *Reflected server-side cross-site scripting* (:code:`py/reflective-xss`) query to not alert on data passed to :code:`flask.jsonify`. Since these HTTP responses are returned with mime-type :code:`application/json`, they do not pose a security risk for XSS.
*   Updated path explanations for :code:`@kind path-problem` queries to always include left hand side of assignments, making paths easier to understand.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   Added a new query, :code:`cpp/invalid-pointer-deref`, to detect out-of-bounds pointer reads and writes.

Java/Kotlin
"""""""""""

*   Added the :code:`java/trust-boundary-violation` query to detect trust boundary violations between HTTP requests and the HTTP session. Also added the :code:`trust-boundary-violation` sink kind for sinks which may cross a trust boundary, such as calls to the :code:`HttpSession#setAttribute` method.

Ruby
""""

*   Added a new experimental query, :code:`rb/improper-ldap-auth`, to detect cases where user input is used during LDAP authentication without proper validation or sanitization, potentially leading to authentication bypass.

Swift
"""""

*   Added new query "Incomplete regular expression for hostnames" (:code:`swift/incomplete-hostname-regexp`). This query finds regular expressions matching a URL or hostname that may match more hostnames than expected.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 5.2.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   :code:`delete` and :code:`delete[]` are now modeled as calls to the relevant :code:`operator delete` in the IR. In the case of a dynamic delete call a new instruction :code:`VirtualDeleteFunctionAddress` is used to represent a function that dispatches to the correct delete implementation.
*   Only the 2 level indirection of :code:`argv` (corresponding to :code:`**argv`) is consided for :code:`FlowSource`.

C#
""

*   The :code:`--nostdlib` extractor option for the standalone extractor has been removed.

Golang
""""""

*   Added `http.Error <https://pkg.go.dev/net/http#Error>`__ to XSS sanitzers.

Java/Kotlin
"""""""""""

*   Fixed the MaD signature specifications to use proper nested type names.
*   Added new sanitizer to Java command injection model
*   Added more dataflow models for JAX-RS.
*   The predicate :code:`JaxWsEndpoint::getARemoteMethod` no longer requires the result to be annotated with :code:`@WebMethod`. Instead, the requirements listed in the JAX-RPC Specification 1.1 for required parameter and return types are used. Applications using JAX-RS may see an increase in results.

Python
""""""

*   Regular expressions containing multiple parse mode flags are now interpretted correctly. For example :code:`"(?is)abc.*"` with both the :code:`i` and :code:`s` flags.
*   Added :code:`shlex.quote` as a sanitizer for the :code:`py/shell-command-constructed-from-input` query.

Swift
"""""

*   Flow through optional chaining and forced unwrapping in keypaths is now supported by the data flow library.
*   Added flow models of collection :code:`.withContiguous[Mutable]StorageIfAvailable`, :code:`.withUnsafe[Mutable]BufferPointer` and :code:`.withUnsafe[Mutable]Bytes` methods.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   :code:`getAllocatorCall` on :code:`DeleteExpr` and :code:`DeleteArrayExpr` has been deprecated. :code:`getDeallocatorCall` should be used instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added :code:`DeleteOrDeleteArrayExpr` as a super type of :code:`DeleteExpr` and :code:`DeleteArrayExpr`

Java/Kotlin
"""""""""""

*   Kotlin versions up to 1.9.10 are now supported.

Shared Libraries
----------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The shared taint-tracking library is now part of the dataflow qlpack.

New Features
~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The various inline flow test libraries have been consolidated as a shared library part in the dataflow qlpack.
