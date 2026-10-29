.. _codeql-for-visual-studio-code:

CodeQL for Visual Studio Code
=============================

.. include:: ../reusables/vs-code-deprecation-note.rst

The CodeQL extension for Visual Studio Code adds rich language support for CodeQL and allows you to easily find problems in codebases.

- :doc:`About CodeQL for Visual Studio Code
  <about-codeql-for-visual-studio-code>`: CodeQL for Visual Studio
  Code is an extension that lets you write, run, and test CodeQL queries in Visual
  Studio Code.

- :doc:`Setting up CodeQL in Visual Studio Code
  <setting-up-codeql-in-visual-studio-code>`: You can install and configure 
  the CodeQL extension in Visual Studio Code.

- :doc:`Analyzing your projects
  <analyzing-your-projects>`: You can run queries on CodeQL
  databases and view the results in Visual Studio Code.

- :doc:`Exploring the structure of your source code
  <exploring-the-structure-of-your-source-code>`: 
  You can use the AST viewer to display the abstract syntax tree of a CodeQL database.

- :doc:`Exploring data flow with path queries
  <exploring-data-flow-with-path-queries>`: You can run CodeQL queries in
  VS Code to help you track the flow of data through a program, highlighting
  areas that are potential security vulnerabilities.  

- :doc:`Running CodeQL queries at scale with multi-repository variant analysis
  <running-codeql-queries-at-scale-with-mrva>`: You can run queries against groups
  of repositories on GitHub.com and view results in Visual Studio Code as each analysis
  finishes. 

- :doc:`Testing CodeQL queries in Visual Studio Code
  <testing-codeql-queries-in-visual-studio-code>`: You can run unit tests for
  CodeQL queries using the Visual Studio Code extension.

- :doc:`Working with CodeQL packs in Visual Studio Code
  <working-with-codeql-packs-in-visual-studio-code>`: You can view, create, and edit all types of CodeQL pack in Visual Studio Code.

- :doc:`Using the CodeQL model editor
  <using-the-codeql-model-editor>`: You can view, create, and edit CodeQL model packs using a dedicated editor.

- :doc:`Customizing settings
  <customizing-settings>`: You can edit the settings for the 
  CodeQL extension to suit your needs.

- :doc:`Troubleshooting CodeQL for Visual Studio Code
  <troubleshooting-codeql-for-visual-studio-code>`: You can use the detailed 
  information written to the extension's log files if you need to troubleshoot problems with
  analysis of local CodeQL databases.

- :doc:`Troubleshooting variant analysis
  <troubleshooting-variant-analysis>`: You can use the detailed 
  information written to workflow log files in your controller repository if you need to
  troubleshoot problems with analysis of CodeQL databases stored on GitHub.com.

- :doc:`About telemetry in CodeQL for Visual Studio Code <about-telemetry-in-codeql-for-visual-studio-code>`: If you specifically opt in to permit GitHub to do so, GitHub will collect usage data and metrics for the purposes of helping the core developers to improve the CodeQL extension for VS Code.

.. toctree::
   :hidden:
   :titlesonly:

   about-codeql-for-visual-studio-code
   setting-up-codeql-in-visual-studio-code
   analyzing-your-projects
   exploring-the-structure-of-your-source-code
   exploring-data-flow-with-path-queries
   running-codeql-queries-at-scale-with-mrva
   testing-codeql-queries-in-visual-studio-code
   working-with-codeql-packs-in-visual-studio-code
   using-the-codeql-model-editor
   customizing-settings
   troubleshooting-codeql-for-visual-studio-code
   troubleshooting-variant-analysis
   about-telemetry-in-codeql-for-visual-studio-code
