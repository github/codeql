.. _codeql-cli-2.22.1:

==========================
CodeQL 2.22.1 (2025-06-26)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.22.1 runs a total of 449 security queries when configured with the Default suite (covering 165 CWE). The Extended suite enables an additional 129 queries (covering 33 more CWE).

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   Rust language support is now in public preview.

Miscellaneous
~~~~~~~~~~~~~

*   The version of :code:`jgit` used by the CodeQL CLI has been updated to :code:`6.10.1.202505221210-r`.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added flow model for the following libraries: :code:`madler/zlib`, :code:`google/brotli`, :code:`libidn/libidn2`, :code:`libssh2/libssh2/`, :code:`nghttp2/nghttp2`, :code:`libuv/libuv/`, and :code:`curl/curl`. This may result in more alerts when running queries on codebases that use these libraries.

C#
""

*   The queries :code:`cs/dereferenced-value-is-always-null` and :code:`cs/dereferenced-value-may-be-null` have been improved to reduce false positives. The queries no longer assume that expressions are dereferenced when passed as the receiver (:code:`this` parameter) to extension methods where that parameter is a nullable type.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/loop-iteration-skipped-due-to-shifting` query now has the :code:`reliability` tag.
*   Fixed false positives in the :code:`js/loop-iteration-skipped-due-to-shifting` query when the return value of :code:`splice` is used to decide whether to adjust the loop counter.
*   Fixed false positives in the :code:`js/template-syntax-in-string-literal` query where template syntax in string concatenation and "manual string interpolation" patterns were incorrectly flagged.
*   The :code:`js/useless-expression` query now correctly flags only the innermost expressions with no effect, avoiding duplicate alerts on compound expressions.

Python
""""""

*   The :code:`py/iter-returns-non-self` query has been modernized, and no longer alerts for certain cases where an equivalent iterator is returned.

New Queries
~~~~~~~~~~~

Rust
""""

*   Initial public preview release.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Query metadata tags have been systematically updated for many C# queries. Primary categorization as either :code:`reliability` or :code:`maintainability`, and relevant sub-category tags such as :code:`readability`, :code:`useless-code`, :code:`complexity`, :code:`performance`, :code:`correctness`, :code:`error-handling`, and :code:`concurrency`. Aligns with the established `Query file metadata and alert message style guide <https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#quality-query-sub-category-tags>`__.
*   Adjusts the :code:`@security-severity` from 9.3 to 7.3 for :code:`cs/uncontrolled-format-string` to align :code:`CWE-134` severity for memory safe languages to better reflect their impact.

Golang
""""""

*   The tag :code:`quality` has been added to multiple Go quality queries for consistency. They have all been given a tag for one of the two top-level categories :code:`reliability` or :code:`maintainability`, and a tag for a sub-category. See `Query file metadata and alert message style guide <https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#quality-query-sub-category-tags>`__ for more information about these categories.
*   The tag :code:`external/cwe/cwe-129` has been added to :code:`go/constant-length-comparison`.
*   The tag :code:`external/cwe/cwe-193` has been added to :code:`go/index-out-of-bounds`.
*   The tag :code:`external/cwe/cwe-197` has been added to :code:`go/shift-out-of-range`.
*   The tag :code:`external/cwe/cwe-248` has been added to :code:`go/redundant-recover`.
*   The tag :code:`external/cwe/cwe-252` has been added to :code:`go/missing-error-check` and :code:`go/unhandled-writable-file-close`.
*   The tag :code:`external/cwe/cwe-480` has been added to :code:`go/mistyped-exponentiation`.
*   The tag :code:`external/cwe/cwe-570` has been added to :code:`go/impossible-interface-nil-check` and :code:`go/comparison-of-identical-expressions`.
*   The tag :code:`external/cwe/cwe-571` has been added to :code:`go/negative-length-check` and :code:`go/comparison-of-identical-expressions`.
*   The tag :code:`external/cwe/cwe-783` has been added to :code:`go/whitespace-contradicts-precedence`.
*   The tag :code:`external/cwe/cwe-835` has been added to :code:`go/inconsistent-loop-direction`.
*   The tag :code:`error-handling` has been added to :code:`go/missing-error-check`, :code:`go/unhandled-writable-file-close`, and :code:`go/unexpected-nil-value`.
*   The tag :code:`useless-code` has been added to :code:`go/useless-assignment-to-field`, :code:`go/useless-assignment-to-local`, :code:`go/useless-expression`, and :code:`go/unreachable-statement`.
*   The tag :code:`logic` has been removed from :code:`go/index-out-of-bounds` and :code:`go/unexpected-nil-value`.
*   The tags :code:`call` and :code:`defer` have been removed from :code:`go/unhandled-writable-file-close`.
*   The tags :code:`correctness` and :code:`quality` have been reordered in :code:`go/missing-error-check` and :code:`go/unhandled-writable-file-close`.
*   The tag :code:`maintainability` has been changed to :code:`reliability` for :code:`go/unhandled-writable-file-close`.
*   The tag order has been standardized to have :code:`quality` first, followed by the top-level category (:code:`reliability` or :code:`maintainability`), then sub-category tags, and finally CWE tags.
*   The description text has been updated in :code:`go/whitespace-contradicts-precedence` to change "may even indicate" to "may indicate".

