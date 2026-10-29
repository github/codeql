.. _codeql-cli-2.25.2:

==========================
CodeQL 2.25.2 (2026-04-15)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.25.2 runs a total of 492 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is used to run the CodeQL CLI has been updated to version 21.0.10.

Query Packs
-----------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The :code:`cs/constant-condition` query has been simplified. The query no longer reports trivially constant conditions as they were found to generally be intentional. As a result, it should now produce fewer false positives. Additionally, the simplification means that it now reports all the results that :code:`cs/constant-comparison` used to report, and as consequence, that query has been deleted.

Python
""""""

*   Several quality queries have been ported away from using the legacy points-to library. This may lead to changes in alerts.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The "Extraction warnings" (:code:`cpp/diagnostics/extraction-warnings`) diagnostics query no longer yields :code:`ExtractionRecoverableWarning`\ s for :code:`build-mode: none` databases. The results were found to significantly increase the sizes of the produced SARIF files, making them unprocessable in some cases.
*   Fixed an issue with the "Suspicious add with sizeof" (:code:`cpp/suspicious-add-sizeof`) query causing false positive results in :code:`build-mode: none` databases.
*   Fixed an issue with the "Uncontrolled format string" (:code:`cpp/tainted-format-string`) query involving certain kinds of formatting function implementations.
*   Fixed an issue with the "Wrong type of arguments to formatting function" (:code:`cpp/wrong-type-format-argument`) query causing false positive results in :code:`build-mode: none` databases.
*   Fixed an issue with the "Multiplication result converted to larger type" (:code:`cpp/integer-multiplication-cast-to-long`) query causing false positive results in :code:`build-mode: none` databases.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`@security-severity` metadata of :code:`cpp/cgi-xss` has been increased from 6.1 (medium) to 7.8 (high).

C#
""

*   The :code:`@security-severity` metadata of :code:`cs/log-forging` has been reduced from 7.8 (high) to 6.1 (medium).
*   The :code:`@security-severity` metadata of :code:`cs/web/xss` has been increased from 6.1 (medium) to 7.8 (high).

Golang
""""""

*   The :code:`@security-severity` metadata of :code:`go/log-injection` has been reduced from 7.8 (high) to 6.1 (medium).
*   The :code:`@security-severity` metadata of :code:`go/html-template-escaping-bypass-xss`, :code:`go/reflected-xss` and :code:`go/stored-xss` has been increased from 6.1 (medium) to 7.8 (high).

Java/Kotlin
"""""""""""

*   The :code:`@security-severity` metadata of :code:`java/log-injection` has been reduced from 7.8 (high) to 6.1 (medium).
*   The :code:`@security-severity` metadata of :code:`java/android/webview-addjavascriptinterface`, :code:`java/android/websettings-javascript-enabled` and :code:`java/xss` has been increased from 6.1 (medium) to 7.8 (high).

Python
""""""

*   The :code:`@security-severity` metadata of :code:`py/log-injection` has been reduced from 7.8 (high) to 6.1 (medium).
*   The :code:`@security-severity` metadata of :code:`py/jinja2/autoescape-false` and :code:`py/reflective-xss` has been increased from 6.1 (medium) to 7.8 (high).

Ruby
""""

*   The :code:`@security-severity` metadata of :code:`rb/log-injection` has been reduced from 7.8 (high) to 6.1 (medium).
*   The :code:`@security-severity` metadata of :code:`rb/reflected-xss`, :code:`rb/stored-xss` and :code:`rb/html-constructed-from-input` has been increased from 6.1 (medium) to 7.8 (high).

Swift
"""""

*   The :code:`@security-severity` metadata of :code:`swift/unsafe-webview-fetch` has been increased from 6.1 (medium) to 7.8 (high).

Rust
""""

*   The :code:`@security-severity` metadata of :code:`rust/log-injection` has been increased from 2.6 (low) to 6.1 (medium).
*   The :code:`@security-severity` metadata of :code:`rust/xss` has been increased from 6.1 (medium) to 7.8 (high).

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

Python
""""""

*   Fixed the resolution of relative imports such as :code:`from . import helper` inside namespace packages (directories without an :code:`__init__.py` file), which previously did not work correctly, leading to missing flow.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`SourceModelCsv`, :code:`SinkModelCsv`, and :code:`SummaryModelCsv` classes and the associated CSV parsing infrastructure have been removed from :code:`ExternalFlow.qll`. New models should be added as :code:`.model.yml` files in the :code:`ext/` directory.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added :code:`HttpReceiveHttpRequest`, :code:`HttpReceiveRequestEntityBody`, and :code:`HttpReceiveClientCertificate` from Win32's :code:`http.h` as remote flow sources.
*   Added dataflow through members initialized via non-static data member initialization (NSDMI).

C#
""

*   The extractor no longer synthesizes expanded forms of compound assignments. This may have a small impact on the results of queries that explicitly or implicitly rely on the expanded form of compound assignments.
*   The :code:`cs/log-forging` query no longer treats arguments to extension methods with source code on :code:`ILogger` types as sinks. Instead, taint is tracked interprocedurally through extension method bodies, reducing false positives when extension methods sanitize input internally.

Java/Kotlin
"""""""""""

*   The :code:`java/tainted-arithmetic` query no longer flags arithmetic expressions that are used directly as an operand of a comparison in :code:`if`\ -condition bounds-checking patterns. For example, :code:`if (off + len > array.length)` is now recognized as a bounds check rather than a potentially vulnerable computation, reducing false positives.
*   The :code:`java/potentially-weak-cryptographic-algorithm` query no longer flags Elliptic Curve algorithms (:code:`EC`, :code:`ECDSA`, :code:`ECDH`, :code:`EdDSA`, :code:`Ed25519`, :code:`Ed448`, :code:`XDH`, :code:`X25519`, :code:`X448`), HMAC-based algorithms (:code:`HMACSHA1`, :code:`HMACSHA256`, :code:`HMACSHA384`, :code:`HMACSHA512`), or PBKDF2 key derivation as potentially insecure. These are modern, secure algorithms recommended by NIST and other standards bodies. This will reduce the number of false positives for this query.
*   The first argument of the method :code:`getInstance` of :code:`java.security.Signature` is now modeled as a sink for :code:`java/potentially-weak-cryptographic-algorithm`, :code:`java/weak-cryptographic-algorithm` and :code:`java/rsa-without-oaep`. This will increase the number of alerts for these queries.
*   Kotlin versions up to 2.3.20 are now supported.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a subclass :code:`MesonPrivateTestFile` of :code:`ConfigurationTestFile` that represents files created by Meson to test the build configuration.
*   Added a class :code:`ConstructorDirectFieldInit` to represent field initializations that occur in member initializer lists.
*   Added a class :code:`ConstructorDefaultFieldInit` to represent default field initializations.
*   Added a class :code:`DataFlow::IndirectParameterNode` to represent the indirection of a parameter as a dataflow node.
*   Added a predicate :code:`Node::asIndirectInstruction` which returns the :code:`Instruction` that defines the indirect dataflow node, if any.
*   Added a class :code:`IndirectUninitializedNode` to represent the indirection of an uninitialized local variable as a dataflow node.
