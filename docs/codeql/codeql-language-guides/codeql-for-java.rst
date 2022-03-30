.. _codeql-for-java:

CodeQL for Java
===============

Experiment and learn how to write effective and efficient queries for CodeQL databases generated from Java codebases.

.. toctree::
   :hidden:

   basic-query-for-java-code
   codeql-library-for-java
   analyzing-data-flow-in-java
   types-in-java
   overflow-prone-comparisons-in-java
   navigating-the-call-graph
   annotations-in-java
   javadoc
   working-with-source-locations
   abstract-syntax-tree-classes-for-working-with-java-programs

-  :doc:`Basic query for Java code <basic-query-for-java-code>`: Learn to write and run a simple CodeQL query using LGTM.

-  :doc:`CodeQL library for Java <codeql-library-for-java>`: When analyzing Java code, you can use the large collection of classes in the CodeQL library for Java.

-  :doc:`Analyzing data flow in Java <analyzing-data-flow-in-java>`: You can use CodeQL to track the flow of data through a Java program to its use. 

-  :doc:`Java types <types-in-java>`: You can use CodeQL to find out information about data types used in Java code. This allows you to write queries to identify specific type-related issues.

-  :doc:`Overflow-prone comparisons in Java <overflow-prone-comparisons-in-java>`: You can use CodeQL to check for comparisons in Java code where one side of the comparison is prone to overflow.

-  :doc:`Navigating the call graph <navigating-the-call-graph>`: CodeQL has classes for identifying code that calls other code, and code that can be called from elsewhere. This allows you to find, for example, methods that are never used.

-  :doc:`Annotations in Java <annotations-in-java>`: CodeQL databases of Java projects contain information about all annotations attached to program elements.

-  :doc:`Javadoc <javadoc>`: You can use CodeQL to find errors in Javadoc comments in Java code.

-  :doc:`Working with source locations <working-with-source-locations>`: You can use the location of entities within Java code to look for potential errors. Locations allow you to deduce the presence, or absence, of white space which, in some cases, may indicate a problem.

-  :doc:`Abstract syntax tree classes for working with Java programs <abstract-syntax-tree-classes-for-working-with-java-programs>`: CodeQL has a large selection of classes for representing the abstract syntax tree of Java programs.

