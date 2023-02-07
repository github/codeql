.. _creating-codeql-databases:

Creating CodeQL databases
=========================

.. pull-quote:: 
  This article was moved to "`Creating CodeQL databases <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases>`__" on the `GitHub Docs <https://docs.github.com/en/code-security/codeql-cli>`__ site as of January 2023.
  
  .. include:: ../reusables/codeql-cli-articles-migration-note.rst

.. include:: ../reusables/codeql-cli-migration-toc-note.rst

* `Running codeql database create <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#running-codeql-database-create>`__
* `Progress and results <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#progress-and-results>`__
* `Creating databases for non-compiled languages <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#creating-databases-for-non-compiled-languages>`__
      * `JavaScript and TypeScript <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#javascript-and-typescript>`__
      * `Python <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#python>`__
      * `Ruby <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#ruby>`__
* `Creating databases for compiled languages <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#creating-databases-for-compiled-languages>`__
    * `Detecting the build system <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#detecting-the-build-system>`__
    * `Specifying build commands <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#specifying-build-commands>`__
    * `Using indirect build tracing <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#using-indirect-build-tracing>`__
    * `Example of creating a CodeQL database using indirect build tracing <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#example-of-creating-a-codeql-database-using-indirect-build-tracing>`__
* `Downloading databases from GitHub.com <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases#downloading-databases-from-githubcom>`__