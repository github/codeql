.. _troubleshooting-codeql-for-visual-studio-code:

Troubleshooting CodeQL for Visual Studio Code
=============================================

You can use the detailed information written to the extension's log files if you need to troubleshoot problems.

About the log files
--------------------

Progress and error messages are displayed as notifications in the bottom right corner of the workspace.
These link to more detailed logs and error messages in the Output panel.
You can use the dropdown list to select the logs you need.

   .. image:: ../images/codeql-for-visual-studio-code/select-logs.png
      :alt: Select the logs in the Output view

Troubleshooting installation and configuration problems
------------------------------------------------------------

If you encounter any problems when installing and configuring the extension, check the CodeQL Extension Log to see general extension logging messages, including details about the CodeQL CLI and the commands invoked by the extension.

In particular, you can see the location of the CLI that is being used. This is useful if you want to see whether this is an extension-managed CLI or an external one.

If you use the extension-managed CLI, the extension checks for updates automatically (or with the **CodeQL: Check for CLI Updates** command) and prompts you to accept the updated version.
If you use an external CLI, you need to update it manually (when updates are necessary).

Exploring problems with queries and databases
----------------------------------------------

For details about compiling and running queries, as well as information about database upgrades, check the CodeQL Query Server log.

If you see behavior or errors that suggest problems, you can use the **CodeQL: Restart Query Server** command to restart the query server. This restarts the server without affecting your CodeQL session history.
You are most likely to need to restart the query server if you make external changes to files that the extension is using. For example, regenerating a CodeQL database that's open in VS Code. In addition to problems in the log, you might also see: errors in code highlighting, incorrect results totals, or duplicate notifications that a query is running.

To see the logs from running a particular query, right-click the query in the Query History and select **Show Query Log**.
If the log file is too large for the extension to open in the VS Code editor, the file will be displayed in your file explorer so you can open it with an external program.

Exploring problems with running tests
----------------------------------------------

To see more detailed output from running unit tests, open the CodeQL Tests log.
For more information about tests, see ":doc:`Testing CodeQL queries in Visual Studio Code <testing-codeql-queries-in-visual-studio-code>`."

Generating a bug report for GitHub
--------------------------------------

The CodeQL Language Server contains more advanced debug logs for CodeQL language maintainers. You should only need these to provide details in a bug report.
