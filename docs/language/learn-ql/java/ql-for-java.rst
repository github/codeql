CodeQL for Java
===============

.. toctree::
   :glob:
   :hidden:

   introduce-libraries-java
   dataflow
   types-class-hierarchy
   expressions-statements
   call-graph
   annotations
   javadoc
   source-locations
   ast-class-reference

These topics provide an overview of the CodeQL libraries for Java and show examples of how to use them.

-  `Basic Java query <https://lgtm.com/help/lgtm/console/ql-java-basic-example>`__ describes how to write and run queries using LGTM.

-  :doc:`Introducing the CodeQL libraries for Java <introduce-libraries-java>` introduces the standard libraries used to write queries for Java code.

-  :doc:`Tutorial: Analyzing data flow in Java <dataflow>` demonstrates how to write queries using the standard data flow and taint tracking libraries for Java.

-  :doc:`Tutorial: Types and the class hierarchy <types-class-hierarchy>` introduces the classes for representing a program's class hierarchy by means of examples.

-  :doc:`Tutorial: Expressions and statements <expressions-statements>` introduces the classes for representing a program's syntactic structure by means of examples.

-  :doc:`Tutorial: Navigating the call graph <call-graph>` is a worked example of how to write a query that navigates a program's call graph to find unused methods.

-  :doc:`Tutorial: Annotations <annotations>` introduces the classes for representing annotations by means of examples.

-  :doc:`Tutorial: Javadoc <javadoc>` introduces the classes for representing Javadoc comments by means of examples.

-  :doc:`Tutorial: Working with source locations <source-locations>` is a worked example of how to write a query that uses the location information provided in the database for finding likely bugs.

-  :doc:`AST class reference <ast-class-reference>` gives an overview of all AST classes in the standard CodeQL library for Java.

Other resources
---------------

-  For examples of how to query common Java elements, see the `Java cookbook <https://help.semmle.com/wiki/display/CBJAVA>`__.
-  For the queries used in LGTM, display a `Java query <https://lgtm.com/search?q=language%3Ajava&t=rules>`__ and click **Open in query console** to see the code used to find alerts.
-  For more information about the library for Java see the `CodeQL library for Java <https://help.semmle.com/qldoc/java>`__.
