.. _codeql-queries:

CodeQL queries
##############

CodeQL queries are used in code scanning analyses to find problems in source code, including potential security vulnerabilities.

.. toctree::
   :hidden:

   about-codeql-queries
   metadata-for-codeql-queries
   query-help-files
   defining-the-results-of-a-query
   providing-locations-in-codeql-queries
   about-data-flow-analysis
   creating-path-queries
   troubleshooting-query-performance
   debugging-data-flow-queries-using-partial-flow

- :doc:`About CodeQL queries <about-codeql-queries>`: CodeQL queries are used to analyze code for issues related to security, correctness, maintainability, and readability. 
- :doc:`Metadata for CodeQL queries <metadata-for-codeql-queries>`: Metadata tells users important information about CodeQL queries. You must include the correct query metadata in a query to be able to view query results in source code.
- :doc:`Query help files <query-help-files>`: Query help files tell users the purpose of a query, and recommend how to solve the potential problem the query finds.
- :doc:`Defining the results of a query <defining-the-results-of-a-query>`: You can control how analysis results are displayed in source code by modifying a query's ``select`` statement.
- :doc:`Providing locations in CodeQL queries <providing-locations-in-codeql-queries>`: CodeQL includes mechanisms for extracting the location of elements in a codebase. Use these mechanisms when writing custom CodeQL queries and libraries to help display information to users.
- :doc:`About data flow analysis <about-data-flow-analysis>`: Data flow analysis is used to compute the possible values that a variable can hold at various points in a program, determining how those values propagate through the program and where they are used. 
- :doc:`Creating path queries <creating-path-queries>`: You can create path queries to visualize the flow of information through a codebase.
- :doc:`Troubleshooting query performance <troubleshooting-query-performance>`: Improve the performance of your CodeQL queries by following a few simple guidelines.
- :doc:`Debugging data-flow queries using partial flow <debugging-data-flow-queries-using-partial-flow>`: If a data-flow query doesn't produce the results you expect to see, you can use partial flow to debug the problem..
