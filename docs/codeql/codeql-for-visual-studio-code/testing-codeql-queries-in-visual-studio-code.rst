.. _testing-codeql-queries-in-visual-studio-code:

Testing CodeQL queries in Visual Studio Code
============================================

You can run unit tests for CodeQL queries using the Visual Studio Code extension.

About testing queries in VS Code
---------------------------------

To ensure that your CodeQL queries produce the expected results, you can run tests that compare the expected query results with the actual results.

The CodeQL extension automatically prompts VS Code to install the Test Explorer extension as a dependency. The Test Explorer displays any workspace folders with a name ending in ``-tests`` and provides a UI for exploring and running tests in those folders.

For more information about how CodeQL tests work, see ":ref:`Testing custom queries <testing-custom-queries>`" in the CLI help.

Testing the results of your queries
-----------------------------------

1. Open the Test Explorer view in the sidebar.

   .. image:: ../images/codeql-for-visual-studio-code/open-test-explorer.png
      :width: 350
      :alt: Open the Test Explorer view

2. To run a specific test, hover over the file or folder name and click the play button. To run all tests in your workspace, click the play button at the top of the view. If a test takes too long to run, you can click the stop button at the top of the view to cancel the test.
3. The icons show whether a test passed or failed. If it failed, right-click the failed test and click **CodeQL: Show Test Output Differences** to display the differences between the expected output and the actual output.

   .. image:: ../images/codeql-for-visual-studio-code/show-test-diff.png
      :width: 400
      :alt: Show test output differences

4. Compare the results. If you want to update the test with the actual output, click **CodeQL: Accept Test Output**.

Monitoring the performance of your queries
------------------------------------------

Query performance is important when you want to run a query on large databases, or as part of your continuous integration system. 

.. include:: ../reusables/running-queries-debug.rst

When a query is evaluated, the query server caches the predicates that it calculates. So when you want to compare the performance of two evaluations, you should clear the query server's cache before each run (**CodeQL: Clear Cache** command). This ensures that you're comparing equivalent data.

For more information, see ":ref:`Troubleshooting query performance <troubleshooting-query-performance>`" and ":ref:`Evaluation of QL programs <evaluation-of-ql-programs>`."


Further reading
----------------

* ":ref:`Testing custom queries <testing-custom-queries>`"
