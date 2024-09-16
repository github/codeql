.. _codeql-cli-2.15.3:

==========================
CodeQL 2.15.3 (2023-11-22)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.15.3 runs a total of 401 security queries when configured with the Default suite (covering 158 CWE). The Extended suite enables an additional 128 queries (covering 33 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed an internal error in the compiler when arguments to the :code:`codePointCount` string primitive were not bound.
*   Fixed a bug where :code:`codeql database finalize` would fail if a database under construction was moved between machines between :code:`codeql database init` and :code:`codeql database finalize`.
    This should now work, as long as both commands are run by the same *release* of the CodeQL CLI and the extractors used are the ones bundled with the CLI.
*   Fixed a bug where :code:`codeql database run-queries` would fail in some circumstances when the database path included an :code:`@`.

New Features
~~~~~~~~~~~~

*   :code:`codeql database analyze` now defaults to include markdown query help for all custom queries with help files available. To change the default behaviour you can pass the new flag :code:`--sarif-include-query-help`, which provides the options :code:`always` (which includes query help for all queries), :code:`custom_queries_only` (the default) and :code:`never` (which does not include query help for any query). The existing flag
    :code:`--sarif-add-query-help` has been deprecated and will be removed in a future release.
*   The new (advanced) command-line option :code:`--[no-]linkage-aware-import` disables the linkage-awareness phase of :code:`codeql dataset import`, as a quick fix (at the expense of database completeness) for C++ projects where this part of database creation consumes too much memory. This option is available in the commands :code:`database create`,
    :code:`database finalize`, :code:`database import`, :code:`dataset import`, :code:`test extract`, and
    :code:`test run`.
*   The CodeQL language server now provides basic support for Rename, and you can now use the Rename Symbol functionality in Visual Studio Code for CodeQL. The current Rename support is less a refactoring tool and more a labor-saving device. You may have to perform some manual edits after using Rename, but it should still be faster and less work than renaming a symbol manually.

Improvements
~~~~~~~~~~~~

*   The Find References feature in the CodeQL language server now supports all CodeQL identifiers and offers improved performance compared to CodeQL CLI 2.14 releases.
*   The compiler generates shorter human-readable DIL and RA relation names. Due to use of an extended character set, full VS Code support for short relation names requires VS Code extension 1.9.4 or newer.
*   :code:`codeql database create` and :code:`codeql database finalize` now log more diagnostic information during database finalization, including the size of each relation, their total size, and the rate at which they were written to disk.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/uninitialized-local` query has been improved to produce fewer false positives.

C#
""

*   CIL extraction is now disabled by default. It is still possible to turn on CIL extraction by setting the :code:`cil` extractor option to :code:`true` or by setting the environment variable :code:`$CODEQL_EXTRACTOR_CSHARP_OPTION_CIL` to :code:`true`. This is the first step towards sun-setting the CIL extractor entirely.

Java/Kotlin
"""""""""""

*   The query :code:`java/unsafe-deserialization` has been improved to detect insecure calls to :code:`ObjectMessage.getObject` in JMS.

Python
""""""

*   Added modeling of more :code:`FileSystemAccess` in packages :code:`cherrypy`, :code:`aiofile`, :code:`aiofiles`, :code:`anyio`, :code:`sanic`, :code:`starlette`, :code:`baize`, and :code:`io`. This will mainly affect the *Uncontrolled data used in path expression* (:code:`py/path-injection`) query.

Swift
"""""

*   Added additional sinks for the "Uncontrolled data used in path expression" (:code:`swift/path-injection`) query. Some of these sinks are heuristic (imprecise) in nature.
*   Fixed an issue where some Realm database sinks were not being recognized for the :code:`swift/cleartext-storage-database` query.

New Queries
~~~~~~~~~~~

Swift
"""""

*   Added new query "System command built from user-controlled sources" (:code:`swift/command-line-injection`) for Swift. This query detects system commands built from user-controlled sources without sufficient validation. The query was previously `contributed to the 'experimental' directory by @maikypedia <https://github.com/github/codeql/pull/13726>`__ but will now run by default for all code scanning users.
*   Added a new query "Missing regular expression anchor" (:code:`swift/missing-regexp-anchor`) for Swift. This query detects regular expressions without anchors that can be vulnerable to bypassing.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Lower the security severity of log-injection to medium.
*   Increase the security severity of XSS to high.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   A bug has been fixed that meant that value flow through an array was not tracked correctly in some circumstances. Taint flow was tracked correctly.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The expressions :code:`AssignPointerAddExpr` and :code:`AssignPointerSubExpr` are no longer subtypes of :code:`AssignBitwiseOperation`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Swift
"""""

*   Added Swift 5.9.1 support
*   New AST node is extracted: :code:`SingleValueStmtExpr`

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Returning stack-allocated memory" (:code:`cpp/return-stack-allocated-memory`) query now also detects returning stack-allocated memory allocated by calls to :code:`alloca`, :code:`strdupa`, and :code:`strndupa`.
*   Added models for :code:`strlcpy` and :code:`strlcat`.
*   Added models for the :code:`sprintf` variants from the :code:`StrSafe.h` header.
*   Added SQL API models for :code:`ODBC`.
*   Added taint models for :code:`realloc` and related functions.

C#
""

*   The predicate :code:`UnboundGeneric::getName` now prints the number of type parameters as a ```N`` suffix, instead of a :code:`<,...,>` suffix. For example, the unbound generic type
    :code:`System.Collections.Generic.IList<T>` is printed as ``IList`1`` instead of :code:`IList<>`.
    
*   The predicates :code:`hasQualifiedName`, :code:`getQualifiedName`, and :code:`getQualifiedNameWithTypes` have been deprecated, and are instead replaced by :code:`hasFullyQualifiedName`, :code:`getFullyQualifiedName`, and :code:`getFullyQualifiedNameWithTypes`, respectively. The new predicates use the same format for unbound generic types as mentioned above.
    
*   These changes also affect models-as-data rows that refer to a field or a property belonging to a generic type. For example, instead of writing

    ..  code-block:: yaml
    
        extensions:
          - addsTo:
              pack: codeql/csharp-all
              extensible: summaryModel
              data:
                - ["System.Collections.Generic", "Dictionary<TKey,TValue>", False, "Add", "(System.Collections.Generic.KeyValuePair<TKey,TValue>)", "", "Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key]", "Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key]", "value", "manual"]

    one now writes

    ..  code-block:: yaml
    
        extensions:
          - addsTo:
              pack: codeql/csharp-all
              extensible: summaryModel
              data:
                - ["System.Collections.Generic", "Dictionary<TKey,TValue>", False, "Add", "(System.Collections.Generic.KeyValuePair<TKey,TValue>)", "", "Argument[0].Property[System.Collections.Generic.KeyValuePair`2.Key]", "Argument[this].Element.Property[System.Collections.Generic.KeyValuePair`2.Key]", "value", "manual"]

*   The models-as-data format for types and methods with type parameters has been changed to include the names of the type parameters. For example, instead of writing

    ..  code-block:: yaml
    
        extensions:
          - addsTo:
              pack: codeql/csharp-all
              extensible: summaryModel
              data:
                - ["System.Collections.Generic", "IList<>", True, "Insert", "(System.Int32,T)", "", "Argument[1]", "Argument[this].Element", "value", "manual"]
                - ["System.Linq", "Enumerable", False, "Select<,>", "(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Int32,TResult>)", "", "Argument[0].Element", "Argument[1].Parameter[0]", "value", "manual"]

    one now writes

    ..  code-block:: yaml
    
        extensions:
          - addsTo:
              pack: codeql/csharp-all
              extensible: summaryModel
              data:
                - ["System.Collections.Generic", "IList<T>", True, "Insert", "(System.Int32,T)", "", "Argument[1]", "Argument[this].Element", "value", "manual"]
                - ["System.Linq", "Enumerable", False, "Select<TSource,TResult>", "(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Int32,TResult>)", "", "Argument[0].Element", "Argument[1].Parameter[0]", "value", "manual"]

Golang
""""""

*   Added the `gin-contrib/cors <https://github.com/gin-contrib/cors>`__ library to the experimental query "CORS misconfiguration" (:code:`go/cors-misconfiguration`).

Java/Kotlin
"""""""""""

*   The types :code:`java.util.SequencedCollection`, :code:`SequencedSet` and :code:`SequencedMap`, as well as the related :code:`Collections.unmodifiableSequenced*` methods are now modelled. This means alerts may be raised relating to data flow through these types and methods.

Python
""""""

*   Added basic flow for attributes defined on classes, when the attribute lookup is on a direct reference to that class (so not instance, cls parameter, or self parameter). Example: class definition :code:`class Foo: my_tuples = (dangerous, safe)` and usage :code:`SINK(Foo.my_tuples[0])`.

Swift
"""""

*   AST and types related to parameter packs are now extracted
*   Added taint flow models for the :code:`NSString.enumerate*` methods.
*   Generalized the data flow model for subscript writes (:code:`a[index] = b`) so that it applies to subscripts on all kinds of objects, not just arrays.
*   Fixed a bug where some flow sinks at field accesses were not being correctly identified.
*   Added indexed :code:`getVariable` to :code:`CaptureListExpr`, improving its AST printing and data flow.
*   Added flow models for :code:`String` methods involving closures such as :code:`String.withUTF8(_:)`.
*   AST and types related to move semantics (:code:`copy`, :code:`consume`, :code:`_borrow`) are now extracted

Deprecated APIs
~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   In :code:`SensitiveApi.qll`, :code:`javaApiCallablePasswordParam`, :code:`javaApiCallableUsernameParam`, :code:`javaApiCallableCryptoKeyParam`, and :code:`otherApiCallableCredentialParam` predicates have been deprecated. They have been replaced with a new class :code:`CredentialsSinkNode` and its child classes :code:`PasswordSink`, :code:`UsernameSink`, and :code:`CryptoKeySink`. The predicates have been changed to using the new classes, so there may be minor changes in results relying on these predicates.
