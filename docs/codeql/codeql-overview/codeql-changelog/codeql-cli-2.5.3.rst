.. _codeql-cli-2.5.3:

=========================
CodeQL 2.5.3 (2021-04-30)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.5.3 runs a total of 239 security queries when configured with the Default suite (covering 108 CWE). The Extended suite enables an additional 79 queries (covering 26 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Ensure the correct URL is generated during :code:`codeql github upload-results` for GitHub Enterprise Server.

New Features
~~~~~~~~~~~~

*   When tracing a C/C++ build, the C compiler entries in compiler-settings must now specify :code:`order compiler,extractor`. The default configuration already does this, so no change is necessary if using the default configuration.
    
*   :code:`codeql database analyze` and :code:`codeql database interpret-results` now report the results of summary metric queries in the
    :code:`<run>.properties.metricResults` property of the SARIF output.
    Summary metric queries describe metrics about the code analyzed by CodeQL. They are identified by the query metadata :code:`@kind metric` and
    :code:`@tag summary`.
    For example, see the `lines of code summary metric query for C++ <https://github.com/github/codeql/blob/main/cpp/ql/src/Summary/LinesOfCode.ql>`__.
    
*   :code:`codeql database analyze` and :code:`codeql database interpret-results` now calculate an
    \ `automation ID <https://docs.oasis-open.org/sarif/sarif/v2.1.0/cs01/sarif-v2.1.0-cs01.html#_Toc16012482>`__ and add it to the resulting SARIF. In SARIF v2.1.0, this field is
    :code:`runs[].automationDetails.id`.  In SARIF v2, this field is
    :code:`runs[].automationLogicalId`. In SARIF v1, this field is
    :code:`runs[].automationId`. By default, this automation ID will be derived from the database language and the operating system of the machine that performed the run. It can be set explicitly using a new
    :code:`--sarif-category` option.
    
*   In query metadata, :code:`@kind alert` and :code:`@kind path-alert` are now recognized as (more accurate) synonyms of :code:`@kind problem` and
    :code:`@kind path-problem`, respectively.
    
*   Diagnostic queries are now permitted by the metadata verifier. They are identified by :code:`@kind diagnostic` metadata. Currently the result patterns of diagnostic queries are not verified. This will change in a future CLI release.
    
