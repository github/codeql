.. _codeql-cli-2.21.2:

==========================
CodeQL 2.21.2 (2025-05-01)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.21.2 runs a total of 452 security queries when configured with the Default suite (covering 168 CWE). The Extended suite enables an additional 136 queries (covering 35 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   :code:`codeql generate log-summary` now correctly includes :code:`dependencies` maps in predicate events for :code:`COMPUTED_EXTENSIONAL` predicates.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

GitHub Actions
""""""""""""""

*   Assigned a :code:`security-severity` to the query :code:`actions/excessive-secrets-exposure`.

Breaking Changes
~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   The following queries have been removed from the :code:`security-and-quality` suite.
    They are not intended to produce user-facing alerts describing vulnerabilities.
    Any existing alerts for these queries will be closed automatically.

    *   :code:`actions/composite-action-sinks`
    *   :code:`actions/composite-action-sources`
    *   :code:`actions/composite-action-summaries`
    *   :code:`actions/reusable-workflow-sinks` (renamed from :code:`actions/reusable-wokflow-sinks`)
    *   :code:`actions/reusable-workflow-sources`
    *   :code:`actions/reusable-workflow-summaries`

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Changes to the MaD model generation infrastructure:

    *   Changed the query :code:`cs/utils/modelgenerator/summary-models` to use the implementation from :code:`cs/utils/modelgenerator/mixed-summary-models`.
    *   Removed the now-redundant :code:`cs/utils/modelgenerator/mixed-summary-models` query.
    *   A similar replacement was made for :code:`cs/utils/modelgenerator/neutral-models`. That is, if :code:`GenerateFlowModel.py` is provided with :code:`--with-summaries`, combined/mixed models are now generated instead of heuristic models (and similar for :code:`--with-neutrals`).
    
*   Improved detection of authorization checks in the :code:`cs/web/missing-function-level-access-control` query. The query now recognizes authorization attributes inherited from base classes and interfaces.
*   The precision of the query :code:`cs/invalid-string-formatting` has been improved. More methods and more overloads of existing format like methods are taken into account by the query.

Java/Kotlin
"""""""""""

*   Changes to the MaD model generation infrastructure:

    *   Changed the query :code:`java/utils/modelgenerator/summary-models` to use the implementation from :code:`java/utils/modelgenerator/mixed-summary-models`.
    *   Removed the now-redundant :code:`java/utils/modelgenerator/mixed-summary-models` query.
    *   A similar replacement was made for :code:`java/utils/modelgenerator/neutral-models`. That is, if :code:`GenerateFlowModel.py` is provided with :code:`--with-summaries`, combined/mixed models are now generated instead of heuristic models (and similar for :code:`--with-neutrals`).

Rust
""""

*   Changes to the MaD model generation infrastructure:

    *   Changed the query :code:`rust/utils/modelgenerator/summary-models` to use the implementation from :code:`rust/utils/modelgenerator/mixed-summary-models`.
    *   Removed the now-redundant :code:`rust/utils/modelgenerator/mixed-summary-models` query.
    *   A similar replacement was made for :code:`rust/utils/modelgenerator/neutral-models`. That is, if :code:`GenerateFlowModel.py` is provided with :code:`--with-summaries`, combined/mixed models are now generated instead of heuristic models (and similar for :code:`--with-neutrals`).

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Swift
"""""

*   Upgraded to allow analysis of Swift 6.1.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Improved autobuilder logic for detecting whether a project references a SDK (and should be built using :code:`dotnet`).

Swift
"""""

*   Added AST nodes :code:`ActorIsolationErasureExpr`, :code:`CurrentContextIsolationExpr`,
    :code:`ExtracFunctionIsolationExpr` and :code:`UnreachableExpr` that correspond to new nodes added by Swift 6.0.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   New classes :code:`TypeofType`, :code:`TypeofExprType`, and :code:`TypeofTypeType` were introduced, which represent the C23 :code:`typeof` and :code:`typeof_unqual` operators. The :code:`TypeofExprType` class represents the variant taking an expression as its argument. The :code:`TypeofTypeType` class represents the variant taking a type as its argument.
*   A new class :code:`IntrinsicTransformedType` was introduced, which represents the type transforming intrinsics supported by clang, gcc, and MSVC.
*   Introduced :code:`hasDesignator()` predicates to distinguish between designated and positional initializations for both struct/union fields and array elements.
*   Added the :code:`isVla()` predicate to the :code:`ArrayType` class. This allows queries to identify variable-length arrays (VLAs).
