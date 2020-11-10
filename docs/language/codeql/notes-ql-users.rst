Notes for legacy QL CLI users
=============================

If you've previously used the QL command-line tools (``odasa``), you'll notice a
few key differences when you use the new CodeQL products:

* "QL snapshots" are now called :ref:`CodeQL databases <codeql-database>`. 
* The process of creating a CodeQL database is much simpler and more streamlined.
  There's no need to create ``projects`` or ``snapshots``---just check out the
  code and build it using the CodeQL CLI ``codeql database create`` command.
* Queries are run against CodeQL databases using the CodeQL CLI ``codeql
  database analyze`` command.

For more information, see ":doc:`Creating CodeQL databases
<codeql-cli/procedures/creating-codeql-databases>`" and 
":doc:`Analyzing databases with the CodeQL CLI <codeql-cli/procedures/analyzing-databases-with-the-codeql-cli>`."
For detailed guidance about equivalent commands, see `Overview of common codeql-cli-reference
<#overview-of-common-codeql-cli-reference>`__ below.

.. _database-compatibiilty-notes:

Database compatibility notes
----------------------------

A CodeQL database created by the CodeQL CLI serves the same purpose as a QL
snapshot created using ``odasa``. They both contain a code database to query and
usually a source reference for results display. However, they are not identical
formats and, if you use the legacy QL tools alongside the CodeQL tools, you need
to make the adjustments described below.

.. pull-quote::

   Note

   .. include:: snippets/index-files-note.rst

Using existing QL snapshots created by the legacy CLI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Existing QL snapshots, exported using the legacy CLI, can be used with the new
CodeQL tools. Unzip the snapshot and treat the directory as a database. If it
was built with an earlier version of the legacy CLI, you may need to upgrade
the database using ``codeql database upgrade``. For more information, see the
:doc:`database upgrade reference documentation
<codeql-cli/commands/database-upgrade>`.

.. _database-compatibiilty-codeql-for-eclipse:

Preparing a CodeQL database for import into CodeQL for Eclipse
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CodeQL databases are not directly compatible with CodeQL for Eclipse.
However, you can "bundle" a CodeQL database into the required format by running::

  codeql database bundle --include-uncompressed-source -o <output-zip> <codeql-database>

The resulting database can be imported directly into CodeQL for Eclipse. For more
information about the ``bundle`` command, see the :doc:`database bundle reference documentation
<codeql-cli/commands/database-bundle>`.

Preparing a CodeQL database for upload into LGTM Enterprise
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CodeQL databases cannot be directly uploaded to an LGTM Enterprise instance.
For more information, see `Preparing CodeQL databases to upload to LGTM 
<https://help.semmle.com/lgtm-enterprise/admin/help/prepare-database-upload.html>`__
in the LGTM admin help.

Query suites
------------

CodeQL includes a new, more flexible, format for query suites. Legacy query
suite definitions are not compatible with the new CodeQL tools. For more
information about CodeQL query suites, see ":doc:`Creating CodeQL query suites
<codeql-cli/procedures/creating-codeql-query-suites>`." 

Overview of common commands 
---------------------------

If you're switching from the legacy ODASA CLI to the new CodeQL CLI, 
the table below shows which commands replace the most
common ODASA processes.

+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``odasa`` command                        | Corresponding ``codeql`` command                                                                  | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
+==========================================+===================================================================================================+=========================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
| ``bootstrap``                            | n/a                                                                                               | CodeQL analysis does not use ``project`` files during database creation. For more information about creating databases, see `Creating CodeQL databases <https://help.semmle.com/codeql/codeql-cli/procedures/creating-codeql-databases.html>`__.                                                                                                                                                                                                                        |
+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``addSnapshot``, ``addLatestSnapshot``   | n/a                                                                                               | To obtain the version of the code you want to analyze, just run your normal check-out commands.                                                                                                                                                                                                                                                                                                                                                                         |
+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``buildSnapshot``                        | `database create <https://help.semmle.com/codeql/codeql-cli/commands/database-create.html>`__     | When creating a CodeQL database, you specfiy build commands in the command line, rather than in a project file. For more information, see `Creating CodeQL databases <https://help.semmle.com/codeql/codeql-cli/procedures/creating-codeql-databases.html>`__.                                                                                                                                                                                                          |
+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``analyzeSnapshot``                      | `database analyze <https://help.semmle.com/codeql/codeql-cli/commands/database-analyze.html>`__   | For more information, see "`Analyzing databases with the CodeQL CLI <https://help.semmle.com/codeql/codeql-cli/procedures/analyzing-databases-with-the-codeql-cli.html>`__."                                                                                                                                                                                                                                                                                            |
+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``archiveSnapshot``                      | `database cleanup <https://help.semmle.com/codeql/codeql-cli/commands/database-cleanup.html>`__   | Use ``database cleanup`` to reduce the size of a CodeQL database by deleting temporary data.                                                                                                                                                                                                                                                                                                                                                                            |
+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``export``                               | `database bundle <https://help.semmle.com/codeql/codeql-cli/commands/database-bundle.html>`__     | You don't need to export databases before adding them to VS Code. However, you should "bundle" CodeQL databases before using them with LGTM Enterprise, CodeQL for Eclipse, or CodeQL for Visual Studio. For more information, see `Preparing CodeQL databases to upload to LGTM <https://help.semmle.com/lgtm-enterprise/admin/help/prepare-database-upload.html>`__ in the LGTM admin help and the `Database compatibility notes <#database-compatibility-notes>`__.  |
+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``prepareQueries``                       | `query compile <https://help.semmle.com/codeql/codeql-cli/commands/query-compile.html>`__         | Queries are compiled when you run ``database analyze`` and other query-running commands. You can speed up compilation by running ``query compile`` separately using more threads.                                                                                                                                                                                                                                                                                       |
+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``qltest``                               | `test run <https://help.semmle.com/codeql/codeql-cli/commands/test-run.html>`__                   | For more information about running regression tests, see "`Testing custom queries <https://help.semmle.com/codeql/codeql-cli/procedures/testing-custom-queries.html>`__."                                                                                                                                                                                                                                                                                               |
+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``runQuery``                             | `query run <https://help.semmle.com/codeql/codeql-cli/commands/query-run.html>`__                 | Use ``query run`` to quickly view results in your terminal. To generate interpreted results that can be viewed in source code, use ``database analyze``.                                                                                                                                                                                                                                                                                                                |
+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ``upgrade``                              | `database upgrade <https://help.semmle.com/codeql/codeql-cli/commands/database-upgrade.html>`__   | For more information, see "`Upgrading CodeQL databases <https://help.semmle.com/codeql/codeql-cli/procedures/upgrading-codeql-databases.html>`__."                                                                                                                                                                                                                                                                                                                      |
+------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
