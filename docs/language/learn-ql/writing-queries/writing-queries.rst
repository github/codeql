CodeQL queries
##############

CodeQL queries are used in code scanning analyses to find problems in source code, including potential security vulnerabilities.

.. toctree::
   :hidden:

   introduction-to-queries
   query-metadata
   query-help
   select-statement
   ../locations
   ../intro-to-data-flow
   path-queries
   debugging-queries

- :doc:`About CodeQL queries <introduction-to-queries>`: CodeQL queries are used to analyze code for issues related to security, correctness, maintainability, and readability. 
- :doc:`Metadata for CodeQL queries <query-metadata>`: Metadata tells users important information about CodeQL queries. You must include the correct query metadata in a query to be able to view query results in source code.
- :doc:`Query help files <query-help>`: Query help files tell users the purpose of a query, and recommend how to solve the potential problem the query finds.
- :doc:`Defining the results of a query <select-statement>`: You can control how analysis results are displayed in source code by modifying a query's ``select`` statement.
- :doc:`Providing locations in CodeQL queries <../locations>`: CodeQL includes mechanisms for extracting the location of elements in a codebase. Use these mechanisms when writing custom CodeQL queries and libraries to help display information to users.
- :doc:`About data flow analysis <../intro-to-data-flow>`: Data flow analysis is used to compute the possible values that a variable can hold at various points in a program, determining how those values propagate through the program and where they are used. 
- :doc:`Creating path queries <path-queries>`: You can create path queries to visualize the flow of information through a codebase.
- :doc:`Troubleshooting query performance <debugging-queries>`: Improve the performance of your CodeQL queries by following a few simple guidelines.
