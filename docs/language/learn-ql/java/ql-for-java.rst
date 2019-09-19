QL for Java
===========

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

These topics provide an overview of the QL Java standard library and show examples of how to use them.

-  `Basic Java QL query <https://lgtm.com/help/lgtm/console/ql-java-basic-example>`__ describes how to write and run queries using LGTM.

-  :doc:`Introducing the QL libraries for Java <introduce-libraries-java>` an introduction to the organization of the standard libraries used to write queries for Java code.

-  :doc:`Tutorial: Analyzing data flow in Java <dataflow>` demonstrates how to write queries using the standard QL for Java data flow and taint tracking libraries.

-  :doc:`Tutorial: Types and the class hierarchy <types-class-hierarchy>` introduces the QL classes for representing a program's class hierarchy by means of examples.

-  :doc:`Tutorial: Expressions and statements <expressions-statements>` introduces the QL classes for representing a program's syntactic structure by means of examples.

-  :doc:`Tutorial: Navigating the call graph <call-graph>` a worked example of how to write a query that navigates a program's call graph to find unused methods.

-  :doc:`Tutorial: Annotations <annotations>` introduces the QL classes for representing annotations by means of examples.

-  :doc:`Tutorial: Javadoc <javadoc>` introduces the QL classes for representing Javadoc comments by means of examples.

-  :doc:`Tutorial: Working with source locations <source-locations>` a worked example of how to write a query that uses the location information provided in the snapshot for finding likely bugs.

-  :doc:`AST class reference <ast-class-reference>` an overview of all AST classes in the QL standard library for Java.

Other resources
---------------

-  For examples of how to query common Java elements, see the `Java QL cookbook <https://help.semmle.com/wiki/display/CBJAVA>`__.
-  For the queries used in LGTM, display a `Java query <https://lgtm.com/search?q=language%3Ajava&t=rules>`__ and click **Open in query console** to see the QL code used to find alerts.
-  For more information about the Java QL library see the `QL library for Java <https://help.semmle.com/qldoc/java>`__.
