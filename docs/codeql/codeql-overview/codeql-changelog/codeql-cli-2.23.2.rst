.. _codeql-cli-2.23.2:

==========================
CodeQL 2.23.2 (2025-10-02)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.23.2 runs a total of 479 security queries when configured with the Default suite (covering 166 CWE). The Extended suite enables an additional 135 queries (covering 35 more CWE). 1 security query has been added with this release.

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   The :code:`codeql generate query-help` command now prepends the query's name (taken from the :code:`.ql` file) as a level-one heading when processing markdown query help, for consistency with help generated from a :code:`.qhelp` file.

New Features
~~~~~~~~~~~~

*   CodeQL Go analysis now supports the "Git Source" type for `private package registries <https://docs.github.com/en/code-security/securing-your-organization/enabling-security-features-in-your-organization/giving-org-access-private-registries>`__. This is in addition to the existing support for the "GOPROXY server" type.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The modeling of null guards based on complex pattern expressions has been improved, which in turn improves the query :code:`cs/dereferenced-value-may-be-null` by removing false positives.
*   The query :code:`cs/xmldoc/missing-summary` has been removed from the :code:`code-quality` suite, to align with other languages.

Python
""""""

*   The queries that check for unmatchable :code:`$` and :code:`^` in regular expressions did not account correctly for occurrences inside lookahead and lookbehind assertions. These occurrences are now handled correctly, eliminating this source of false positives.
*   The :code:`py/inheritance/signature-mismatch` query has been modernized. It produces more precise results and more descriptive alert messages.
*   The :code:`py/inheritance/incorrect-overriding-signature` query has been deprecated. Its results have been consolidated into the :code:`py/inheritance/signature-mismatch` query.

New Queries
~~~~~~~~~~~

Rust
""""

*   Added a new query, :code:`rust/non-https-url`, for detecting the use of non-HTTPS URLs that can be intercepted by third parties.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   Added modeling of :code:`GraphQLObjectType` resolver function parameters as remote sources.
*   Support for the `graphql <https://www.npmjs.com/package/graphql>`__ library has been improved. Data flow from GraphQL query sources and variables to resolver function parameters is now tracked.
*   Added support for the :code:`aws-sdk` and :code:`@aws-sdk/client-dynamodb`, :code:`@aws-sdk/client-athena`, :code:`@aws-sdk/client-s3`, and :code:`@aws-sdk/client-rds-data` packages.

Python
""""""

*   Data flow tracking through global variables now supports nested field access patterns such as :code:`global_var.obj.field`. This improves the precision of taint tracking analysis when data flows through complex global variable structures.

New Features
~~~~~~~~~~~~

Ruby
""""

*   Initial modeling for the Ruby Grape framework in :code:`Grape.qll` has been added to detect API endpoints, parameters, and headers within Grape API classes.

Rust
""""

*   The models-as-data format for sources now supports access paths of the form
    :code:`Argument[i].Parameter[j]`. This denotes that the source passes tainted data to the :code:`j`\ th parameter of its :code:`i`\ th argument (which must be a function or a closure).
