.. _codeql-cli-2.24.3:

==========================
CodeQL 2.24.3 (2026-03-05)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.24.3 runs a total of 491 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a race condition that could cause flaky failures in overlay CodeQL tests. Test extraction now skips :code:`*.testproj` directories by name, preventing interference from concurrently cleaned-up test databases.
*   Fixed spurious "OOPS" warnings that could appear in help output for commands using mutually exclusive option groups, such as :code:`codeql query run`.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The Java extractor and QL libraries now support Java 26.
*   Java analysis now selects the Java version to use informed by Maven POM files across all project modules. It also tries to use Java 17 or higher for all Maven projects if possible, for improved build compatibility.

Rust
""""

*   The macro resolution metric has been removed from :code:`rust/diagnostic/database-quality`. This metric was found to be an unreliable indicator of database quality in many cases, leading to false alarms on the tool status page.

Language Libraries
------------------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   The :code:`allowInterproceduralFlow` predicate of must-flow data flow configurations now correctly handles direct recursion.

C#
""

*   Fixed an issue where the body of a partial member could be extracted twice. When both a *defining* and an *implementing* declaration exist, only the *implementing* declaration is now extracted.

Breaking Changes
~~~~~~~~~~~~~~~~

C/C++
"""""

*   CodeQL version 2.24.2 accidentally introduced a syntactical breaking change to :code:`BarrierGuard<...>::getAnIndirectBarrierNode` and :code:`InstructionBarrierGuard<...>::getAnIndirectBarrierNode`. These breaking changes have now been reverted so that the original code compiles again.
*   :code:`MustFlow`, the inter-procedural must-flow data flow analysis library, has been re-worked to use parameterized modules. Like in the case of data flow and taint tracking, instead of extending the :code:`MustFlowConfiguration` class, the user should now implement a module with the :code:`MustFlow::ConfigSig` signature, and instantiate the :code:`MustFlow::Global` parameterized module with the implemented module.

Python
""""""

*   The :code:`Metrics` library no longer contains code that depends on the points-to analysis. The removed functionality has instead been moved to the :code:`LegacyPointsTo` module, to classes like :code:`ModuleMetricsWithPointsTo` etc. If you depend on any of these classes, you must now remember to import :code:`LegacyPointsTo`, and use the appropriate types in order to use the points-to-based functionality.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Python
""""""

*   The CodeQL Python libraries have been updated to be compatible with overlay evaluation. This should result in a significant speedup on analyses for which a base database already exists. Note that it may be necessary to add :code:`overlay[local?] module;` to user-managed libraries that extend classes that are now marked as :code:`overlay[local]`.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Refactored the "Year field changed using an arithmetic operation without checking for leap year" query (:code:`cpp/leap-year/unchecked-after-arithmetic-year-modification`) to address large numbers of false positive results.

C#
""

*   C# 14: Added support for partial events.
*   C# 14: Added support for the :code:`field` keyword in properties.

Java/Kotlin
"""""""""""

*   Some modelling which previously only worked for Java EE packages beginning with "javax" will now also work for Java EE packages beginning with "jakarta" as well. This may lead to some alert changes.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for React components wrapped by :code:`observer` from :code:`mobx-react` and :code:`mobx-react-lite`.

Python
""""""

*   Added new full SSRF sanitization barrier from the new AntiSSRF library.
*   When a guard such as :code:`isSafe(x)` is defined, we now also automatically handle :code:`isSafe(x) == true` and :code:`isSafe(x) != false`.

Ruby
""""

*   We now track taint flow through :code:`Shellwords.escape` and :code:`Shellwords.shellescape` for all queries except command injection, for which they are sanitizers.

Rust
""""

*   Added support for neutral models (:code:`extensible: neutralModel`) to control where generated source, sink and flow summary models apply.
