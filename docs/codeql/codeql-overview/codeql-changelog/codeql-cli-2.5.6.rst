.. _codeql-cli-2.5.6:

=========================
CodeQL 2.5.6 (2021-06-22)
=========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.5.6 runs a total of 266 security queries when configured with the Default suite (covering 114 CWE). The Extended suite enables an additional 57 queries (covering 28 more CWE). 3 security queries have been added with this release.

CodeQL CLI
----------

New Features
~~~~~~~~~~~~

*   :code:`codeql database create` (and the plumbing commands it comprises)
    now supports creating databases for a source tree with several languages while tracing a single build. This is enabled by a new
    :code:`--db-cluster` option. Once created, the multiple databases must be
    *analyzed* one by one.
    
*   :code:`codeql database create` and :code:`codeql database init` now accept an
    :code:`--overwrite` argument which will lead existing CodeQL databases to be overwritten.
    
*   :code:`codeql database analyze` now supports "diagnostic" queries (tagged
    :code:`@kind diagnostic`), which are intended to report information about the analysis process itself rather than problems with the analyzed code. The results of these queries will be summarized in a table printed to the terminal when :code:`codeql database analyze` finishes.
    
    They are also included in the analysis results in SARIF output formats as `notification objects <https://docs.oasis-open.org/sarif/sarif/v2.1.0/os/sarif-v2.1.0-os.html#_Toc34317894>`__ so they can be displayed by subsequent tooling such as the Code Scanning user interface.

    *   For SARIF v2.1.0, a reporting descriptor object for each diagnostic query is output to output to
        :code:`runs[].tool.driver.notifications`, or
        :code:`runs[].tool.extensions[].notifications` if running with
        :code:`--sarif-group-rules-by-pack`. A rule object for each diagnostic query is output to :code:`runs[].resources[].rules` for SARIF v2, or to
        :code:`runs[].rules` for SARIF v1.
        
    *   Results of diagnostic queries are exported to the
        :code:`runs[].invocations[].toolExecutionNotifications` property in SARIF v2.1.0, the :code:`runs[].invocations[].toolNotifications` property in SARIF v2, and the :code:`runs[].toolNotifications` property in SARIF v1.

    SARIF v2.1.0 output will now also contain version information for query packs in :code:`runs[].tool.extensions[].semanticVersion`, if the Git commit the queries come from is known.
    
*   :code:`codeql github upload-results` has a :code:`--checkout-path` option which will attempt to automatically configure upload target parameters.
    When this is given, the :code:`--commit` option will be taken from the HEAD of the checkout Git repository, and if there is precisely one remote configured in the local repository, the :code:`--repository` and
    :code:`--github-url` options will also be automatically configured.
    
*   The CodeQL C++ extractor includes beta support for C++20.
    This is only available when building codebases with GCC on Linux.
    C++20 modules are **not** supported.
    
