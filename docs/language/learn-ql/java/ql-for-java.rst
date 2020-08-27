CodeQL for Java
===============

Experiment and learn how to write effective and efficient queries for CodeQL databases generated from Java codebases.

.. toctree::
   :hidden:

   basic-query-java
   introduce-libraries-java
   dataflow
   types-class-hierarchy
   expressions-statements
   call-graph
   annotations
   javadoc
   source-locations
   ast-class-reference

-  :doc:`Basic query for Java code <basic-query-java>`: Learn to write and run a simple CodeQL query using LGTM.

-  :doc:`CodeQL library for Java <introduce-libraries-java>`: When analyzing Java code, you can use the large collection of classes in the CodeQL library for Java.

-  :doc:`Analyzing data flow in Java <dataflow>`: You can use CodeQL to track the flow of data through a Java program to its use. 

-  :doc:`Java types <types-class-hierarchy>`: You can use CodeQL to find out information about data types used in Java code. This allows you to write queries to identify specific type-related issues.

-  :doc:`Overflow-prone comparisons in Java <expressions-statements>`: You can use CodeQL to check for comparisons in Java code where one side of the comparison is prone to overflow.

-  :doc:`Navigating the call graph <call-graph>`: CodeQL has classes for identifying code that calls other code, and code that can be called from elsewhere. This allows you to find, for example, methods that are never used.

-  :doc:`Annotations in Java <annotations>`: CodeQL databases of Java projects contain information about all annotations attached to program elements.

-  :doc:`Javadoc <javadoc>`: You can use CodeQL to find errors in Javadoc comments in Java code.

-  :doc:`Working with source locations <source-locations>`: You can use the location of entities within Java code to look for potential errors. Locations allow you to deduce the presence, or absence, of white space which, in some cases, may indicate a problem.

-  :doc:`Abstract syntax tree classes for working with Java programs <ast-class-reference>`: CodeQL has a large selection of classes for representing the abstract syntax tree of Java programs.

