4. Save the query in its default location (a temporary "Quick Queries" directory under the workspace for ``GitHub.vscode-codeql/quick-queries``).

#. Right-click in the query window and select **CodeQL: Run Query**. (Alternatively, run the command from the Command Palette.)

   The query will take a few moments to return results. When the query completes, the results are displayed in a CodeQL Query Results window, alongside the query window.

   The query results are listed in two columns, corresponding to the two expressions in the ``select`` clause of the query. The first column corresponds to the expression |expression| and is linked to the location in the source code of the project where |expression| occurs. The second column is the alert message.