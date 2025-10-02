.. _codeql-cli-2.23.0:

==========================
CodeQL 2.23.0 (2025-09-04)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.23.0 runs a total of 479 security queries when configured with the Default suite (covering 169 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is used to run the CodeQL CLI has been updated to version 21.0.8.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

C/C++
"""""

*   Fixed an inconsistency across languages where most have a :code:`Customizations.qll` file for adding customizations, but not all did.

Swift
"""""

*   Fixed an inconsistency across languages where most have a :code:`Customizations.qll` file for adding customizations, but not all did.

Rust
""""

*   The "Low Rust analysis quality" query (:code:`rust/diagnostic/database-quality`) has been tuned so that it won't trigger on databases that have extracted normally. This will remove spurious messages of "Low Rust analysis quality" on the CodeQL status page.
*   Fixed an inconsistency across languages where most have a :code:`Customizations.qll` file for adding customizations, but not all did.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Fixed a bug that was causing false negatives in rare cases in the query :code:`java/dereferenced-value-may-be-null`.
*   Removed the :code:`java/empty-statement` query that was subsumed by the :code:`java/empty-block` query.

Python
""""""

*   The :code:`py/unexpected-raise-in-special-method` query has been modernized. It produces additional results in cases where the exception is
    only raised conditionally. Its precision has been changed from :code:`very-high` to :code:`high`.
*   The queries :code:`py/incomplete-ordering`, :code:`py/inconsistent-equality`, and :code:`py/equals-hash-mismatch` have been modernized; no longer relying on outdated libraries, improved documentation, and no longer producing alerts for problems specific to Python 2.

New Queries
~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The query :code:`java/insecure-spring-actuator-config` has been promoted from experimental to the main query pack as :code:`java/spring-boot-exposed-actuators-config`. Its results will now appear by default. This query detects exposure of Spring Boot actuators through configuration files. It was originally submitted as an experimental query `by @luchua-bc <https://github.com/github/codeql/pull/5384>`__.

Rust
""""

*   Added a new query, :code:`rust/log-injection`, for detecting cases where log entries could be forged by a malicious user.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The tag :code:`maintainability` has been removed from :code:`java/run-finalizers-on-exit` and the tags :code:`quality`, :code:`correctness`, and :code:`performance` have been added.
*   The tag :code:`maintainability` has been removed from :code:`java/garbage-collection` and the tags :code:`quality` and :code:`correctness` have been added.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Rust
""""

*   Path resolution has been removed from the Rust extractor. For the majority of purposes CodeQL computed paths have been in use for several previous releases, this completes the transition. Extraction is now faster and more reliable.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added flow summaries for the :code:`Microsoft::WRL::ComPtr` member functions.
*   The new dataflow/taint-tracking library (:code:`semmle.code.cpp.dataflow.new.DataFlow` and :code:`semmle.code.cpp.dataflow.new.TaintTracking`) now resolves virtual function calls more precisely. This results in fewer false positives when running dataflow/taint-tracking queries on C++ projects.

C#
""

*   A bug has been fixed in the data flow analysis, which means that flow through calls using the :code:`base` qualifier may now be tracked more accurately.
*   Added summary models for :code:`System.Xml.XmlReader`, :code:`System.Xml.XmlTextReader` and :code:`System.Xml.XmlDictionaryReader`.
*   Models-as-data summaries for byte and char arrays and pointers now treat the entire collection as tainted, reflecting their common use as string alternatives.
*   The default taint tracking configuration now allows implicit reads from collections at sinks and in additional flow steps. This increases flow coverage for many taint tracking queries and helps reduce false negatives.

JavaScript/TypeScript
"""""""""""""""""""""

*   Removed :code:`libxmljs` as an XML bomb sink. The underlying libxml2 library now includes `entity reference loop detection <https://github.com/GNOME/libxml2/blob/0c948334a8f5c66d50e9f8992e62998017dc4fc6/NEWS#L905-L908>`__ that prevents XML bomb attacks.

Python
""""""

*   The modelling of Psycopg2 now supports the use of :code:`psycopg2.pool` connection pools for handling database connections.
*   Removed :code:`lxml` as an XML bomb sink. The underlying libxml2 library now includes `entity reference loop detection <https://github.com/lxml/lxml/blob/f33ac2c2f5f9c4c4c1fc47f363be96db308f2fa6/doc/FAQ.txt#L1077>`__ that prevents XML bomb attacks.

Rust
""""

*   Attribute macros are now taken into account when identifying macro-expanded code. This affects the queries :code:`rust/unused-variable` and :code:`rust/unused-value`, which exclude results in macro-expanded code.
*   Improved modelling of the :code:`std::fs`, :code:`async_std::fs` and :code:`tokio::fs` libraries. This may cause more alerts to be found by Rust injection queries, particularly :code:`rust/path-injection`.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a new class :code:`PchFile` representing precompiled header (PCH) files used during project compilation.

Shared Libraries
----------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Utility Classes
"""""""""""""""

*   Added :code:`LocatableOption` and :code:`OptionWithLocationInfo` as modules providing option types with location information.
