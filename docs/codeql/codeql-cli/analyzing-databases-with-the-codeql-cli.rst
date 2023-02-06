.. _analyzing-databases-with-the-codeql-cli:

Analyzing databases with the CodeQL CLI
=======================================

.. pull-quote:: 
  This article was moved to "`Analyzing databases with the CodeQL CLI <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli>`__" on the `GitHub Docs <https://docs.github.com/en/code-security/codeql-cli>`__ site as of January 2023.
  
  .. include:: ../reusables/codeql-cli-articles-migration-note.rst

.. include:: ../reusables/codeql-cli-migration-toc-note.rst

* `Running codeql database analyze <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#running-codeql-database-analyze>`__
* `Specifying which queries to run in a CodeQL pack <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#specifying-which-queries-to-run-in-a-codeql-pack>`__
    * `Example query specifiers <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#example-query-specifiers>`__
* `Examples of running database analyses <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#examples-of-running-database-analyses>`__
    * `Running a CodeQL query pack <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#running-a-codeql-query-pack>`__
    * `Running a single query <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#running-a-single-query>`__
    * `Running all queries in a directory <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#running-all-queries-in-a-directory>`__
    * `Running a subset of queries in a CodeQL pack <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#running-a-subset-of-queries-in-a-codeql-pack>`__
    * `Running query suites <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#running-query-suites>`__
        * `Diagnostic and summary information <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#diagnostic-and-summary-information>`__
    * `Integrating a CodeQL pack into a code scanning workflow in GitHub <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#integrating-a-codeql-pack-into-a-code-scanning-workflow-in-github>`__
    * `Including query help for custom CodeQL queries in SARIF files <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#including-query-help-for-custom-codeql-queries-in-sarif-files>`__
* `Results <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/analyzing-databases-with-the-codeql-cli#results>`__
