.. _codeql-cli-2.27.0:

==========================
CodeQL 2.27.0 (2026-09-09)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.27.0 runs a total of 498 security queries when configured with the Default suite (covering 170 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Deprecations
~~~~~~~~~~~~

*   Language support for Java 9 and 10 has been deprecated and will be removed in January 2027. Java 7 and 8 will continue to be supported.
*   The generic multi-platform :code:`codeql.zip` CLI distribution is deprecated and will be removed in a future release. Download the per-platform
    :code:`codeql-PLATFORM.zip` for your platform instead. The CLI now emits a warning when it is run from an all-platforms distribution; set
    :code:`CODEQL_ALLOW_ALL_PLATFORMS_DIST=true` to suppress it.

New Features
~~~~~~~~~~~~

*   CodeQL now supports native Linux arm64 (:code:`linux-arm64`) as a first-class platform. The per-platform CLI (:code:`codeql-linux-arm64.zip`) and CodeQL bundle
    (:code:`codeql-bundle-linux-arm64.tar.gz` and :code:`codeql-bundle-linux-arm64.tar.zst`)
    are available as release assets. Arm64 binaries are provided as a per-platform download only, and are not included in the combined :code:`codeql.zip`,
    :code:`codeql-bundle.tar.gz`, or :code:`codeql-bundle.tar.zst`.
*   CodeQL can now take advantage of an organization's private registry configurations in Code Scanning Default Setup to authenticate to container registries or the GitHub API when trying to fetch custom queries or packs.
    This allows custom queries or packs to be accessed from private locations in Code Scanning Default Setup as long as suitable "Git Source" or "Docker Registry" private registry configurations are set up for the organization.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/leap-year/unsafe-array-for-days-of-the-year` query ("Unsafe array for days of the year") no longer reports an alert on the :code:`__PRETTY_FUNCTION__` variable (and related variables) when the enclosing function has a signature that is exactly 364 characters.

C#
""

*   The :code:`cs/linq/missed-where` query no longer flags :code:`foreach` loops where the matching branch terminates the method, iterator, or loop instead of continuing with filtered loop work.

JavaScript/TypeScript
"""""""""""""""""""""

*   HTML files are now included in file-coverage stats, and will start showing up on the status page for CodeQL under "Scanned Files".

Rust
""""

*   The :code:`rust/hard-coded-cryptographic-value` query has been adjusted to produce fewer results in certain situations where many results were being produced with very similar source locations.
*   The :code:`rust/unused-variable` query no longer reports variables in functions containing the standard :code:`todo!()` or :code:`unimplemented!()` macros.

New Queries
~~~~~~~~~~~

Rust
""""

*   Added a new query, :code:`rust/command-line-injection`, to detect uncontrolled command lines.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Python
""""""

*   Fixed a bug where a Python file could be silently dropped from the analysis (with a spurious "A parse error occurred" diagnostic) when it contained a string literal, comment, or identifier with a character such as the U+FE0F emoji variation selector, a U+200D zero width joiner, or a combining accent.
*   Fixed the extraction of PEP 758 :code:`except A, B:` clauses by the default (non-tree-sitter) Python parser. Previously the second exception type was extracted as a Python 2 style alias binding, so it was recorded as a :code:`Store` rather than a use. This caused false positives from queries that reason about whether a name is used, such as :code:`py/unused-import`. When extracting Python 2 (:code:`--lang=2`), :code:`except A, e:` continues to bind :code:`e` as an alias, since that is what the syntax means in that version.

Breaking Changes
~~~~~~~~~~~~~~~~

Ruby
""""

*   The Ruby control flow graph implementation has been completely replaced. This affects a number of queries slightly. The CFG now includes additional nodes to more accurately represent certain constructs. This also means that any existing code that implicitly relies on very specific details about the CFG may need to be updated. The CFG no longer uses splitting, which means that AST nodes now have a unique CFG node representation. In particular,
    :code:`ControlFlowNode.getAstNode` has changed its meaning. The AST-to-CFG mapping remains one-to-many, but now for a different reason. It used to be because of splitting, but now it's because of additional "helper" CFG nodes. To get the
    (now canonical) CFG node for a given AST node, use
    :code:`Stmt.getControlFlowNode()` instead.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added the PostgreSQL libpq (asynchronous) query-execution functions :code:`PQexec`, :code:`PQexecParams`, :code:`PQprepare`, :code:`PQsendQuery`, :code:`PQsendQueryParams`, :code:`PQsendPrepare` as :code:`sql-injection` sinks.
*   Initializers of compiler-generated variables are now recognized as compiler-generated. A new predicate :code:`isCompilerGenerated` on :code:`Initializer` has been added to reflect this.

C#
""

*   In :code:`build-mode: none`, project and solution restoration is now always attempted using the feeds available.
*   C# analysis with build mode :code:`none` now lists unreachable explicitly configured NuGet feeds in both the extraction warning and the tool status page note. This makes it easier to identify feeds that may cause dependencies to be missing from the analysis.
*   Improved ASP.NET Core MVC controller and action discovery to more closely match runtime behavior, including application parts, endpoint mappings, inherited actions, and controller and action exclusions. Service-injected action parameters are no longer modeled as remote input.

Java/Kotlin
"""""""""""

*   Added modeling for the Micronaut framework, including HTTP controllers, WebSocket endpoints, configuration injection, data access, security annotations, and HTTP client sinks.

GitHub Actions
""""""""""""""

*   Checks on author association fields read from the event payload (e.g. :code:`github.event.pull_request.author_association`) now only count as protection for events whose payload actually populates that field. Previously, a condition such as :code:`github.event.pull_request.author_association != 'NONE'` on a workflow triggered by :code:`issues` events was treated as a protective check even though :code:`github.event.pull_request` is not populated for :code:`issues` events, which makes the condition vacuous. This change may result in more alerts for queries using the :code:`ControlCheck` class.

Rust
""""

*   Canonical paths for Rust trait items now use the format :code:`<crate::Trait>::item` instead of
    :code:`crate::Trait::item`. Custom data extension models that reference trait items must be updated to use the new format.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Sources and sinks defined using models-as-data now support access paths with fields. For example, the path :code:`ReturnValue.Field[S::f]` makes the field :code:`S::f` a flow source when it is returned by a call.

C#
""

*   Added taint modeling for OData action parameter binding (:code:`Microsoft.AspNet.OData`\ /\ :code:`Microsoft.AspNetCore.OData`). Values cast, :code:`as`\ -converted, or type-tested out of :code:`ODataActionParameters`, and entities tracked by :code:`Delta<T>` (via :code:`GetInstance`, :code:`Patch`, :code:`Put`, :code:`CopyChangedValues`, and :code:`CopyUnchangedValues`), now taint the members of the target type.

Java/Kotlin
"""""""""""

*   Factories returned by the Apache Commons Secure XML (:code:`org.apache.commons.xml.secure`) hardening library's :code:`SecureDocumentBuilderFactory`, :code:`SecureSAXParserFactory`, :code:`SecureXMLInputFactory`, :code:`SecureTransformerFactory` and :code:`SecureSchemaFactory` classes are now recognized as safely configured by the XXE query.
*   A new extensible class :code:`SafeXmlFactorySource` was added to :code:`semmle.code.java.security.XmlParsers` for modeling sources of pre-hardened JAXP factories.

GitHub Actions
""""""""""""""

*   GitHub Actions databases now extract :code:`actions.lock` files. The new :code:`ActionsLock` class provides access to their YAML abstract syntax trees.
