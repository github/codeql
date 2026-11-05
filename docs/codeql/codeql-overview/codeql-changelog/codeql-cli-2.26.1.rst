.. _codeql-cli-2.26.1:

==========================
CodeQL 2.26.1 (2026-07-15)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.26.1 runs a total of 497 security queries when configured with the Default suite (covering 170 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

There are no user-facing CLI changes in this release.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Rust
""""

*   The :code:`rust/hard-coded-cryptographic-value` query now treats arithmetic and bitwise operations, including string append operations, as barriers. This addresses false positive results where hard-coded constants are combined with non-constant data, such as incrementing a nonce or appending variable data to a constant prefix.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added the tags :code:`external/cwe/cwe-073` and :code:`external/cwe/cwe-078` to :code:`cpp/uncontrolled-process-operation`.

C#
""

*   Added the tag :code:`external/cwe/cwe-073` to :code:`cs/assembly-path-injection`.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   Removed support for using variables as sources and sinks in models-as-data. Users of this feature should convert such sources and sinks to models defined using the QL language.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Simplified and streamlined the use of NuGet sources when downloading dependencies via :code:`[mono] nuget.exe` in :code:`build-mode: none`\ : NuGet sources are now supplied via the :code:`-Source` flag instead of moving or creating :code:`nuget.config` files in the checked-out repository, private registries are used if configured, and only reachable feeds are used when NuGet feed checking is enabled (the default).

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   Improved models for the :code:`log/slog` package (Go 1.21+), including :code:`*slog.Logger` methods, :code:`With`\ /\ :code:`WithGroup`, and :code:`Attr`\ /\ :code:`Value` helpers, improving coverage for the :code:`go/log-injection` and :code:`go/clear-text-logging` queries.

Java/Kotlin
"""""""""""

*   Regular expression checks via annotation with :code:`@javax.validation.constraints.Pattern` are now recognized as sanitizers for :code:`java/path-injection`.
*   Added summary and LLM-generated source and sink models for :code:`org.apache.poi`.
*   The first argument of the :code:`uri` method of :code:`WebClient$UriSpec` in :code:`org.springframework.web.reactive.function.client` is now considered a request forgery sink. Previously only the first arguments of the :code:`WebClient.create` and :code:`WebClient$Builder.baseUrl` methods were considered. This may lead to more alerts for the query :code:`java/ssrf` (Server-side request forgery).

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for Angular's :code:`@HostListener('window:message', ...)` and :code:`@HostListener('document:message', ...)` decorators as :code:`postMessage` event handlers. The decorated method's event parameter is now recognized as a client-side remote flow source, and is considered by the :code:`js/missing-origin-check` query.

Python
""""""

*   :code:`Flask::FlaskApp::instance()` will now also return instances of subclasses defined in the source tree. Previously, these were filtered out. :code:`Flask::FlaskApp::classRef()` has been deprecated in favor of :code:`Flask::FlaskApp::subclassRef()` since it already returned some subclasses.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   Models-as-data flow summaries now use fully qualified field names (for example, :code:`MyNamespace::MyStruct::myField`) instead of unqualified field names such as :code:`myField`. We recommend updating existing flow summaries to use fully qualified field names. Unqualified field names are still supported, but that support will be removed in a future release.
