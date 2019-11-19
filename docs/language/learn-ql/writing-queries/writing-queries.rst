Writing CodeQL queries
######################

If you are familiar with CodeQL, you can modify the existing queries or write custom queries to analyze, improve, and secure your own projects. Get started by reading the information for query writers and viewing the examples provided below. 

Information for query writers
*****************************

.. toctree::
   :glob:
   :hidden:

   introduction-to-queries
   path-queries
   ../intro-to-data-flow
   select-statement
   ../locations
   

Visit `Learning CodeQL <https://help.semmle.com/QL/learn-ql/>`__ to find basic information about CodeQL. This includes information about the underlying query language QL, as well as help and advice on writing queries for specific programming languages. 
To learn more about the structure of query files, the key information to include when writing your own queries, and how to format them for clarity and consistency, see the following topics:

-  :doc:`Introduction to query files <introduction-to-queries>`–an introduction to the information contained in a basic query file.
-  :doc:`Constructing path queries <path-queries>`–a quick guide to structuring path queries to use in security research.
-  :doc:`Introduction to data flow analysis with CodeQL <../intro-to-data-flow>`–a brief introduction to modeling data flow using CodeQL.
-  :doc:`Defining 'select' statements <select-statement>`–further detail on developing query alert messages to provide extra information in your query results.
-  :doc:`Locations and strings for CodeQL entities <../locations>`–further detail on providing location information in query results. 
-  `CodeQL style guide on GitHub <https://github.com/Semmle/ql/blob/master/docs/ql-style-guide.md>`__–a guide to formatting your queries for consistency and clarity.

Viewing existing CodeQL queries
*******************************

The easiest way to get started writing your own queries is to modify an existing query. To see these queries, or to try out the CodeQL query cookbooks, visit `Exploring CodeQL queries <https://help.semmle.com/QL/ql-explore-queries.html>`__.
You can also find all the CodeQL queries in our `open source repository on GitHub <https://github.com/semmle/ql>`__. 

You can also find examples of queries developed to find security vulnerabilities and bugs in open-source software projects on the `GitHub Security Lab website <https://securitylab.github.com/research>`__ and in the associated `repository <https://github.com/github/security-lab>`__.

Contributing queries
********************

.. toctree::
   :glob:
   :hidden:

   query-metadata
   query-help

Contributions to the standard queries and libraries are very welcome–see our `contributing guidelines <https://github.com/Semmle/ql/blob/master/CONTRIBUTING.md>`__ for further information.
If you are contributing a query to the open source GitHub repository, writing a custom query for LGTM, or using a custom query in an analysis with our command-line tools, then you need to include extra metadata in your query to ensure that the query results are interpreted and displayed correctly. See the following topics for more information on query metadata:

.. TODO: Change "command-line tools" to a link to the CodeQL CLI? 

-  :doc:`Query metadata reference <query-metadata>`
-  `Query metadata style guide on GitHub <https://github.com/Semmle/ql/blob/master/docs/query-metadata-style-guide.md>`__

Query contributions to the open source GitHub repository may also have an accompanying query help file to provide information about their purpose for other users. For more information on writing query help, see the `Query help style guide on GitHub <https://github.com/Semmle/ql/blob/master/docs/query-help-style-guide.md>`__ and the :doc:`Query help reference <query-help>`.