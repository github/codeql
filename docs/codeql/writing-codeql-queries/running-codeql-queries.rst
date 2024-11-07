:tocdepth: 1

.. _running-codeql-queries:

.. meta::
   :description: Overview of how to run CodeQL queries locally, in GitHub, or in your CI system.
   :keywords: CodeQL, code analysis, CodeQL analysis, code scanning, GitHub code scanning, writing a new query, testing a new query, code scanning alerts

Running CodeQL queries
======================

There are several options available for running one or more CodeQL queries on a codebase. The best option depends on what your aims are.

Work through a CodeQL tutorial
------------------------------

If you're working through a CodeQL tutorial, the CodeQL extension for Visual Studio Code allows you to run the queries in the tutorial. Unless you want to run the query on a specific code base, it's easiest to run queries on one of the many CodeQL databases that are available on GitHub. To get started, see "`Installing CodeQL for Visual Studio Code <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/installing-codeql-for-vs-code>`__".

Develop a new CodeQL query
--------------------------

If you're developing a new query, the CodeQL extension for Visual Studio Code allows you to run a query and compare the results with previous runs as you refine the query. The extension also provides autocomplete suggestions, syntax highlighting, and other features that make it easier to write and debug queries. To get started, see "`Installing CodeQL for Visual Studio Code <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/installing-codeql-for-vs-code>`__".

When you're ready to test the query on a wide range of codebases, you can choose from the pre-defined sets of CodeQL databases or define a custom group of codebases to run the query against. For more information, see "`Running CodeQL queries at scale with multi-repository variant analysis <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/running-codeql-queries-at-scale-with-multi-repository-variant-analysis>`__".

Run your query against a specific codebase
-------------------------------------------

If the codebase that you want to run your query against doesn't have a CodeQL database, you can create one using the CodeQL CLI. For more information, see "`Setting up the CodeQL CLI <https://docs.github.com/en/code-security/codeql-cli/getting-started-with-the-codeql-cli/setting-up-the-codeql-cli>`__" and "`Preparing your code for CodeQL analysis <https://docs.github.com/en/code-security/codeql-cli/getting-started-with-the-codeql-cli/preparing-your-code-for-codeql-analysis>`__".

Once you have created a CodeQL database, you can make the database available to the CodeQL extension in Visual Studio Code, or run the query using the CodeQL CLI. For more information, see "`Analyzing your code with CodeQL queries <https://docs.github.com/en/code-security/codeql-cli/getting-started-with-the-codeql-cli/analyzing-your-code-with-codeql-queries>`__".

Run the standard CodeQL queries
-------------------------------

The easiest way to run the standard CodeQL queries on a repository hosted on the GitHub platform is to enable code scanning with CodeQL (this requires GitHub Actions to be enabled). When you enable default setup, you can choose from a default set of security queries or an extended set of security queries. Any results are shown as code scanning alerts on the **Security** tab of the repository. For more information, see "`Configuring default setup for code scanning <https://docs.github.com/en/code-security/code-scanning/enabling-code-scanning/configuring-default-setup-for-code-scanning>`__".

If you want to run the standard CodeQL queries on a repository where GitHub Actions are disabled, you can use the CodeQL CLI in your existing CI system. For more information, see "`Using code scanning with your existing CI system <https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/using-code-scanning-with-your-existing-ci-system>`__".
