.. _codeql-cli-2.14.2:

==========================
CodeQL 2.14.2 (2023-08-11)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.14.2 runs a total of 393 security queries when configured with the Default suite (covering 155 CWE). The Extended suite enables an additional 127 queries (covering 33 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The functionality provided by the :code:`codeql execute query-server` subcommand has been removed. The subcommand now responds to all JSON RPC requests with an error response. Correspondingly, this release is no longer compatible with versions of the CodeQL extension for Visual Studio Code prior to 1.7.6.
    
    This change also breaks third-party CodeQL IDE integrations that still rely on the :code:`codeql execute query-server` subcommand. Maintainers of such CodeQL IDE integrations should migrate to the :code:`codeql execute query-server2` subcommand at the earliest opportunity.

Bug Fixes
~~~~~~~~~

*   Fixed bug that made the :code:`--warnings=hide` option do nothing in
    :code:`codeql database analyze` and other commands that *evaluate* queries.

Improvements
~~~~~~~~~~~~

*   Switched from prefix filtering of autocomplete suggestions in the language server to client-side filtering. This improves autocomplete suggestions in contexts with an autocompletion prefix.
    
*   The CodeQL language server now checks query metadata for errors. This allows Visual Studio Code users to see errors in their query metadata without needing to compile the query.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The sanitizer in :code:`java/potentially-weak-cryptographic-algorithm` has been improved, so the query may yield additional results.

New Queries
~~~~~~~~~~~

Ruby
""""

*   Added a new experimental query, :code:`rb/ldap-injection`, to detect cases where user input is incorporated into LDAP queries without proper validation or sanitization, potentially leading to LDAP injection vulnerabilities.

Swift
"""""

*   Added new query "Command injection" (:code:`swift/command-line-injection`). The query finds places where user input is used to execute system commands without proper escaping.
*   Added new query "Bad HTML filtering regexp" (:code:`swift/bad-tag-filter`). This query finds regular expressions that match HTML tags in a way that is not robust and can easily lead to security issues.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`shouldPrintFunction` predicate from :code:`PrintAstConfiguration` has been replaced by :code:`shouldPrintDeclaration`. Users should now override :code:`shouldPrintDeclaration` if they want to limit the declarations that should be printed.
*   The :code:`shouldPrintFunction` predicate from :code:`PrintIRConfiguration` has been replaced by :code:`shouldPrintDeclaration`. Users should now override :code:`shouldPrintDeclaration` if they want to limit the declarations that should be printed.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`PrintAST` library now also prints global and namespace variables and their initializers.

Swift
"""""

*   Added :code:`DataFlow::ArrayContent`, which will provide more accurate flow through arrays.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`_Float128x` type is no longer exposed as a builtin type. As this type could not occur any code base, this should only affect queries that explicitly looked at the builtin types.

Golang
""""""

*   Logrus' :code:`WithContext` methods are no longer treated as if they output the values stored in that context to a log message.

Java/Kotlin
"""""""""""

*   Fixed a typo in the :code:`StdlibRandomSource` class in :code:`RandomDataSource.qll`, which caused the class to improperly model calls to the :code:`nextBytes` method. Queries relying on :code:`StdlibRandomSource` may see an increase in results.
*   Improved the precision of virtual dispatch of :code:`java.io.InputStream` methods. Now, calls to these methods will not dispatch to arbitrary implementations of :code:`InputStream` if there is a high-confidence alternative (like a models-as-data summary).
*   Added more dataflow steps for :code:`java.io.InputStream`\ s that wrap other :code:`java.io.InputStream`\ s.
*   Added models for the Struts 2 framework.
*   Improved the modeling of Struts 2 sources of untrusted data by tainting the whole object graph of the objects unmarshaled from an HTTP request.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added :code:`log-injection` as a customizable sink kind for log injection.

Swift
"""""

*   Flow through forced optional unwrapping (:code:`!`) is modelled more accurately.
*   Added flow models for :code:`Sequence.withContiguousStorageIfAvailable`.
*   Added taint flow for :code:`NSUserActivity.referrerURL`.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   A :code:`Diagnostic.getCompilationInfo()` predicate has been added.

Shared Libraries
----------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Control Flow Analysis
"""""""""""""""""""""

*   Initial release. Adds a shared library for control flow analyses.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   Initial release. Moves the shared inter-procedural data-flow library into its own qlpack.

New Features
~~~~~~~~~~~~

Dataflow Analysis
"""""""""""""""""

*   The :code:`StateConfigSig` signature now supports a unary :code:`isSink` predicate that does not specify the :code:`FlowState` for which the given node is a sink. Instead, any :code:`FlowState` is considered a valid :code:`FlowState` for such a sink.
