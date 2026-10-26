.. _codeql-for-java:

CodeQL for Java and Kotlin
==========================

Experiment and learn how to write effective and efficient queries for CodeQL databases generated from Java and Kotlin codebases.

.. pull-quote:: Enabling Kotlin support

   CodeQL treats Java and Kotlin as parts of the same language, so to enable Kotlin support you should enable ``java-kotlin`` as a language.

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
   customizing-library-models-for-java-and-kotlin

-  :doc:`Basic query for Java and Kotlin code <basic-query-for-java-code>`: Learn to write and run a simple CodeQL query.

-  :doc:`CodeQL library for Java and Kotlin <codeql-library-for-java>`: When analyzing Java/Kotlin code, you can use the large collection of classes in the CodeQL library for Java/Kotlin.

-  :doc:`Analyzing data flow in Java and Kotlin <analyzing-data-flow-in-java>`: You can use CodeQL to track the flow of data through a Java/Kotlin program to its use.

- `CodeQL CTF: CodeQL and Chill <https://securitylab.github.com/ctf/codeql-and-chill/>`__: Follow the steps that members of GitHub Security Lab went through to track the flow of tainted data from user-controlled bean properties to custom error messages, and identify the known injection vulnerabilities.

-  :doc:`Java and Kotlin types <types-in-java>`: You can use CodeQL to find out information about data types used in Java/Kotlin code. This allows you to write queries to identify specific type-related issues.

-  :doc:`Overflow-prone comparisons in Java and Kotlin <overflow-prone-comparisons-in-java>`: You can use CodeQL to check for comparisons in Java/Kotlin code where one side of the comparison is prone to overflow.

-  :doc:`Navigating the call graph <navigating-the-call-graph>`: CodeQL has classes for identifying code that calls other code, and code that can be called from elsewhere. This allows you to find, for example, methods that are never used.

-  :doc:`Annotations in Java and Kotlin <annotations-in-java>`: CodeQL databases of Java/Kotlin projects contain information about all annotations attached to program elements.

-  :doc:`Javadoc <javadoc>`: You can use CodeQL to find errors in Javadoc comments in Java code.

-  :doc:`Working with source locations <working-with-source-locations>`: You can use the location of entities within Java/Kotlin code to look for potential errors. Locations allow you to deduce the presence, or absence, of white space which, in some cases, may indicate a problem.

-  :doc:`Abstract syntax tree classes for working with Java and Kotlin programs <abstract-syntax-tree-classes-for-working-with-java-programs>`: CodeQL has a large selection of classes for representing the abstract syntax tree of Java/Kotlin programs.

-  :doc:`Customizing library models for Java and Kotlin <customizing-library-models-for-java-and-kotlin>`: You can model frameworks and libraries that your code base depends on using data extensions and publish them as CodeQL model packs.
