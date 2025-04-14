.. _codeql-cli-2.9.3:

=========================
CodeQL 2.9.3 (2022-05-31)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.9.3 runs a total of 335 security queries when configured with the Default suite (covering 142 CWE). The Extended suite enables an additional 104 queries (covering 30 more CWE). 5 security queries have been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug where precompiled CodeQL packages in the CodeQL bundle were being recompiled if they were in a read-only directory.
    
*   Fixed a bug where new versions of the VS Code extension wouldn't run two queries in parallel against one database.

New Features
~~~~~~~~~~~~

*   Users can now use CodeQL Packaging Beta to publish and download CodeQL packs on GitHub Enterprise Server (GHES) versions 3.6 and later.
    
    To authenticate to a package registry on GHES 3.6+, first create a
    :code:`~/.codeql/qlconfig.yml` file. For example, the following file specifies that all CodeQL packages should be uploaded to the GHES instance with the hostname :code:`GHE_HOSTNAME`\ :

    ..  code-block:: yaml
    
        registries:
        - packages: '*'
          url: https://containers.GHE_HOSTNAME/v2/
        
    You can now download public packages from GHES using
    :code:`codeql pack download`.
    
    To publish any package or download private packages, authenticate to GHES by specifying registry/token pairs in the
    :code:`CODEQL_REGISTRIES_AUTH` environment variable. You can authenticate using either a GitHub Apps token or a personal access token. For example,
    :code:`https://containers.GHEHOSTNAME1/v2/=TOKEN1,https://containers.GHEHOSTNAME2/v2/=TOKEN2` will authenticate the CLI to the :code:`GHEHOSTNAME1` and :code:`GHEHOSTNAME2` GHES instances.

Query Packs
-----------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The query "Incorrect conversion between integer types" has been improved to treat :code:`math.MaxUint` and :code:`math.MaxInt` as the values they would be on a 32-bit architecture. This should lead to fewer false positive results.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "XML external entity expansion" (:code:`cpp/external-entity-expansion`) query precision has been increased to :code:`high`.
*   The :code:`cpp/unused-local-variable` no longer ignores functions that include :code:`if` and :code:`switch` statements with C++17-style initializers.

Golang
""""""

*   Fixed sanitization by calls to :code:`strings.Replace` and :code:`strings.ReplaceAll` in queries :code:`go/log-injection` and :code:`go/unsafe-quoting`.

Java/Kotlin
"""""""""""

*   Query :code:`java/sensitive-log` has received several improvements.

    *   It no longer considers usernames as sensitive information.
    *   The conditions to consider a variable a constant (and therefore exclude it as user-provided sensitive information) have been tightened.
    *   A sanitizer has been added to handle certain elements introduced by a Kotlin compiler plugin that have deceptive names.

New Queries
~~~~~~~~~~~

Golang
""""""

*   A new query "Log entries created from user input" (:code:`go/log-injection`) has been added. The query reports user-provided data reaching calls to logging methods.
*   A new query *Log entries created from user input* (:code:`go/log-injection`) has been added. The query reports user-provided data reaching calls to logging methods.
*   Added a new query, :code:`go/unexpected-nil-value`, to find calls to :code:`Wrap` from :code:`pkg/errors` where the error argument is always nil.

Java/Kotlin
"""""""""""

*   Two new queries "Inefficient regular expression" (:code:`java/redos`) and "Polynomial regular expression used on uncontrolled data" (:code:`java/polynomial-redos`) have been added.
    These queries help find instances of Regular Expression Denial of Service vulnerabilities.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/actions/command-injection` query has been added. It highlights GitHub Actions workflows that may allow an
    attacker to execute arbitrary code in the workflow.
    The query previously existed an experimental query.
*   A new query :code:`js/insecure-temporary-file` has been added. The query detects the creation of temporary files that may be accessible by others users. The query is not run by default.

Python
""""""

*   The query "PAM authorization bypass due to incorrect usage" (:code:`py/pam-auth-bypass`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally `submitted as an experimental query by @porcupineyhairs <https://github.com/github/codeql/pull/8595>`__.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Golang
""""""

*   :code:`Function`\ 's predicate :code:`getACall` now returns more results in some situations. It now always returns callers that may call a method indirectly via an interface method that it implements. Previously this only happened if the method was in the source code being analysed.

Breaking Changes
~~~~~~~~~~~~~~~~

Python
""""""

*   :code:`API::moduleImport` no longer has any results for dotted names, such as :code:`API::moduleImport("foo.bar")`. Using :code:`API::moduleImport("foo.bar").getMember("baz").getACall()` previously worked if the Python code was :code:`from foo.bar import baz; baz()`, but not if the code was :code:`import foo.bar; foo.bar.baz()` -- we are making this change to ensure the approach that can handle all cases is always used.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ruby
""""

*   Added data-flow support for `hashes <https://docs.ruby-lang.org/en/3.1/Hash.html>`__.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   Fixed a bug where dataflow steps were ignored if both ends were inside the initialiser routine of a file-level variable.
*   The method predicate :code:`getACalleeIncludingExternals` on :code:`DataFlow::CallNode` and the function :code:`viableCallable` in :code:`DataFlowDispatch` now also work for calls to functions via a variable, where the function can be determined using local flow.

Java/Kotlin
"""""""""""

*   Fixed a sanitizer of the query :code:`java/android/intent-redirection`. Now, for an intent to be considered safe against intent redirection, both its package name and class name must be checked.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`isLibaryFile` predicate from :code:`ClassifyFiles.qll` has been renamed to :code:`isLibraryFile` to fix a typo.

Ruby
""""

*   Support for data flow through instance variables has been added.
*   Support of the safe navigation operator (:code:`&.`) has been added; there is a new predicate :code:`MethodCall.isSafeNavigation()`.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`AnalysedString` class in the :code:`StringAnalysis` module has been replaced with :code:`AnalyzedString`, to follow our style guide. The old name still exists as a deprecated alias.

Golang
""""""

*   The :code:`codeql/go-upgrades` CodeQL pack has been removed. All database upgrade scripts have been merged into the :code:`codeql/go-all` CodeQL pack.

Java/Kotlin
"""""""""""

*   The QL class :code:`FloatingPointLiteral` has been renamed to :code:`FloatLiteral`.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   A :code:`getInitialization` predicate was added to the :code:`ConstexprIfStmt`, :code:`IfStmt`, and :code:`SwitchStmt` classes that yields the C++17-style initializer of the :code:`if` or :code:`switch` statement when it exists.

Golang
""""""

*   Go 1.18 generics are now extracted and can be explored using the new CodeQL classes :code:`TypeParamDecl`, :code:`GenericFunctionInstantiationExpr`, :code:`GenericTypeInstantiationExpr`, :code:`TypeSetTerm`, and :code:`TypeSetLiteralType`, as well as using new predicates defined on the existing :code:`InterfaceType`. Class- and predicate-level documentation can be found in the `Go CodeQL library reference <https://codeql.github.com/codeql-standard-libraries/go/>`__.
