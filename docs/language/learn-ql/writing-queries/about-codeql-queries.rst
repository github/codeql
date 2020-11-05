About CodeQL queries
####################

CodeQL queries are used to analyze code for issues related to security, correctness, maintainability, and readability. 

Overview
********

CodeQL includes queries to find the most relevant and interesting problems for each supported language. You can also write custom queries to find specific issues relevant to your own project. The important types of query are:

- **Alert queries**: queries that highlight issues in specific locations in your code.
- **Path queries**: queries that describe the flow of information between a source and a sink in your code.

You can add custom queries to `custom query packs <https://lgtm.com/help/lgtm/about-queries#what-are-query-packs>`__ to analyze your projects in `LGTM <https://lgtm.com>`__, use them to analyze a database with the "`CodeQL CLI <https://help.semmle.com/codeql/codeql-cli.html>`__," or you can contribute to the standard CodeQL queries in our `open source repository on GitHub <https://github.com/github/codeql>`__.

This topic is a basic introduction to query files. You can find more information on writing queries for specific programming languages `here <https://help.semmle.com/QL/learn-ql/>`__, and detailed technical information about QL in the `QL language reference <https://help.semmle.com/QL/ql-handbook/index.html>`__.
For more information on how to format your code when contributing queries to the GitHub repository, see the `CodeQL style guide <https://github.com/github/codeql/blob/main/docs/ql-style-guide.md>`__.

Basic query structure
*********************

`Queries <https://help.semmle.com/QL/ql-handbook/queries.html>`__ written with CodeQL have the file extension ``.ql``, and contain a ``select`` clause. Many of the existing queries include additional optional information, and have the following structure::

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

The following sections describe the information that is typically included in a query file for alerts. Path queries are discussed in more detail in ":doc:`Creating path queries <path-queries>`." 

Query metadata
==============

Query metadata is used to identify your custom queries when they are added to the GitHub repository or used in your analysis. Metadata provides information about the query's purpose, and also specifies how to interpret and display the query results. For a full list of metadata properties, see ":doc:`Metadata for CodeQL queries <query-metadata>`." The exact metadata requirement depends on how you are going to run your query:

- If you are contributing a query to the GitHub repository, please read the `query metadata style guide <https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md>`__. 
- If you are adding a custom query to a query pack for analysis using LGTM , see `Writing custom queries to include in LGTM analysis <https://lgtm.com/help/lgtm/writing-custom-queries>`__.
- If you are analyzing a database using the `CodeQL CLI <https://help.semmle.com/codeql/codeql-cli.html>`__, your query metadata must contain ``@kind``.
- If you are running a query in the query console on LGTM or with the CodeQL extension for VS Code, metadata is not mandatory. However, if you want your results to be displayed as either an 'alert' or a 'path', you must specify the correct ``@kind`` property, as explained below. For more information, see `Using the query console <https://lgtm.com/help/lgtm/using-query-console>`__ on LGTM.com and "`Analyzing your projects <https://help.semmle.com/codeql/codeql-for-vscode/procedures/using-extension.html>`__" in the CodeQL for VS Code help.

.. pull-quote:: 

    Note

    Queries that are contributed to the open source repository, added to a query pack in LGTM, or used to analyze a database with the `CodeQL CLI <https://help.semmle.com/codeql/codeql-cli.html>`__ must have a query type (``@kind``) specified. The ``@kind`` property indicates how to interpret and display the results of the query analysis:

    - Alert query metadata must contain ``@kind problem``.
    - Path query metadata must contain ``@kind path-problem``.

    When you define the ``@kind`` property of a custom query you must also ensure that the rest of your query has the correct structure in order to be valid, as described below.

Import statements
=================

Each query generally contains one or more ``import`` statements, which define the `libraries <https://help.semmle.com/QL/ql-handbook/modules.html#library-modules>`__ or `modules <https://help.semmle.com/QL/ql-handbook/modules.html>`__ to import into the query. Libraries and modules provide a way of grouping together related `types <https://help.semmle.com/QL/ql-handbook/types.html>`__, `predicates <https://help.semmle.com/QL/ql-handbook/predicates.html>`__, and other modules. The contents of each library or module that you import can then be accessed by the query. 
Our `open source repository on GitHub <https://github.com/github/codeql>`__ contains the standard CodeQL libraries for each supported language.   

When writing your own alert queries, you would typically import the standard library for the language of the project that you are querying, using ``import`` followed by a language:

