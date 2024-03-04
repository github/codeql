.. _codeql-cli-2.5.5:

=========================
CodeQL 2.5.5 (2021-05-17)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.5.5 runs a total of 248 security queries when configured with the Default suite (covering 112 CWE). The Extended suite enables an additional 72 queries (covering 26 more CWE). 2 security queries have been added with this release.

CodeQL CLI
----------

Potentially Breaking Changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*   When scanning the disk for QL packs and extractors, directories of the form :code:`.../SOMETHING/SOMETHING.testproj` (where the two
    :code:`SOMETHING` are identical) will now be ignored.  Names of this form are used by :code:`codeql test run` for ephemeral test databases, which can sometimes contain files that confuse QL compilations.

Bug Fixes
~~~~~~~~~

*   When using the :code:`--sarif-group-rules-by-pack` flag to place the SARIF rule object for each query underneath its corresponding query pack in :code:`runs[].tool.extensions`, the :code:`rule` property of result objects can now be used to look up the rule within the :code:`rules` property of the appropriate query pack in :code:`runs[].tool.extensions`. Previously,
    rule lookup for result objects in the SARIF output was not well-defined when the :code:`--sarif-group-rules-by-pack` flag was passed.

New Features
~~~~~~~~~~~~

*   Query writers can now optionally use :code:`@severity` in place of
    :code:`@problem.severity` in the metadata for alert queries. SARIF consumers should continue to consume this severity information using the :code:`rule.defaultConfiguration.level` property for SARIF v2.1.0, and corresponding properties for other versions of SARIF. They should not depend on the value stored in the :code:`rule.properties` property bag, since this will contain either :code:`@problem.severity` or
    :code:`@severity` based on exactly what was written in the query metadata.
    
*   When exporting analysis results to SARIF v2.1.0, results and metric results now contain a `reporting descriptor reference object <https://docs.oasis-open.org/sarif/sarif/v2.1.0/csprd01/sarif-v2.1.0-csprd01.html#_Toc10541300>`__ that specifies the rule that produced them. For metric results, this new property replaces the :code:`metric` property.
    
*   :code:`codeql database analyze` now outputs a table that summarizes the results of metric queries that were part of the analysis. This can be suppressed by passing the :code:`--no-print-metrics-summary` flag.
    
