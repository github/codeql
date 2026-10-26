.. _codeql-cli-2.26.3:

==========================
CodeQL 2.26.3 (2026-08-12)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.26.3 runs a total of 497 security queries when configured with the Default suite (covering 170 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed the pack upload format to comply with the OCI-image-manifest specification, by ensuring that all required fields are present/valid, and that no extraneous/non-compliant fields are included.
*   Fixed path canonicalization on Windows so that paths located on :code:`subst`\ ed drives are always resolved to their underlying target paths. Previously, :code:`subst`\ ed drives were not handled consistently by the CodeQL CLI and the language-specific extractors.

Improvements
~~~~~~~~~~~~

*   Commands that accept a :code:`--ram` option now report a clear error when given a value that is far too large to be a sensible amount of memory in megabytes (for example, a number of bytes passed by mistake), instead of failing with a cryptic "is not an int" message.

Miscellaneous
~~~~~~~~~~~~~

*   Upgraded Jackson from 2.18.6 to 2.18.9.

Query Packs
-----------

Bug Fixes
~~~~~~~~~

GitHub Actions
""""""""""""""

*   The :code:`actions/output-clobbering/high` query now provides messages tailored to the affected output channel and includes expanded documentation and recommendations.
*   The :code:`actions/cache-poisoning/poisonable-step` and :code:`actions/untrusted-checkout/critical` queries now start paths at the expressions that control untrusted checkouts and link their alert messages to those expressions.
*   Fixed a performance issue in the :code:`actions/output-clobbering/high` query caused by using unescaped source-code input in a regular expression.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   The :code:`js/missing-rate-limiting` query now recognizes the :code:`@fastify/rate-limit` package as a rate limiter.

GitHub Actions
""""""""""""""

*   The :code:`actions/output-clobbering/high` query no longer reports simple :code:`jq` path filters when their output remains JSON-encoded. Raw-output modes, complex filters, and unrecognized options remain reportable.
*   GitHub Actions queries now correctly classify the :code:`schedule` event when determining whether a workflow is externally triggerable.
*   The :code:`actions/envvar-injection/critical` query now requires the untrusted source and privileged context to originate from the same trigger event. The environment variable injection queries also no longer treat pull request head labels as injection-capable because they cannot contain newlines.
*   The :code:`actions/cache-poisoning/code-injection`, :code:`actions/cache-poisoning/direct-cache`, and :code:`actions/cache-poisoning/poisonable-step` queries now account for read-only cache access on low-trust triggers that run in the default branch scope. Results are retained for triggers that GitHub allows to write to that cache scope.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   The name and alert message of the :code:`actions/cache-poisoning/code-injection` query have been reworded for clarity.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

GitHub Actions
""""""""""""""

*   The :code:`codeql.actions.security.SelfHostedQuery` module has been removed because runner labels do not reliably distinguish self-hosted runners from managed runners.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

JavaScript/TypeScript
"""""""""""""""""""""

*   It is now possible for custom models to refer to specific files in the codebase, using a package name of form :code:`file:<path>`. The model should describe the public exports of that file. This can be used to derive sources and sinks in code that imports the file, but note that sources and sinks will not generally be placed within the file itself.
    For example, a source model :code:`['file:lib/service.js', 'Member[getData].ReturnValue', 'remote']` could identify :code:`require('../lib/service').getData()` as a source.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added flow source models for :code:`RegQueryValue` and related functions from the :code:`winreg.h` Windows header.

JavaScript/TypeScript
"""""""""""""""""""""

*   JavaScript security queries using the :code:`response` threat model now track promise-wrapped client response data into promise fulfillment values. This may improve results for queries such as :code:`js/xss` when response data is consumed through :code:`.then(...)` chains.
*   The route object returned by Vue Router's :code:`useRoute()` Composition API is now recognized as a client-side remote flow source, covering its :code:`query`, :code:`params`, :code:`path`, :code:`fullPath`, and :code:`hash` members. These members are additionally reported under the corresponding :code:`browser-url-query`, :code:`browser-url-path`, and :code:`browser-url-fragment` threat models.
*   Added flow models for Vue's :code:`ref`, :code:`shallowRef`, :code:`toRef`, :code:`reactive`, and :code:`computed` Composition API helpers.
*   Added support for treating declared :code:`inputs` properties in Sails Action2 controller files as remote flow sources. This may improve results for security queries such as :code:`js/path-injection`.

Ruby
""""

*   Removed library input to vendored gems from the set of taint sources. This should reduce false positives for :code:`rb/polynomial-redos`, :code:`rb/regex/badly-anchored-regexp`, :code:`rb/unsafe-code-construction`, :code:`rb/html-constructed-from-input`, and :code:`rb/shell-command-constructed-from-input` whenever vendoring is used.

GitHub Actions
""""""""""""""

*   GitHub Actions analysis now recognizes untrusted data in :code:`github.event.merge_group` for workflows triggered by the :code:`merge_group` event.
