CodeQL CLI reference
====================

Find detailed information about the CodeQL commands, as well the files you can
use or generate when executing CodeQL processes. 

.. toctree::
   :titlesonly:
   :hidden:

   about-ql-packs
   query-reference-files
   sarif-output
   specifying-command-options-in-a-codeql-configuration-file
   exit-codes


- :doc:`About QL packs <about-ql-packs>`: QL packs are used to organize the files used in CodeQL analysis. They
  contain queries, library files, query suites, and important metadata. 
- :doc:`Query reference files <query-reference-files>`: A query reference file is text file that defines the location of one query to test.
- :doc:`SARIF output <sarif-output>`: CodeQL supports SARIF as an output format for sharing static analysis results.
- :doc:`Specifying command options in a CodeQL configuration file <specifying-command-options-in-a-codeql-configuration-file>`: 
  You can save default or frequently used options for your commands in a per-user configuration file.
- :doc:`Exit codes <exit-codes>`: The CodeQL CLI reports the status of each command it runs as an exit code.
  This exit code provides information for subsequent commands or for other tools that rely on the CodeQL CLI.

.. _cli-commands:

CLI commands
------------

The following links provide detailed information about each CodeQL CLI command,
including its usage and options. For information about the terms used in these
pages, see the ":doc:`CodeQL glossary <codeql-overview:codeql-glossary>`."

.. include:: ../commands-toc.rst
