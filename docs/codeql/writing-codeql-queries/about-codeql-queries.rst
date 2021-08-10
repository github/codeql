.. _about-codeql-queries:

About CodeQL queries
####################

CodeQL queries are used to analyze code for issues related to security, correctness, maintainability, and readability. 

Overview
********

CodeQL includes queries to find the most relevant and interesting problems for each supported language. You can also write custom queries to find specific issues relevant to your own project. The important types of query are:

- **Alert queries**: queries that highlight issues in specific locations in your code.
- **Path queries**: queries that describe the flow of information between a source and a sink in your code.

You can add custom queries to :doc:`QL packs <../codeql-cli/about-ql-packs>` to analyze your projects with "`Code scanning <https://docs.github.com/en/code-security/secure-coding/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning>`__", use them to analyze a database with the ":ref:`CodeQL CLI <codeql-cli>`," or you can contribute to the standard CodeQL queries in our `open source repository on GitHub <https://github.com/github/codeql>`__.

This topic is a basic introduction to query files. You can find more information on writing queries for specific programming languages in the ":ref:`CodeQL language guides <codeql-language-guides>`," and detailed technical information about QL in the ":ref:`QL language reference <ql-language-reference>`."
For more information on how to format your code when contributing queries to the GitHub repository, see the `CodeQL style guide <https://github.com/github/codeql/blob/main/docs/ql-style-guide.md>`__.

Basic query structure
*********************

:ref:`Queries <queries>` written with CodeQL have the file extension ``.ql``, and contain a ``select`` clause. Many of the existing queries include additional optional information, and have the following structure:

.. code-block:: ql

    /**
     * 
     * Query metadata
     *
     */

    import /* ... CodeQL libraries or modules ... */

    /* ... Optional, define CodeQL classes and predicates ... */

    from /* ... variable declarations ... */
    where /* ... logical formula ... */
    select /* ... expressions ... */

The following sections describe the information that is typically included in a query file for alerts. Path queries are discussed in more detail in ":doc:`Creating path queries <creating-path-queries>`." 

Query metadata
==============

Query metadata is used to identify your custom queries when they are added to the GitHub repository or used in your analysis. Metadata provides information about the query's purpose, and also specifies how to interpret and display the query results. For a full list of metadata properties, see ":doc:`Metadata for CodeQL queries <metadata-for-codeql-queries>`." The exact metadata requirement depends on how you are going to run your query:

- If you are contributing a query to the GitHub repository, please read the `query metadata style guide <https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md>`__. 
- If you are adding a custom query to a query pack for analysis using LGTM , see `Writing custom queries to include in LGTM analysis <https://lgtm.com/help/lgtm/writing-custom-queries>`__.
- If you are analyzing a database using the :ref:`CodeQL CLI <codeql-cli>`, your query metadata must contain ``@kind``.
- If you are running a query in the query console on LGTM or with the CodeQL extension for VS Code, metadata is not mandatory. However, if you want your results to be displayed as either an 'alert' or a 'path', you must specify the correct ``@kind`` property, as explained below. For more information, see `Using the query console <https://lgtm.com/help/lgtm/using-query-console>`__ on LGTM.com and ":ref:`Analyzing your projects <analyzing-your-projects>`" in the CodeQL for VS Code help.

.. pull-quote:: 

    Note

    Queries that are contributed to the open source repository, added to a query pack in LGTM, or used to analyze a database with the :ref:`CodeQL CLI <codeql-cli>` must have a query type (``@kind``) specified. The ``@kind`` property indicates how to interpret and display the results of the query analysis:

    - Alert query metadata must contain ``@kind problem`` to identify the results as a simple alert.
    - Path query metadata must contain ``@kind path-problem`` to identify the results as an alert documented by a sequence of code locations.
    - Diagnostic query metadata must contain ``@kind diagnostic`` to identify the results as troubleshooting data about the extraction process.
    - Summary query metadata must contain ``@kind metric`` and ``@tags summary`` to identify the results as summary metrics for the CodeQL database.

    When you define the ``@kind`` property of a custom query you must also ensure that the rest of your query has the correct structure in order to be valid, as described below.

Import statements
=================

Each query generally contains one or more ``import`` statements, which define the :ref:`libraries <library-modules>` or :ref:`modules <modules>` to import into the query. Libraries and modules provide a way of grouping together related :ref:`types <types>`, :ref:`predicates <predicates>`, and other modules. The contents of each library or module that you import can then be accessed by the query. 
Our `open source repository on GitHub <https://github.com/github/codeql>`__ contains the standard CodeQL libraries for each supported language.   

