4. Save the query in its default location (a temporary "Quick Queries" directory under the workspace for ``GitHub.vscode-codeql/quick-queries``).

#. Right-click in the query tab and select **CodeQL: Run Query on Selected Database**. (Alternatively, run the command from the Command Palette.)

   The query will take a few moments to return results. When the query completes, the results are displayed in a CodeQL Query Results view, next to the main editor view.

   The query results are listed in two columns, corresponding to the expressions in the ``select`` clause of the query. |result-col-1| The second column is the alert message.