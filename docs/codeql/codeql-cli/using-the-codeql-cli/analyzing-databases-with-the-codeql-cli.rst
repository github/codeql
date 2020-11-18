.. _analyzing-databases-with-the-codeql-cli:

Analyzing databases with the CodeQL CLI
=======================================

To analyze a codebase, you run queries against a CodeQL
database extracted from the code.

CodeQL analyses produce :ref:`interpreted results
<interpret-query-results>` that can be displayed as alerts or paths in source code.
For information about writing queries to run with ``database analyze``, see
":doc:`Using custom queries with the CodeQL CLI <using-custom-queries-with-the-codeql-cli>`."

.. include:: ../../reusables/advanced-query-execution.rst

Before starting an analysis you must:

- :doc:`Set up the CodeQL CLI <getting-started-with-the-codeql-cli>` so that it can find the queries
  and libraries included in the CodeQL repository. 
- :doc:`Create a CodeQL database <creating-codeql-databases>` for the source 
  code you want to analyze. 


Running ``codeql database analyze``
------------------------------------

When you run ``database analyze``, it does two things:

#. Executes one or more query files, by running them over a CodeQL database.
#. Interprets the results, based on certain query metadata, so that alerts can be
   displayed in the correct location in the source code.

You can analyze a database by running the following command::

   codeql database analyze <database> <queries> --format=<format> --output=<output>

You must specify:

- ``<database>``: the path to the CodeQL database you want to analyze.

- ``<queries>``: the queries to run over your database. You can
  list one or more individual query files, specify a directory that will be
  searched recursively for query files, or name a query suite that defines a
  particular set of queries. For more information, see the :ref:`examples
  <database-analyze-examples>` below.

- ``--format``: the format of the results file generated during analysis. A
  number of different formats are supported, including CSV, :ref:`SARIF
  <sarif-file>`, and graph formats. For more information about CSV and SARIF,
  see `Results <#results>`__. To find out which other results formats are
  supported, see the `database analyze reference
  <../codeql-cli-manual/database-analyze.html>`__.

- ``--output``: the output path of the results file generated during analysis.

You can also specify:

- .. include:: ../../reusables/threads-query-execution.rst


.. pull-quote:: 

   Upgrading databases

   If the CodeQL queries you want to use are newer than the
   extractor used to create the database, then you may see a message telling you
   that your database needs to be upgraded when you run ``database analyze``.
   You can quickly upgrade a database by running the ``database upgrade``
   command. For more information, see ":doc:`Upgrading CodeQL databases
   <upgrading-codeql-databases>`."

For full details of all the options you can use when analyzing databases, see
the `database analyze reference documentation <../codeql-cli-manual/database-analyze.html>`__.

.. _database-analyze-examples:

Examples
--------

The following examples assume your CodeQL databases have been created in a
directory that is a sibling of your local copies of the CodeQL and CodeQL for Go
repositories.

Running a single query
~~~~~~~~~~~~~~~~~~~~~~

To run a single query over a JavaScript codebase, you could use the following
command from the directory containing your database::

   codeql database analyze <javascript-database> ../ql/javascript/ql/src/Declarations/UnusedVariable.ql --format=csv --output=js-analysis/js-results.csv 

This command runs a simple query that finds potential bugs related to unused
variables, imports, functions, or classes---it is one of the JavaScript
queries included in the CodeQL repository. You could run more than one query by
specifying a space-separated list of similar paths.

The analysis generates a CSV file (``js-results.csv``) in a new directory
(``js-analysis``).  

You can also run your own custom queries with the ``database analyze`` command.
For more information about preparing your queries to use with the CodeQL CLI,
see ":doc:`Using custom queries with the CodeQL CLI <using-custom-queries-with-the-codeql-cli>`."


Running LGTM.com query suites
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The CodeQL repository also includes query suites, which can be run over your
code as part of a broader code review. CodeQL query suites are ``.qls`` files
that use directives to select queries to run based on certain metadata
properties.

The query suites included in the CodeQL repository select the same set of
queries that are run by default on `LGTM.com <https://lgtm.com>`__. The queries
are selected to highlight the most relevant and useful results for each
language. 

The language-specific LGTM query suites are located at the following paths in
the CodeQL repository::

   ql/<language>/ql/src/codeql-suites/<language>-lgtm.qls

and at the following path in the CodeQL for Go repository::

   ql/src/codeql-suites/go-lgtm.qls

These locations are specified in the metadata included in the standard QL packs.
This means that CodeQL knows where to find the suite files automatically, and
you don't have to specify the full path on the command line when running an
analysis. For more information, see ":ref:`About QL packs <standard-ql-packs>`."

For example, to run the LGTM.com query suite on a C++ codebase (generating
results in the latest SARIF format), you would run::

   codeql database analyze <cpp-database> cpp-lgtm.qls --format=sarif-latest --output=cpp-analysis/cpp-results.sarif
   
For information about creating custom query suites, see ":doc:`Creating
CodeQL query suites <creating-codeql-query-suites>`."

Running all queries in a directory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can run all the queries located in a directory by providing the directory
path, rather than listing all the individual query files. Paths are searched
recursively, so any queries contained in subfolders will also be executed. 

.. pull-quote::

   Important

   You shouldn't specify the root of a :doc:`QL pack
   <../codeql-cli-reference/about-ql-packs>` when executing ``database analyze``
   as it contains some special queries that aren't designed to be used with
   the command. Rather, to run a wide range of useful queries, run one of the
   LGTM.com query suites. 
   
For example, to execute all Python queries contained in the ``Functions``
directory you would run::

   codeql database analyze <python-database> ../ql/python/ql/src/Functions/ --format=sarif-latest --output=python-analysis/python-results.sarif 

A SARIF results file is generated. Specifying ``--format=sarif-latest`` ensures
that the results are formatted according to the most recent SARIF specification
supported by CodeQL.


Results
-------

You can save analysis results in a number of different formats, including SARIF
and CSV.

The SARIF format is designed to represent the output of a broad range of static
analysis tools. For more information, see :doc:`SARIF output <../codeql-cli-reference/sarif-output>`.

If you choose to generate results in CSV format, then each line in the output file
corresponds to an alert. Each line is a comma-separated list with the following information:

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Property
     - Description
     - Example
   * - Name
     - Name of the query that identified the result. 
     - ``Inefficient regular expression``
   * - Description
     - Description of the query. 
     - ``A regular expression that requires exponential time to match certain 
       inputs can be a performance bottleneck, and may be vulnerable to 
       denial-of-service attacks.``
   * - Severity
     - Severity of the query.
     - ``error``
   * - Message
     - Alert message. 
     - ``This part of the regular expression may cause exponential backtracking 
       on strings containing many repetitions of '\\\\'.``
   * - Path
     - Path of the file containing the alert.
     - ``/vendor/codemirror/markdown.js``
   * - Start line
     - Line of the file where the code that triggered the alert begins.
     - ``617``
   * - Start column
     - Column of the start line that marks the start of the alert code. Not
       included when equal to 1.
     - ``32``
   * - End line
     - Line of the file where the code that triggered the alert ends. Not
       included when the same value as the start line.
     - ``64``
   * - End column
     - Where available, the column of the end line that marks the end of the 
       alert code. Otherwise the end line is repeated.
     - ``617``

Results files can be integrated into your own code-review or debugging
infrastructure. For example, SARIF file output can be used to highlight alerts
in the correct location in your source code using a SARIF viewer plugin for your
IDE. 

Further reading
---------------

- ":ref:`Analyzing your projects in CodeQL for VS Code <analyzing-your-projects>`"
