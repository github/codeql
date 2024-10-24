.. _codeql-cli-2.19.1:

==========================
CodeQL 2.19.1 (2024-10-04)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.19.1 runs a total of 426 security queries when configured with the Default suite (covering 164 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE).

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   The command :code:`codeql generate query-help` now supports Markdown help files.
    The Markdown help format is commonly used in custom CodeQL query packs. This new feature allows us to generate SARIF reporting descriptors for CodeQL queries that include Markdown help directly from a query Markdown help file.
    
*   Added a new command, :code:`codeql resolve packs`. This command shows each step in the pack search process, including what packs were found in each step. With the
    :code:`--show-hidden-packs` option, it can also show details on which packs were hidden by packs found earlier in the search sequence. :code:`codeql resolve packs` is intended as a replacement for most uses of :code:`codeql resolve qlpacks`, whose output is both less detailed and less accurate.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Fixed false positives in the :code:`cpp/wrong-number-format-arguments` ("Too few arguments to formatting function") query when the formatting function has been declared implicitly.

C#
""

*   C#: The indexer and :code:`Add` method on :code:`System.Web.UI.AttributeCollection` is no longer considered an HTML sink.

Java/Kotlin
"""""""""""

*   Added taint summary model for :code:`org.springframework.core.io.InputStreamSource#getInputStream()`.

New Queries
~~~~~~~~~~~

Python
""""""

*   The experimental :code:`py/cors-misconfiguration-with-credentials` query, which finds insecure CORS middleware configurations.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

Golang
""""""

*   The precision of the :code:`go/incorrect-integer-conversion-query` query was decreased from :code:`very-high` to :code:`high`, since there is at least one known class of false positives involving dynamic bounds checking.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

C#
""

*   C#: Add support for MaD directly on properties and indexers using *attributes*. Using :code:`Attribute.Getter` or :code:`Attribute.Setter` in the model :code:`ext` field applies the model to the getter or setter for properties and indexers. Prior to this change :code:`Attribute` models unintentionally worked for property setters (if the property is decorated with the matching attribute). That is, a model that uses the :code:`Attribute` feature directly on a property for a property setter needs to be changed to :code:`Attribute.Setter`.
*   C#: Remove all CIL tables and related QL library functionality.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   :code:`DataFlow::Node` instances are no longer created for library methods and fields that are not callable (either statically or dynamically) or otherwise referred to from source code. This may affect third-party queries that use these nodes to identify library methods or fields that are present in DLL files where those methods or fields are unreferenced. If this presents a problem, consider using :code:`Callable` and other non-dataflow classes to identify such library entities.
*   C#: Add extractor support for attributes on indexers.

Golang
""""""

*   A method in the method set of an embedded field of a struct should not be promoted to the method set of the struct if the struct has a method with the same name. This was not being enforced, which meant that there were two methods with the same qualified name, and models were sometimes being applied when they shouldn't have been. This has now been fixed.

Python
""""""

*   The common sanitizer guard :code:`StringConstCompareBarrier` has been renamed to :code:`ConstCompareBarrier` and expanded to cover comparisons with other constant values such as :code:`None`. This may result in fewer false positive results for several queries.

Swift
"""""

*   All AST classes in :code:`codeql.swift.elements` are now :code:`final`, which means that it is no longer possible to :code:`override` predicates defined in those classes (it is, however, still possible to :code:`extend` the classes).

Deprecated APIs
~~~~~~~~~~~~~~~

C#
""

*   The class :code:`ThreatModelFlowSource` has been renamed to :code:`ActiveThreatModelSource` to more clearly reflect it only contains the currently active threat model sources. :code:`ThreatModelFlowSource` has been marked as deprecated.

Golang
""""""

*   The class :code:`ThreatModelFlowSource` has been renamed to :code:`ActiveThreatModelSource` to more clearly reflect it only contains the currently active threat model sources. :code:`ThreatModelFlowSource` has been marked as deprecated.

Java/Kotlin
"""""""""""

*   The :code:`Field.getSourceDeclaration()` predicate has been deprecated. The result was always the original field, so calls to it can simply be removed.
*   The :code:`Field.isSourceDeclaration()` predicate has been deprecated. It always holds.
*   The :code:`RefType.nestedName()` predicate has been deprecated, and :code:`RefType.getNestedName()` added to replace it.
*   The class :code:`ThreatModelFlowSource` has been renamed to :code:`ActiveThreatModelSource` to more clearly reflect it only contains the currently active threat model sources. :code:`ThreatModelFlowSource` has been marked as deprecated.

New Features
~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The Java extractor and QL libraries now support Java 23.
*   Kotlin versions up to 2.1.0\ *x* are now supported.

Python
""""""

*   Added support for custom threat-models, which can be used in most of our taint-tracking queries, see our `documentation <https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#extending-codeql-coverage-with-threat-models>`__ for more details.
