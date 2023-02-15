.. _creating-codeql-query-suites:

Creating CodeQL query suites
============================

.. pull-quote:: 
  This article was moved to "`Creating CodeQL query suites <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-query-suites>`__" on the `GitHub Docs <https://docs.github.com/en/code-security/codeql-cli>`__ site as of January 2023.
  
  .. include:: ../reusables/codeql-cli-articles-migration-note.rst

.. include:: ../reusables/codeql-cli-migration-toc-note.rst

* `Locating queries to add to a query suite <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-query-suites#locating-queries-to-add-to-a-query-suite>`__
* `Filtering the queries in a query suite <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-query-suites#filtering-the-queries-in-a-query-suite>`__
    * `Examples of filtering which queries are run <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-query-suites#examples-of-filtering-which-queries-are-run>`__
* `Reusing existing query suite definitions <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-query-suites#reusing-existing-query-suite-definitions>`__
    * `Reusability Examples <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-query-suites#reusability-examples>`__
* `Naming a query suite <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-query-suites#naming-a-query-suite>`__
* `Saving a query suite <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-query-suites#saving-a-query-suite>`__
* `Specifying well-known query suites <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-query-suites#specifying-well-known-query-suites>`__ 
* `Using query suites with CodeQL <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-query-suites#using-query-suites-with-codeql>`__  