Java/Kotlin
"""""""""""

*   The tag :code:`quality` has been added to multiple Java quality queries for consistency. They have all been given a tag for one of the two top-level categories :code:`reliability` or :code:`maintainability`, and a tag for a sub-category. See `Query file metadata and alert message style guide <https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#quality-query-sub-category-tags>`__ for more information about these categories.
*   The tag :code:`external/cwe/cwe-571` has been added to :code:`java/equals-on-unrelated-types`.
*   The tag :code:`readability` has been added to :code:`java/missing-override-annotation`, :code:`java/deprecated-call`, :code:`java/inconsistent-javadoc-throws`, :code:`java/unknown-javadoc-parameter`, :code:`java/jdk-internal-api-access`, :code:`java/underscore-identifier`, :code:`java/misleading-indentation`, :code:`java/inefficient-empty-string-test`, :code:`java/non-static-nested-class`, :code:`inefficient-string-constructor`, and :code:`java/constants-only-interface`.
*   The tag :code:`useless-code` has been added to :code:`java/useless-type-test`, and :code:`java/useless-tostring-call`.
*   The tag :code:`complexity` has been added to :code:`java/chained-type-tests`, and :code:`java/abstract-to-concrete-cast`.
*   The tag :code:`error-handling` has been added to :code:`java/ignored-error-status-of-call`, and :code:`java/uncaught-number-format-exception`.
*   The tag :code:`correctness` has been added to :code:`java/evaluation-to-constant`, :code:`java/whitespace-contradicts-precedence`, :code:`java/empty-container`, :code:`java/string-buffer-char-init`, :code:`java/call-to-object-tostring`, :code:`java/print-array` and :code:`java/internal-representation-exposure`.
*   The tag :code:`performance` has been added to :code:`java/input-resource-leak`, :code:`java/database-resource-leak`, :code:`java/output-resource-leak`, :code:`java/inefficient-key-set-iterator`, :code:`java/inefficient-output-stream`, and :code:`java/inefficient-boxed-constructor`.
*   The tag :code:`correctness` has been removed from :code:`java/call-to-thread-run`, :code:`java/unsafe-double-checked-locking`, :code:`java/unsafe-double-checked-locking-init-order`, :code:`java/non-sync-override`, :code:`java/sync-on-boxed-types`, :code:`java/unsynchronized-getter`, :code:`java/input-resource-leak`, :code:`java/output-resource-leak`, :code:`java/database-resource-leak`, and :code:`java/ignored-error-status-of-call`.
*   The tags :code:`maintainability` has been removed from :code:`java/string-buffer-char-init`, :code:`java/inefficient-key-set-iterator`, :code:`java/inefficient-boxed-constructor`, and :code:`java/internal-representation-exposure`.
*   The tags :code:`reliability` has been removed from :code:`java/subtle-inherited-call`, :code:`java/print-array`, and :code:`java/call-to-object-tostring`.
*   The tags :code:`maintainability` and :code:`useless-code` have been removed from :code:`java/evaluation-to-constant`.
*   The tags :code:`maintainability` and :code:`readability` have been removed from :code:`java/whitespace-contradicts-precedence`.
*   The tags :code:`maintainability` and :code:`useless-code` have been removed from :code:`java/empty-container`.
*   Adjusts the :code:`@precision` from high to medium for :code:`java/concatenated-command-line` because it is producing false positive alerts when the concatenated strings are hard-coded.
*   Adjusts the :code:`@security-severity` from 9.3 to 7.3 for :code:`java/tainted-format-string` to align :code:`CWE-134` severity for memory safe languages to better reflect their impact.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`quality` tag has been added to multiple JavaScript quality queries, with tags for :code:`reliability` or :code:`maintainability` categories and their sub-categories. See `Query file metadata and alert message style guide <https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#quality-query-sub-category-tags>`__ for more information about these categories.
*   Added :code:`reliability` tag to the :code:`js/suspicious-method-name-declaration` query.
*   Added :code:`reliability` and :code:`language-features` tags to the :code:`js/template-syntax-in-string-literal` query.

Python
""""""

*   The tag :code:`quality` has been added to multiple Python quality queries for consistency. They have all been given a tag for one of the two top-level categories :code:`reliability` or :code:`maintainability`, and a tag for a sub-category. See `Query file metadata and alert message style guide <https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#quality-query-sub-category-tags>`__ for more information about these categories.

Ruby
""""

