.. _codeql-cli-2.25.5:

==========================
CodeQL 2.25.5 (2026-05-21)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.25.5 runs a total of 496 security queries when configured with the Default suite (covering 169 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

There are no user-facing CLI changes in this release.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

GitHub Actions
""""""""""""""

*   Fixed help file descriptions for queries: :code:`actions/untrusted-checkout/critical`, :code:`actions/untrusted-checkout/high`, :code:`actions/untrusted-checkout/medium`. Previously the messages were unclear as to why and how the vulnerabilities could occur.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The 'Cleartext transmission of sensitive information' query (:code:`cpp/cleartext-transmission`) no longer raises an alert on calls to :code:`fscanf` (and variants) when the call reads from an "obviously local" :code:`FILE` stream such as :code:`stdin`.

Java/Kotlin
"""""""""""

*   The :code:`java/zipslip` query no longer reports archive entry names that flow only to read-only path sinks such as :code:`ClassLoader.getResource`, :code:`FileInputStream`, and :code:`FileReader`. The query now restricts its sinks to the :code:`path-injection` kind and deliberately excludes the new :code:`path-injection[read]` sub-kind, matching the Zip Slip threat model of unsafe archive extraction.

GitHub Actions
""""""""""""""

*   The :code:`actions/unpinned-tag` query now analyzes composite action metadata (:code:`action.yml`\ /\ :code:`action.yaml` files) in addition to workflow files, providing more comprehensive detection of unpinned action references across the entire Actions ecosystem.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   Adjusted the name of :code:`actions/untrusted-checkout/high` to more clearly describe which parts of the scenario are in a privileged context.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`RemoteFlowSourceFunction` model for :code:`fscanf` (and variants) now implements :code:`hasSocketInput` to reflect that these functions may read from a socket.

Java/Kotlin
"""""""""""

*   Introduced a new sink kind :code:`path-injection[read]` for Models-as-Data rows that only read from a path (such as :code:`ClassLoader.getResource`, :code:`FileInputStream`, :code:`FileReader`, :code:`Files.readAllBytes`, and related APIs). The general :code:`java/path-injection` query continues to consider both :code:`path-injection` and :code:`path-injection[read]` sinks.

GitHub Actions
""""""""""""""

*   Altered 2 patterns in the :code:`poisonable_steps` modelling. Extra sinks are detected in the following cases: scripts executed via python modules and :code:`go run` in directories are detected as potential mechanisms of injection. For the go execution pattern, the pattern is updated to now ignore flags that occur between go and the specific command. This change may lead to more results being detected by the following queries: :code:`actions/untrusted-checkout/high`, :code:`actions/untrusted-checkout/critical`, :code:`actions/untrusted-checkout-toctou/high`, :code:`actions/untrusted-checkout-toctou/critical`, :code:`actions/cache-poisoning/poisonable-step`, :code:`actions/cache-poisoning/direct-cache` and :code:`actions/artifact-poisoning/path-traversal`.

New Features
~~~~~~~~~~~~

Swift
"""""

*   The :code:`TypeDecl` class now defines a :code:`getDeclaredInterfaceType` predicate, which yields the declared interface type of the type declaration.
