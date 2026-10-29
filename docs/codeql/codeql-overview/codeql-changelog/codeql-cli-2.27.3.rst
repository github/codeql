.. _codeql-cli-2.27.3:

==========================
CodeQL 2.27.3 (2026-10-20)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.27.3 runs a total of 498 security queries when configured with the Default suite (covering 170 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   With the release of macOS 27 and Xcode 27, Apple stopped shipping multi-architecture x86-64/arm64 binaries. These binaries are required by CodeQL to perform traced analysis. For this reason, CodeQL's :code:`autobuild` and :code:`manual` build modes will not be supported for compiled languages on macOS 27 with any Xcode version, and on macOS 26 when Xcode 27 is selected.

Bug Fixes
~~~~~~~~~

*   Fixed a bug that caused database downgrades to fail for GitHub Actions databases.

Improvements
~~~~~~~~~~~~

*   Data extension files now support JSON syntax, with the same structure as existing YAML data extensions. Java-style comments (:code:`// ...` and :code:`/* ... */`)
    are also supported. Files using the :code:`.json` extension will be parsed as JSON,
    while all other files will continue to be parsed as YAML.
*   The :code:`codeql test run` feature to load a data extension named :code:`<test>.ext.yml` when running :code:`<test>.ql` or :code:`<test>.qlref` has been updated to support JSON data extensions, and files named :code:`<test>.ext.json` will now also be loaded automatically.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/resource-not-released-in-destructor` query now recognizes resources released through local aliases, reducing false-positive results.

C#
""

*   The :code:`cs/simplifiable-boolean-expression` query now produces fewer false-positive results when type information is incomplete.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   The GitHub Actions control flow graph (CFG) now uses the shared CFG library. The CFG includes explicit before and after nodes and uses the shared entry and exit node representations. Existing code that relies on specific CFG nodes, edges, textual representations, or basic block boundaries may need to be updated. The legacy :code:`Completion`, :code:`NormalCompletion`, :code:`SimpleCompletion`, :code:`BooleanCompletion`, and :code:`ReturnCompletion` classes have been removed because completions are no longer part of the Actions CFG API. Code that inspected completions should inspect CFG edge labels such as :code:`DirectSuccessor`, :code:`BooleanSuccessor`, and :code:`ReturnSuccessor` instead.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added flow summaries for the BlazingMQ :code:`BloombergLP::bmqa::Message` and :code:`MessageProperties` classes and their iterators.

C#
""

*   Avoid logging warnings when there are no explicit or inherited feeds to check for reachability.
*   The subprocess for the NuGet CLI is now provided with the proxy and certificate environment variables needed to access private registries if any are configured.
*   Added support for data flow through positional patterns in :code:`is` expressions and :code:`switch` cases.

Java/Kotlin
"""""""""""

*   The queries :code:`java/ssrf` and :code:`java/unvalidated-url-redirection` recognize case-insensitive comparisons of :code:`URI.getHost()` with fixed string allowlist entries, as well as equality and case-insensitive comparisons when the host is stored in a local variable.

Python
""""""

*   Updated the :code:`py/xxe`, :code:`py/xml-bomb`, and :code:`py/nosql-injection` queries to respect the configured threat model when selecting untrusted data sources. The default behavior remains unchanged and uses remote flow sources. As a side effect, these queries now correctly include sources modeled using data extensions.
*   Added taint-flow modeling for :code:`unicodedata.iter_graphemes`, introduced in Python 3.15.
*   Added data-flow modeling for :code:`threading.serialize_iterator` and :code:`threading.concurrent_tee`, introduced in Python 3.15.
*   Added modeling for the Base32, Base85, and Ascii85 encoding and decoding functions introduced in Python 3.15's :code:`binascii` module, including taint flow through custom alphabets.
*   Added support for the :code:`frozendict` and :code:`sentinel` builtins introduced in Python 3.15, and data-flow modeling for :code:`frozendict` construction.
*   The Python extractor now supports unary plus in :code:`match` literal patterns, introduced in Python 3.15.
*   The Python extractor now supports Unicode 17 identifiers, introduced in Python 3.15.
*   Added modeling for the :code:`extra_response_headers` constructor argument and instance attribute of :code:`http.server.SimpleHTTPRequestHandler`, introduced in Python 3.15.
*   Added modeling for Python 3.15's :code:`re.prefixmatch` and :code:`re.Pattern.prefixmatch`, matching the existing support for their :code:`match` counterparts.
*   Added taint-flow modeling for :code:`bytearray` construction and Python 3.15's :code:`bytearray.take_bytes` method.

Rust
""""

*   The Rust extractor has been upgraded to use :code:`rust-analyzer` version 0.0.357. As a result, the AST exposed by the Rust libraries now includes the :code:`CfgPredExpr` and :code:`CfgPredPat` classes.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added support for C23 bit-precise integers (:code:`_BitInt(N)`).

Ruby
""""

*   Added modeling for :code:`Grape::API`\ 's :code:`request` sub-accessors (:code:`body.read`, :code:`body.string`, :code:`params`, :code:`GET`, :code:`POST`, :code:`cookies`, :code:`env`, :code:`query_string`, and :code:`path_info`) as remote flow sources.

Shared Libraries
----------------

New Features
~~~~~~~~~~~~

Threat Models
"""""""""""""

*   Added the opt-in :code:`ai` threat model for LLM-generated data. No built-in source models are included.