*   Update query metadata tags for :code:`rb/database-query-in-loop` and :code:`rb/useless-assignment-to-local` to align with the established
    \ `Query file metadata and alert message style guide <https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#quality-query-sub-category-tags>`__.

Swift
"""""

*   Adjusts the :code:`@security-severity` from 9.3 to 7.3 for :code:`swift/uncontrolled-format-string` to align :code:`CWE-134` severity for memory safe languages to better reflect their impact.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   :code:`resolveTypedefs` now properly resolves typedefs for :code:`ArrayType`\ s.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Java :code:`assert` statements are now assumed to be executed for the purpose of analysing control flow. This improves precision for a number of queries.

JavaScript/TypeScript
"""""""""""""""""""""

*   Calls to :code:`sinon.match()` are no longer incorrectly identified as regular expression operations.
*   Improved data flow tracking through middleware to handle default value and similar patterns.
*   Added :code:`req._parsedUrl` as a remote input source.
*   Improved taint tracking through calls to :code:`serialize-javascript`.
*   Removed :code:`encodeURI` and :code:`escape` functions from the sanitizer list for request forgery.
*   The JavaScript extractor now skips generated JavaScript files if the original TypeScript files are already present. It also skips any files in the output directory specified in the :code:`compilerOptions` part of the :code:`tsconfig.json` file.
*   Added support for Axios instances in the :code:`axios` module.

GitHub Actions
""""""""""""""

*   Fixed performance issues in the parsing of Bash scripts in workflow files,
    which led to out-of-disk errors when analysing certain workflow files with complex interpolations of shell commands or quoted strings.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`ThrowingFunction` class (:code:`semmle.code.cpp.models.interfaces.Throwing`) has been deprecated. Please use the :code:`AlwaysSehThrowingFunction` class instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a predicate :code:`getAnAttribute` to :code:`Namespace` to retrieve a namespace attribute.
*   The Microsoft-specific :code:`__leave` statement is now supported.
*   A new class :code:`LeaveStmt` extending :code:`JumpStmt` was added to represent :code:`__leave` statements.
*   Added a predicate :code:`hasParameterList` to :code:`LambdaExpression` to capture whether a lambda has an explicitly specified parameter list.

Rust
""""

*   Initial public preview release.
