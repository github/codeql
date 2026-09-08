.. _codeql-cli-2.26.4:

==========================
CodeQL 2.26.4 (2026-08-26)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.26.4 runs a total of 497 security queries when configured with the Default suite (covering 170 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   The Java Autobuilder now expands project properties, such as
    :code:`${maven.version}`, when determining Maven version requirements specified by the Maven Enforcer Plugin. The Java Autobuilder now also supports Maven versions through 3.9.16.

New Features
~~~~~~~~~~~~

*   :code:`codeql test run` now supports the :code:`--reuse-dataset` option, which reuses an existing test database from a previous run when available,
    skipping database extraction. This can speed up repeated test runs when only the query under test has changed. The option implies
    :code:`--keep-databases`.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

C#
""

*   The query :code:`cs/useless-cast-to-self` no longer reports casts when both the expression type and the cast target type are unknown, which can occur in :code:`build-mode: none` databases.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The :code:`cs/simplifiable-boolean-expression` query no longer suggests replacing a negated comparison when the replacement could recursively call an enclosing user-defined operator in :code:`build-mode: none` databases.
*   The :code:`cs/web/missing-token-validation` query now recognizes enabled ASP.NET Core :code:`RequireAntiforgeryToken` attributes when antiforgery middleware is used.
*   The query :code:`cs/virtual-call-in-constructor` has been improved. Uses of virtual members in :code:`nameof` expressions are no longer reported, since they are not calls.
*   Static constructors are now used as the enclosing callable for static member initializer expressions. This improves the precision of a range of queries, including :code:`cs/useless-assignment-to-local` and :code:`cs/dereferenced-value-may-be-null`.

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/superfluous-trailing-arguments` query no longer reports valid arguments passed to the :code:`TransformStream` constructor.

GitHub Actions
""""""""""""""

*   The :code:`actions/unpinned-tag` query now detects mutable references to reusable workflows.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   Checks on actor fields read from the event payload (e.g. :code:`github.event.pull_request.user.login`) were split out of :code:`ActorIfCheck` into a new class :code:`EventActorIfCheck`. The :code:`ActorIfCheck` class now only covers :code:`github.actor` and :code:`github.triggering_actor`.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   Simplified and streamlined the use of NuGet sources when downloading dependencies. In fallback scenarios and specialized package downloads, NuGet sources are now passed directly to :code:`dotnet restore` via the CLI. Furthermore, no :code:`nuget.config` files are created for fallback scenarios, and private registries are used when attempting to download missing packages that were not restored as part of the normal :code:`dotnet restore` process.

Golang
""""""

*   Go 1.27 is now supported.

Rust
""""

*   The alert locations for data flow queries have been improved. The new locations are more precise and are based on the actual source and sink nodes. Example:

    ..  code-block:: rust
    
        let _ = conn.query(
        //      ^^^^                 old alert location
            unsafe_query.as_str(),
        //  ^^^^^^^^^^^^^^^^^^^^^    new alert location
        )?;

    This means that some alerts will have their locations changed, and hence appear as new alerts (while the old alerts will disappear).

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   Removed the summary model for :code:`String.valueOf(CharSequence)`, which does not exist. Instead, taint is now propagated through calls to :code:`String.valueOf(Object)` when the argument is a :code:`CharSequence`, for example a :code:`String` or a :code:`StringBuilder`.
*   Added SQL injection sink models for Spring R2DBC :code:`DatabaseClient` and the R2DBC SPI.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for regular expressions using the :code:`d` flag.

Python
""""""

*   Added taint flow through :code:`list.extend` and :code:`list.insert`, matching the existing taint flow through :code:`list.append`.

Ruby
""""

*   The algorithm for tracking regexes has been replaced. This can cause result changes in related queries, for example, :code:`rb/polynomial-redos`.

GitHub Actions
""""""""""""""

*   Checks on actor fields read from the event payload (e.g. :code:`github.event.pull_request.user.login`) now only count as protection for events whose payload actually populates that field. Previously, a condition such as :code:`github.event.pull_request.user.login != 'name'` on a workflow triggered by :code:`issues` events was treated as a protective check even though :code:`github.event.pull_request` is not populated for :code:`issues` events, which makes the condition vacuous. This change may result in more alerts for queries using the :code:`ControlCheck` class.
*   Added an option to :code:`EnvironmentCheck` to become specified by a MaD model, otherwise it will continue as the default it previously was. Without adding models to :code:`actions/ql/lib/ext/config/deployment_environment.yml` the behavior of every query will be unchanged. When models are added queries using :code:`ControlCheck` may find more results in cases where an environment is no longer a sufficient sanitizer.

Rust
""""

*   Canonical paths for Rust trait items now use the format :code:`crate::Trait::item` instead of
    :code:`<_ as crate::Trait>::item`. Custom data extension models that reference trait items must be updated to use the new format.
*   The Rust extractor has been upgraded to use :code:`rust-analyzer` version 0.0.328. As a result, the AST exposed by the Rust libraries has changed: the :code:`TraitAlias` class has been removed, :code:`cfg` attributes are now modeled by the new :code:`CfgMeta`, :code:`CfgAtom`, :code:`CfgComposite`, :code:`CfgPredicate`, and :code:`CfgAttrMeta` classes, and the :code:`Meta` class has been refined into the :code:`KeyValueMeta`, :code:`PathMeta`, :code:`TokenTreeMeta`, and :code:`UnsafeMeta` subclasses. New :code:`TryBlockModifier` and :code:`FormatArgsArgName` classes have also been added.

New Features
~~~~~~~~~~~~

C#
""

*   Added the :code:`AdditionalTaintStep` extension point (:code:`semmle.code.csharp.dataflow.FlowSteps`). Extend this class to add additional taint steps that apply to all taint-tracking configurations.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for recognizing the React Native Worklets :code:`"worklet"` directive as a known directive.
