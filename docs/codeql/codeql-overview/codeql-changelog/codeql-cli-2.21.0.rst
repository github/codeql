.. _codeql-cli-2.21.0:

==========================
CodeQL 2.21.0 (2025-04-03)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.21.0 runs a total of 452 security queries when configured with the Default suite (covering 168 CWE). The Extended suite enables an additional 136 queries (covering 35 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Miscellaneous
~~~~~~~~~~~~~

*   On macOS the :code:`CODEQL_TRACER_RELOCATION_EXCLUDE` environment variable can now be used to exclude certain paths from the tracer relocation and tracing process. This environment variable accepts newline-separated regex patterns of binaries to be excluded.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Fixed a bug, first introduced in :code:`2.20.3`, that would prevent :code:`v-html` attributes in Vue files from being flagged by the :code:`js/xss` query. The original behaviour has been restored and the :code:`v-html` attribute is once again functioning as a sink for the :code:`js/xss` query.
*   Fixed a bug that would in rare cases cause some regexp-based checks to be seen as generic taint sanitisers, even though the underlying regexp is not restrictive enough. The regexps are now analysed more precisely,
    and unrestrictive regexp checks will no longer block taint flow.
*   Fixed a recently-introduced bug that caused :code:`js/server-side-unvalidated-url-redirection` to ignore valid hostname checks and report spurious alerts after such a check. The original behaviour has been restored.

Python
""""""

*   The :code:`py/unused-global-variable` now no longer flags variables that are only used in forward references (e.g. the :code:`Foo` in :code:`def bar(x: "Foo"): ...`).

GitHub Actions
""""""""""""""

*   Fixed typos in the query and alert titles for the queries
    :code:`actions/envpath-injection/critical`, :code:`actions/envpath-injection/medium`,
    :code:`actions/envvar-injection/critical`, and :code:`actions/envvar-injection/medium`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Updated the :code:`java/unreleased-lock` query so that it no longer report alerts in cases where a boolean variable is used to track lock state.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Fixed a bug in the models for Microsoft's Active Template Library (ATL).
*   The query "Use of basic integral type" (:code:`cpp/jpl-c/basic-int-types`) no longer produces alerts for the standard fixed width integer types (:code:`int8_t`, :code:`uint8_t`, etc.), and the :code:`_Bool` and :code:`bool` types.

C#
""

*   Improved dependency resolution in :code:`build-mode: none` extraction to handle failing :code:`dotnet restore` processes that managed to download a subset of the dependencies before the failure.
*   Increase query precision for :code:`cs/useless-gethashcode-call` by not flagging calls to :code:`GetHashCode` on :code:`uint`, :code:`long` and :code:`ulong`.
*   Increase query precision for :code:`cs/constant-condition` and allow the use of discards in switch/case statements and also take the condition (if any) into account.
*   The :code:`cs/local-not-disposed` query no longer flags un-disposed tasks as this is often not needed (explained `here <https://devblogs.microsoft.com/pfxteam/do-i-need-to-dispose-of-tasks/>`__).
*   Increase query precision for :code:`cs/useless-assignment-to-local` and :code:`cs/constant-condition` when *unknown* types are involved (mostly relevant for :code:`build-mode: none` databases).
*   Don't consider an if-statement to be *useless* in :code:`cs/useless-if-statement` if there is at least a comment.

Golang
""""""

*   False positives in "Log entries created from user input" (:code:`go/log-injection`) and "Clear-text logging of sensitive information" (:code:`go/clear-text-logging`) which involved the verb :code:`%T` in a format specifier have been fixed. As a result, some users may also see more alerts from the "Use of constant :code:`state` value in OAuth 2.0 URL" (:code:`go/constant-oauth2-state`) query.

Java/Kotlin
"""""""""""

*   Fixed a false positive in "Time-of-check time-of-use race condition" (:code:`java/toctou-race-condition`) where a field of a non-static class was not considered always-locked if it was accessed in a constructor.
*   Overrides of :code:`BroadcastReceiver::onReceive` with no statements in their body are no longer considered unverified by the :code:`java/improper-intent-verification` query. This will reduce false positives from :code:`onReceive` methods which do not perform any actions.

Python
""""""

*   The :code:`py/special-method-wrong-signature` has been modernized and rewritten to no longer rely on outdated APIs. Moreover, the query no longer flags cases where a default value is never used, as these alerts were rarely useful.

New Queries
~~~~~~~~~~~

C#
""

*   Added a new query, :code:`csharp/path-combine`, to recommend against the :code:`Path.Combine` method due to it silently discarding its earlier parameters if later parameters are rooted.

Java/Kotlin
"""""""""""

*   Added a new quality query, :code:`java/empty-method`, to detect empty methods.
*   The query :code:`java/spring-boot-exposed-actuators` has been promoted from experimental to the main query pack. Its results will now appear by default, and the query itself will be removed from the `CodeQL Community Packs <https://github.com/GitHubSecurityLab/CodeQL-Community-Packs>`__. This query was originally submitted as an experimental query `by @ggolawski <https://github.com/github/codeql/pull/2901>`__.

Swift
"""""

*   Added a new summary query counting the total number of extracted AST nodes.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Java/Kotlin
"""""""""""

*   In :code:`build-mode: none` where the project has a Gradle build system, database creation no longer attempts to download some non-existent jar files relating to non-jar Maven artifacts, such as BOMs. This was harmless, but saves some time and reduces spurious warnings.
*   Java extraction no longer freezes for a long time or times out when using libraries that feature expanding cyclic generic types. For example, this was known to occur when using some classes from the Blazebit Persistence library.
*   Java build-mode :code:`none` no longer fails when a required version of Gradle cannot be downloaded using the :code:`gradle wrapper` command, such as due to a firewall. It will now attempt to use the system version of Gradle if present, or otherwise proceed without detailed dependency information.
*   Java build-mode :code:`none` no longer fails when a required version of Maven cannot be downloaded, such as due to a firewall. It will now attempt to use the system version of Maven if present, or otherwise proceed without detailed dependency information.
*   Java build-mode :code:`none` now correctly uses Maven dependency information on Windows platforms.

Python
""""""

*   :code:`MatchLiteralPattern`\ s such as :code:`case None: ...` are now never pruned from the extracted source code. This fixes some situations where code was wrongly identified as unreachable.

GitHub Actions
""""""""""""""

*   The query :code:`actions/code-injection/medium` now produces alerts for injection vulnerabilities on :code:`pull_request` events.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for TypeScript 5.8.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The models for :code:`System.Uri` have been modified to better model the flow of tainted URIs.
*   Modeled parameter passing between Blazor parent and child components.

Golang
""""""

*   We no longer track taint into a :code:`sync.Map` via the key of a key-value pair, since we do not model any way in which keys can be read from a :code:`sync.Map`.
*   :code:`database` source models have been added for v1 and v2 of the :code:`github.com/couchbase/gocb` package.
*   Added :code:`database` source models for the :code:`github.com/Masterminds/squirrel` ORM package.

Java/Kotlin
"""""""""""

*   Java extraction is now able to download Maven 3.9.x if a Maven Enforcer Plugin configuration indicates it is necessary. Maven 3.8.x is still preferred if the enforcer-plugin configuration (if any) permits it.
*   Added a path injection sanitizer for calls to :code:`java.lang.String.matches`, :code:`java.lang.String.replace`, and :code:`java.lang.String.replaceAll` that make sure '/', '\', '..' are not in the path.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for additional :code:`fs-extra` methods as sinks in path-injection queries.
*   Added support for the newer version of :code:`Hapi` with the :code:`@hapi/hapi` import and :code:`server` function.
*   Improved modeling of the :code:`node:fs` module: :code:`await`\ -ed calls to :code:`read` and :code:`readFile` are now supported.
*   Added support for the :code:`@sap/hana-client`, :code:`@sap/hdbext` and :code:`hdb` packages.
*   Enhanced :code:`axios` support with new methods (:code:`postForm`, :code:`putForm`, :code:`patchForm`, :code:`getUri`, :code:`create`) and added support for :code:`interceptors.request` and :code:`interceptors.response`.
*   Improved support for :code:`got` package with :code:`Options`, :code:`paginate()` and :code:`extend()`
*   Added support for the :code:`ApolloServer` class from :code:`@apollo/server` and similar packages. In particular, the incoming data in a GraphQL resolver is now seen as a source of untrusted user input.
*   Improved support for :code:`superagent` to handle the case where the package is directly called as a function, or via the :code:`.del()` or :code:`.agent()` method.
*   Added support for the :code:`underscore.string` package.
*   Added additional flow step for :code:`unescape()` and :code:`escape()`.
*   Added support for the :code:`@tanstack/vue-query` package.
*   Added taint-steps for :code:`unescape()`.
*   Added support for the :code:`@tanstack/angular-query-experimental` package.
*   Improved support for the :code:`@angular/common/http` package, detecting outgoing HTTP requests in more cases.
*   Improved the modeling of the :code:`markdown-table` package to ensure it handles nested arrays properly.
*   Added support for the :code:`react-relay` library.

Python
""""""

*   Added the methods :code:`getMinArguments` and :code:`getMaxArguments` to the :code:`Function` class. These return the minimum and maximum positional arguments that the given function accepts.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added :code:`Node.asUncertainDefinition` and :code:`Node.asCertainDefinition` to the :code:`DataFlow::Node` class for querying whether a definition overwrites the entire destination buffer.

JavaScript/TypeScript
"""""""""""""""""""""

*   Extraction now supports regular expressions with the :code:`v` flag, using the new operators:

    *   Intersection :code:`&&`
    *   Subtraction :code:`--`
    *   :code:`\q` quoted string
    
