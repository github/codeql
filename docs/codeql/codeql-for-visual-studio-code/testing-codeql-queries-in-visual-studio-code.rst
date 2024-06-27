:tocdepth: 1

.. _testing-codeql-queries-in-visual-studio-code:

Testing CodeQL queries in Visual Studio Code
============================================

.. include:: ../reusables/vs-code-deprecation-note.rst

You can run unit tests for CodeQL queries using the Visual Studio Code extension. When you are sure that your query finds the results you want to identify, you can use variant analysis to run it at scale. For information on running analysis at scale across many CodeQL databases, see ":ref:`Running CodeQL queries at scale with multi-repository variant analysis <running-codeql-queries-at-scale-with-mrva>`."

About testing queries in VS Code
---------------------------------

To ensure that your CodeQL queries produce the expected results, you can run tests that compare the expected query results with the actual results.

The CodeQL extension automatically registers itself with the **Testing** view. The **Testing** view displays all tests found in your current workspace and provides a UI for exploring and running tests in your workspace.

For more information about how CodeQL tests work, see "`Testing custom queries <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/testing-custom-queries>`__" in the CLI help.

Testing the results of your queries
-----------------------------------

1. Open the **Testing** view in the sidebar.

   .. image:: ../images/codeql-for-visual-studio-code/open-testing-view.png
      :width: 350
      :alt: Open the Testing view

2. To run a specific test, hover over the file or folder name and click the play button. To run all tests in your workspace, click the play button at the top of the view. If a test takes too long to run, you can click the stop button at the top of the view to cancel the test.
3. The icons show whether a test passed or failed. If it failed, click the test in the **Test Results** panel to display the differences between the expected output and the actual output.

   .. image:: ../images/codeql-for-visual-studio-code/test-results-panel.png
      :width: 800
      :alt: View the Test Results panel

4. Compare the results. If you want to update the test with the actual output, right-click the test in the **Testing** view and click **Accept Test Output**.

   .. image:: ../images/codeql-for-visual-studio-code/accept-test-output.png
      :width: 400
      :alt: Acccept test output in the Testing view

Monitoring the performance of your queries
------------------------------------------

Query performance is important when you want to run a query on large databases, or as part of your continuous integration system. 

.. include:: ../reusables/running-queries-debug.rst

When a query is evaluated, the query server caches the predicates that it calculates. So when you want to compare the performance of two evaluations, you should clear the query server's cache before each run (**CodeQL: Clear Cache** command). This ensures that you're comparing equivalent data.

For more information, see ":ref:`Troubleshooting query performance <troubleshooting-query-performance>`" and ":ref:`Evaluation of QL programs <evaluation-of-ql-programs>`."


Further reading
----------------

* "`Testing custom queries <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/testing-custom-queries>`__"
