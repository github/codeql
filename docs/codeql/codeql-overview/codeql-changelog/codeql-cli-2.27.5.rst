.. _codeql-cli-2.27.5:

==========================
CodeQL 2.27.5 (2026-11-19)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.27.5 runs a total of 499 security queries when configured with the Default suite (covering 169 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   The C/C++ extractor no longer supports Brotli compression. Users invoking the extractor directly should replace :code:`--trap-compression=brotli` or :code:`--tar-entry-compression=brotli` with the corresponding :code:`zstd` option. The :code:`--brotli-quality` option has also been removed.

Bug Fixes
~~~~~~~~~

*   When choosing the default queries for a language whose extractor is found on :code:`--search-path`, the CLI now uses the extractor's :code:`default_queries` property instead of :code:`codeql/<language>-queries`.
*   :code:`codeql test run` now accepts :code:`.qlref` consistency queries passed via :code:`--consistency-queries` as it already does for ordinary unit tests, and applies the same :code:`.qlref` precedence: if a :code:`.ql` file has a synonymous :code:`.qlref` file, the :code:`.qlref` file is resolved and run instead, and the :code:`.ql` file is skipped.

Security Updates
~~~~~~~~~~~~~~~~

*   When invoked by :code:`codeql test run`, extractors for XML, YAML, and Java :code:`.properties` files run in a mode that traverses the source root directory and extracts all relevant files. This mode has been updated so that it no longer follows symbolic links.

QL Language
~~~~~~~~~~~

*   The :code:`string` type now has built-in member predicates :code:`startsWith(string prefix)`,
    :code:`endsWith(string suffix)`, and :code:`contains(string substring)`. These perform case-sensitive matching of literal strings, without wildcards or regular expressions. All three predicates hold for an empty argument.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/cleartext-transmission` and :code:`cpp/cleartext-storage-file` queries now track flow through character types. As a result, these queries may find additional results.
*   The :code:`cpp/unused-static-variable` query no longer reports compiler-generated variables, such as placeholders for empty function parameter packs.
*   The :code:`cpp/unused-local-variable` and :code:`cpp/unused-static-variable` queries no longer report variables whose initializers may have side effects.
*   The :code:`cpp/missing-check-scanf` query produces fewer false positives when an unaliased local output variable is overwritten with a default value if a :code:`scanf`\ -like call fails.

Golang
""""""

*   Added value flow models for functions in the :code:`maps` package which do not involve the :code:`iter` package.

Java/Kotlin
"""""""""""

*   The :code:`java/local-variable-is-never-read` query no longer reports unnamed variables (:code:`_`), for example in :code:`case Foo _ ->` patterns, :code:`for (var _ : items)` loops, and :code:`var _ = ...;` declarations.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/command-line-injection` query now reports remote input that reaches argument arrays when the :code:`shell` option is enabled. The :code:`js/shell-command-constructed-from-input` query also recognizes string-valued shell paths. Both queries now handle :code:`execFile` calls without a callback and check argument-array input at the execution call, avoiding alerts for later array mutations.
*   Valid arguments passed to the :code:`StorageEvent` constructor no longer produce alerts from :code:`js/superfluous-trailing-arguments`.

New Queries
~~~~~~~~~~~

Rust
""""

*   Added a new query, :code:`rust/unsafe-deserialization`, to detect deserialization of user-controlled data.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

Golang
""""""

*   The Go SSA API now uses the shared SSA classes (:code:`SsaDefinition`, :code:`SsaWriteDefinition`, :code:`SsaExplicitWrite`, :code:`SsaParameterInit`, :code:`SsaImplicitWrite`, :code:`SsaUncertainWrite`, and :code:`SsaPhiDefinition`):

    *   :code:`SsaVariable`, :code:`SsaExplicitDefinition`, :code:`SsaImplicitDefinition`, :code:`SsaVariableCapture`, :code:`SsaPseudoDefinition`, and :code:`SsaPhiNode` have been deprecated.
    *   :code:`ControlFlow::WriteNode.definesSsaVariable`, :code:`IR::WriteTarget.asSsaVariable`, :code:`SsaWithFields.getBaseVariable`, and :code:`DataFlow::ReadNode.readsSsaVariable` have been deprecated in favor of :code:`definesSsaDefinition`, :code:`asSsaDefinition`, :code:`getBaseDefinition`, and :code:`readsSsaDefinition`, respectively.
    *   :code:`SsaDefinition` no longer defines :code:`getVariable()`, :code:`getRoot()`, or :code:`hasLocationInfo(...)`. Use :code:`SsaDefinition` directly, :code:`getBasicBlock().getScope()`, and :code:`getLocation().hasLocationInfo(...)` instead.
    *   :code:`SsaDefinition.getAFirstUse()` is no longer available. First-use access remains available through :code:`getAFirstUse()` on the deprecated :code:`SsaVariable` class. :code:`DataFlow::ReadNode.readsSsaDefinition()` matches all reads, not just first uses, and is not an equivalent replacement.
    *   :code:`SsaDefinition.getARead()` returns expression reads only. Use :code:`DataFlow::ReadNode.readsSsaDefinition()` to include implicit reads, such as reads of result variables at function exit.
    *   :code:`IR::TypeSwitchImplicitVariableInstruction` now extends :code:`IR::WriteInstruction`, with target class :code:`IR::ImplicitVariableTarget`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Added support for data flow through property patterns in :code:`is` expressions and :code:`switch` cases.

Java/Kotlin
"""""""""""

*   Added taint flow model for :code:`reactor.core.publisher.Mono<T>`.
*   The :code:`java/weak-cryptographic-algorithm`, :code:`java/potentially-weak-cryptographic-algorithm`, and :code:`java/rsa-without-oaep` queries now match cryptographic algorithm names and modes case-insensitively (for example, :code:`AES/CBC/PKCS5PADDING` and :code:`AES/cbc/Pkcs5Padding`).
*   Java taint-tracking queries now recognize equality and case-insensitive equality checks against fixed string constants as sanitizers. The queries :code:`java/ssrf` and :code:`java/unvalidated-url-redirection` also recognize checks of :code:`URI.getHost()` against fixed collections of strings, including when the host is normalized to upper or lower case.

JavaScript/TypeScript
"""""""""""""""""""""

*   Checks of the form :code:`isNaN(parseInt(x))` and :code:`isNaN(parseFloat(x))` are no longer treated as checking that :code:`x` is a number, since :code:`parseInt` and :code:`parseFloat` only validate a numeric prefix of :code:`x`. This can reveal previously missed alerts, for example from :code:`js/shell-command-constructed-from-input` and :code:`js/unsafe-jquery-plugin`.
*   The command injection queries now properly recognize argument arrays passed to :code:`spawn` and :code:`execFile` as sinks when the :code:`shell` option is enabled.
*   The sensitive data heuristics treat names built on :code:`trusted_schema`, such as SQLite's :code:`set_trusted_schema` setting, as non-sensitive. This removes false positive results from queries that use the sensitive data library (for example :code:`js/clear-text-logging`).
*   Regular expression checks using multiline (:code:`m`) or unknown flags are no longer treated as generic taint sanitizers just because the pattern is anchored with :code:`^` and :code:`$`. This can reveal previously missed alerts, including command injection and reflected cross-site scripting.
*   Added modeling of the :code:`@modelcontextprotocol/sdk` and :code:`@modelcontextprotocol/server` (the official Model Context Protocol SDK) and :code:`fastmcp` npm packages. The arguments of MCP tool, resource and prompt callbacks and the requests that handlers of the low-level :code:`Server` receive are now sources of the opt-in :code:`ai` threat model, as their values are produced by a language model. The request headers and the bearer token that the SDK passes to a callback are sources of the :code:`remote` threat model.
*   Added flow summaries for schema parsing with the :code:`zod` npm package: data now flows from the argument of :code:`parse`, :code:`safeParse`, :code:`parseAsync` and :code:`safeParseAsync` to the parsed result.

Python
""""""

*   The :code:`py/tarslip` query now uses the correct argument positions and parameter names for :code:`TarFile.extract` and :code:`TarFile.extractall` sinks, reporting :code:`extract(member=...)` calls with untrusted members and no longer falsely reporting :code:`extractall(path, members)` calls when sanitized :code:`members` are passed positionally.
*   Await expressions are now treated as having side effects. This prevents false positives from the "Statement has no effect" query (:code:`py/ineffectual-statement`) when an awaited task or coroutine's result is discarded.
*   The sensitive data heuristics treat names built on :code:`trusted_schema`, such as SQLite's :code:`set_trusted_schema` setting, as non-sensitive. This removes false positive results from queries that use the sensitive data library (for example :code:`py/clear-text-logging-sensitive-data`).
*   Added modeling of the :code:`mcp` (the official Model Context Protocol SDK) and :code:`fastmcp` PyPI packages. The parameters of MCP tool, resource and prompt handlers are now sources of the opt-in :code:`ai` threat model, as their values are produced by a language model; the :code:`Context` parameter that the SDKs inject is not a source. The HTTP headers that :code:`fastmcp` handlers read through :code:`get_http_headers()` or :code:`get_http_request()`, and the bearer token that token verifiers (:code:`verify_token`) and :code:`get_access_token()` receive, are sources of the :code:`remote` threat model.
*   Type tracking now works for values stored in instance attributes and read from outside the class (for example :code:`instance.attr` where the value was assigned to :code:`self.attr` in a method), provided the instance at the read is reachable by local flow from a resolved constructor call. This excludes, for example, instances returned by a function and module-level instances read inside a function.

Ruby
""""

*   The sensitive data heuristics treat names built on :code:`trusted_schema`, such as SQLite's :code:`set_trusted_schema` setting, as non-sensitive. This removes false positive results from queries that use the sensitive data library (for example :code:`rb/clear-text-logging-sensitive-data`).

Swift
"""""

*   The sensitive data heuristics treat names built on :code:`trusted_schema`, such as SQLite's :code:`set_trusted_schema` setting, as non-sensitive. This removes false positive results from queries that use the sensitive data library (for example :code:`swift/cleartext-logging`).

Rust
""""

*   The Rust AST no longer exposes :code:`ParenExpr` and :code:`ParenPat` nodes. Parenthesized expressions and patterns are represented by their inner entities instead.
*   The :code:`rust/access-after-lifetime-ended` query now detects more accesses through pointers to struct fields created by :code:`std::ptr::addr_of!` and :code:`std::ptr::addr_of_mut!`.
*   The sensitive data heuristics treat names built on :code:`trusted_schema`, such as SQLite's :code:`set_trusted_schema` setting, as non-sensitive. This removes false positive results from queries that use the sensitive data library (for example :code:`rust/cleartext-logging`).
