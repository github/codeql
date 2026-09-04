.. _codeql-cli-2.25.6:

==========================
CodeQL 2.25.6 (2026-06-04)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.25.6 runs a total of 496 security queries when configured with the Default suite (covering 169 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

Improvements
~~~~~~~~~~~~

*   When the :code:`git` executable is available, CodeQL can now obtain configuration and queries from SHA-256 Git repositories, and infer Git metadata about them.

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is used to run the CodeQL CLI has been updated to version 21.0.11.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

GitHub Actions
""""""""""""""

*   Adjusted (minor) help file descriptions for queries: :code:`actions/untrusted-checkout/critical`, :code:`actions/untrusted-checkout/high`, :code:`actions/untrusted-checkout/medium`. Clarified wording on a minor point, added one more listed resource and added one more recommendation for things to check.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   Adjusted :code:`actions/untrusted-checkout/critical` to align more with other untrusted resource queries, where the alert location is the location where the artifact is obtained from (the checkout point). This aligns with the other 2 related queries. This will cause the same alerts to re-open for closed alerts of this query.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   Altered the alert message for clarity for queries: :code:`actions/untrusted-checkout/critical`, :code:`actions/untrusted-checkout/high`.
*   The :code:`actions/unpinned-tag` query now recognizes 64-character SHA-256 commit hashes as properly pinned references, in addition to 40-character SHA-1 hashes.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   Reversed adjustment of the name of :code:`actions/untrusted-checkout/high`, but kept the portion of the previous change for the word "trusted" to "privileged". Added a missing "a" to phrasing in :code:`actions/untrusted-checkout/high` and :code:`actions/untrusted-checkout/medium`.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Swift
"""""

*   Upgraded to allow analysis of Swift 6.3.2.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added flow source models for :code:`scanf_s` and related functions.
*   Added a :code:`Call` column to :code:`LocalFlowSourceFunction::hasLocalFlowSource` and :code:`RemoteFlowSourceFunction::hasRemoteFlowSource`. The old predicates without a :code:`Call` column continue to be supported.

C#
""

*   Full support for C# 14 / .NET 10. All new language features are now supported by the extractor. The QL library and data flow analysis now support the new C# 14 language constructs and include generated Models as Data (MaD) models for the .NET 10 runtime.
*   C# 14: Added support for user-defined instance increment/decrement operators.

Java/Kotlin
"""""""""""

*   Added LLM-generated source and sink models for :code:`org.apache.avro`.

JavaScript/TypeScript
"""""""""""""""""""""

*   The sensitive data heuristics used to identify code that handles passwords and private data have been improved. Most of the changes permit more variations of established patterns, thereby finding more sensitive data. Queries that use the sensitive data library (for example :code:`js/clear-text-logging`) may find more correct results and fewer false positive results after these changes.

Python
""""""

*   The sensitive data heuristics used to identify code that handles passwords and private data have been improved. Most of the changes permit more variations of established patterns, thereby finding more sensitive data. Queries that use the sensitive data library (for example :code:`py/clear-text-logging-sensitive-data`) may find more correct results and fewer false positive results after these changes.

Swift
"""""

*   The sensitive data heuristics used to identify code that handles passwords and private data have been improved. Most of the changes permit more variations of established patterns, thereby finding more sensitive data. Queries that use the sensitive data library (for example :code:`swift/cleartext-logging`) may find more correct results and fewer false positive results after these changes.

GitHub Actions
""""""""""""""

*   The GitHub Actions analysis now recognizes more Bash regex checks that restrict a value to alphanumeric characters, including regexes like :code:`^[0-9a-zA-Z]{40}([0-9a-zA-Z]{24})?$` which check for a SHA-1 or SHA-256 hash. This may reduce false positive results where command output is validated with grouped or optional alphanumeric patterns before being used.

Rust
""""

*   The sensitive data heuristics used to identify code that handles passwords and private data have been improved. Most of the changes permit more variations of established patterns, thereby finding more sensitive data. Queries that use the sensitive data library (for example :code:`rust/cleartext-logging`) may find more correct results and fewer false positive results after these changes.

Deprecated APIs
~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`UsingAliasTypedefType` class has been deprecated. Use :code:`TypeAliasType` instead.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a :code:`getOriginalTemplate` predicate to :code:`TemplateClass`, :code:`TemplateFunction`, :code:`TemplateVariable`, and :code:`AliasTemplateType`, which yields the class member template the template was generated from. The predicates only have results for templates that are members of class template instantiations.
*   Added :code:`AliasTemplateType` and :code:`AliasTemplateInstantiationType` classes, representing C++ alias templates and their instantiations.