- C/C++: ``cpp``
- C#: ``csharp``
- Go: ``go``
- Java: ``java``
- JavaScript/TypeScript: ``javascript``
- Python: ``python``

There are also libraries containing commonly used predicates, types, and other modules associated with different analyses, including data flow, control flow, and taint-tracking. In order to calculate path graphs, path queries require you to import a data flow library into the query file. For more information, see ":doc:`Creating path queries <path-queries>`."

You can explore the contents of all the standard libraries in the `CodeQL library reference documentation <https://help.semmle.com/QL/ql-libraries.html>`__ or in the `GitHub repository <https://github.com/github/codeql>`__.

Optional CodeQL classes and predicates
--------------------------------------

You can customize your analysis by defining your own predicates and classes in the query. For further information, see `Defining a predicate <https://help.semmle.com/QL/ql-handbook/predicates.html#defining-a-predicate>`__ and `Defining a class <https://help.semmle.com/QL/ql-handbook/types.html#defining-a-class>`__. 

From clause
===========

The ``from`` clause declares the variables that are used in the query. Each declaration must be of the form ``<type> <variable name>``. 
For more information on the available `types <https://help.semmle.com/QL/ql-handbook/types.html>`__, and to learn how to define your own types using `classes <https://help.semmle.com/QL/ql-handbook/types.html#classes>`__, see the `QL language reference <https://help.semmle.com/QL/ql-handbook/index.html>`__.

Where clause
============

The ``where`` clause defines the logical conditions to apply to the variables declared in the ``from`` clause to generate your results. This clause uses `aggregations <https://help.semmle.com/QL/ql-handbook/expressions.html#aggregations>`__, `predicates <https://help.semmle.com/QL/ql-handbook/predicates.html>`__, and logical `formulas <https://help.semmle.com/QL/ql-handbook/formulas.html>`_ to limit the variables of interest to a smaller set, which meet the defined conditions. 
The CodeQL libraries group commonly used predicates for specific languages and frameworks. You can also define your own predicates in the body of the query file or in your own custom modules, as described above.

Select clause
=============

The ``select`` clause specifies the results to display for the variables that meet the conditions defined in the ``where`` clause. The valid structure for the select clause is defined by the ``@kind`` property specified in the metadata. 

Select clauses for alert queries (``@kind problem``) consist of two 'columns', with the following structure::

    select element, string

- ``element``: a code element that is identified by the query, which defines where the alert is displayed.
- ``string``: a message, which can also include links and placeholders, explaining why the alert was generated. 

You can modify the alert message defined in the final column of the ``select`` statement to give more detail about the alert or path found by the query using links and placeholders. For more information, see ":doc:`Defining the results of a query <select-statement>`." 

Select clauses for path queries (``@kind path-problem``) are crafted to display both an alert and the source and sink of an associated path graph. For more information, see ":doc:`Creating path queries <path-queries>`."

Viewing the standard CodeQL queries
***********************************

One of the easiest ways to get started writing your own queries is to modify an existing query. To view the standard CodeQL queries, or to try out other examples, visit the `CodeQL <https://github.com/github/codeql>`__ and `CodeQL for Go <https://github.com/github/codeql-go>`__ repositories on GitHub. 

You can also find examples of queries developed to find security vulnerabilities and bugs in open source software projects on the `GitHub Security Lab website <https://securitylab.github.com/research>`__ and in the associated `repository <https://github.com/github/security-lab>`__.

Contributing queries
********************

Contributions to the standard queries and libraries are very welcome. For more information, see our `contributing guidelines <https://github.com/github/codeql/blob/main/CONTRIBUTING.md>`__.
If you are contributing a query to the open source GitHub repository, writing a custom query for LGTM, or using a custom query in an analysis with the CodeQL CLI, then you need to include extra metadata in your query to ensure that the query results are interpreted and displayed correctly. See the following topics for more information on query metadata:

-  ":doc:`Metadata for CodeQL queries <query-metadata>`"
-  `Query metadata style guide on GitHub <https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md>`__

Query contributions to the open source GitHub repository may also have an accompanying query help file to provide information about their purpose for other users. For more information on writing query help, see the `Query help style guide on GitHub <https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md>`__ and the ":doc:`Query help files <query-help>`."

Query help files
****************

When you write a custom query, we also recommend that you write a query help file to explain the purpose of the query to other users. For more information, see the `Query help style guide <https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md>`__ on GitHub, and the ":doc:`Query help files <query-help>`." 