When writing your own alert queries, you would typically import the standard library for the language of the project that you are querying, using ``import`` followed by a language:

- C/C++: ``cpp``
- C#: ``csharp``
- Go: ``go``
- Java: ``java``
- JavaScript/TypeScript: ``javascript``
- Python: ``python``

There are also libraries containing commonly used predicates, types, and other modules associated with different analyses, including data flow, control flow, and taint-tracking. In order to calculate path graphs, path queries require you to import a data flow library into the query file. For more information, see ":doc:`Creating path queries <creating-path-queries>`."

You can explore the contents of all the standard libraries in the `CodeQL library reference documentation <https://codeql.github.com/codeql-standard-libraries/>`__ or in the `GitHub repository <https://github.com/github/codeql>`__.

Optional CodeQL classes and predicates
--------------------------------------

You can customize your analysis by defining your own predicates and classes in the query. For further information, see :ref:`Defining a predicate <defining-a-predicate>` and :ref:`Defining a class <defining-a-class>`. 

From clause
===========

The ``from`` clause declares the variables that are used in the query. Each declaration must be of the form ``<type> <variable name>``. 
For more information on the available :ref:`types <types>`, and to learn how to define your own types using :ref:`classes <classes>`, see the :ref:`QL language reference <ql-language-reference>`.

Where clause
============

The ``where`` clause defines the logical conditions to apply to the variables declared in the ``from`` clause to generate your results. This clause uses :ref:`aggregations <aggregations>`, :ref:`predicates <predicates>`, and logical :ref:`formulas <formulas>` to limit the variables of interest to a smaller set, which meet the defined conditions. 
The CodeQL libraries group commonly used predicates for specific languages and frameworks. You can also define your own predicates in the body of the query file or in your own custom modules, as described above.

Select clause
=============

The ``select`` clause specifies the results to display for the variables that meet the conditions defined in the ``where`` clause. The valid structure for the select clause is defined by the ``@kind`` property specified in the metadata. 

Select clauses for alert queries (``@kind problem``) consist of two 'columns', with the following structure::

    select element, string

- ``element``: a code element that is identified by the query, which defines where the alert is displayed.
- ``string``: a message, which can also include links and placeholders, explaining why the alert was generated. 

You can modify the alert message defined in the final column of the ``select`` statement to give more detail about the alert or path found by the query using links and placeholders. For more information, see ":doc:`Defining the results of a query <defining-the-results-of-a-query>`." 

Select clauses for path queries (``@kind path-problem``) are crafted to display both an alert and the source and sink of an associated path graph. For more information, see ":doc:`Creating path queries <creating-path-queries>`."

Select clauses for diagnostic queries (``@kind diagnostic``) and summary metric queries (``@kind metric`` and ``@tags summary``) have different requirements. For examples, see the `diagnostic queries <https://github.com/github/codeql/search?q=%22%40kind+diagnostic%22>`__ and the `summary metric queries <https://github.com/github/codeql/search?q=%22%40kind+metric%22+%22%40tags+summary%22>`__  in the CodeQL repository.

Viewing the standard CodeQL queries
***********************************

One of the easiest ways to get started writing your own queries is to modify an existing query. To view the standard CodeQL queries, or to try out other examples, visit the `CodeQL <https://github.com/github/codeql>`__ and `CodeQL for Go <https://github.com/github/codeql-go>`__ repositories on GitHub. 

You can also find examples of queries developed to find security vulnerabilities and bugs in open source software projects on the `GitHub Security Lab website <https://securitylab.github.com/research>`__ and in the associated `repository <https://github.com/github/securitylab>`__.

Contributing queries
********************

Contributions to the standard queries and libraries are very welcome. For more information, see our `contributing guidelines <https://github.com/github/codeql/blob/main/CONTRIBUTING.md>`__.
If you are contributing a query to the open source GitHub repository, writing a custom query for LGTM, or using a custom query in an analysis with the CodeQL CLI, then you need to include extra metadata in your query to ensure that the query results are interpreted and displayed correctly. See the following topics for more information on query metadata:

-  ":doc:`Metadata for CodeQL queries <metadata-for-codeql-queries>`"
-  `Query metadata style guide on GitHub <https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md>`__

Query contributions to the open source GitHub repository may also have an accompanying query help file to provide information about their purpose for other users. For more information on writing query help, see the `Query help style guide on GitHub <https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md>`__ and the ":doc:`Query help files <query-help-files>`."

Query help files
****************

When you write a custom query, we also recommend that you write a query help file to explain the purpose of the query to other users. For more information, see the `Query help style guide <https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md>`__ on GitHub, and the ":doc:`Query help files <query-help-files>`." 
