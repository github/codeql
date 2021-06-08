:tocdepth: 1

.. _about-codeql-for-visual-studio-code:

About CodeQL for Visual Studio Code
=================================================

CodeQL for Visual Studio Code is an extension that lets you write, run, and test CodeQL queries in Visual Studio Code.

Features
----------

CodeQL for Visual Studio Code provides an easy way to run queries from the large, open source repository of `CodeQL security queries <https://github.com/github/codeql>`__.
With these queries, or your own custom queries, you can analyze databases generated from source code to find errors and security vulnerabilities.
The Results view shows the flow of data through the results of path queries, which is essential for triaging security results.

The CodeQL extension also adds a **CodeQL** sidebar view to VS Code. This contains a list of databases, and an overview of the queries that you have run in the current session.

The extension provides standard `IntelliSense <https://code.visualstudio.com/docs/editor/intellisense>`__
features for query files (extension ``.ql``) and library files (extension ``.qll``) that you open in the Visual Studio Code editor.

- Syntax highlighting
- Right-click options (such as **Go To Definition**)
- Autocomplete suggestions
- Hover information

You can also use the VS Code **Format Document** command to format your code according to the `CodeQL style guide <https://github.com/github/codeql/blob/main/docs/ql-style-guide.md>`__.

Data and telemetry
-------------------

If you specifically opt in to permit GitHub to do so, GitHub will collect usage data and metrics for the purposes of helping the core developers to improve the CodeQL extension for VS Code.
For more information, see ":doc:`About telemetry in CodeQL for Visual Studio Code <about-telemetry-in-codeql-for-visual-studio-code>`."

Further reading
-------------------

- ":doc:`Setting up CodeQL in Visual Studio Code <setting-up-codeql-in-visual-studio-code>`"
- ":doc:`Analyzing your projects <analyzing-your-projects>`"