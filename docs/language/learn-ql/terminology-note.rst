Recent terminology changes
===========================

We recently started using new terminology to make it clearer to users what our products do. 
This note gives some information about what has changed.

CodeQL
------

CodeQL is the code analysis platform formerly known as QL. 
CodeQL treats code as data, and CodeQL analysis is based on running queries against your code to check for errors and find bugs and vulnerabilities.
The CodeQL product includes the tools, scripts, queries, and libraries used in CodeQL analysis. 

QL
---

Previously we used the term QL to refer to the whole code analysis platform, which has been renamed CodeQL. 
The name QL now only refers to the query language that powers CodeQL analysis.

The CodeQL queries and libraries used to analyze source code are written in QL.
These queries and libraries are open source, and can be found in the `CodeQL repository <https://github.com/github/codeql>`__.
QL is a general-purpose, object-oriented language that can be used to query any kind of data. 

CodeQL databases
----------------

QL snapshots have been renamed CodeQL databases. `CodeQL databases <https://help.semmle.com/codeql/about-codeql.html#about-codeql-databases>`__ contain relational data created and analyzed using CodeQL. They are the equivalent of QL snapshots, but have been optimized for use with the CodeQL tools.
