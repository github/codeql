QL for C#
=========

.. toctree::
   :glob:
   :hidden:

   introduce-libraries-csharp
   dataflow

These topics provide an overview of the QL C# libraries and show examples of how to use them.

-  `Basic C# QL query <https://lgtm.com/help/lgtm/console/ql-csharp-basic-example>`__ describes how to write and run queries using LGTM.

-  :doc:`Introducing the C# libraries <introduce-libraries-csharp>` introduces the standard libraries used to write queries for C# code.

.. raw:: html

   <!-- Working with generic types and methods(generics) - how to query generic types and methods. -->

-  :doc:`Tutorial: Analyzing data flow in C# <dataflow>` demonstrates how to write queries using the standard QL for C# data flow and taint tracking libraries.

.. raw:: html

   <!-- Working with call graphs(call-graph) - how to construct and query call graphs, and work with dynamic and virtual dispatch. -->

.. raw:: html

   <!-- Working with control flow(control-flow) - how to query intra-procedural control flow. -->

.. raw:: html

   <!-- Working with comments(comments) - how to query comments and XML documentation. -->

Other resources
---------------

-  For examples of how to query common C# elements, see the `C# QL cookbook <https://help.semmle.com/wiki/display/CBCSHARP>`__.
-  For the queries used in LGTM, display a `C# query <https://lgtm.com/search?q=language%3Acsharp&t=rules>`__ and click **Open in query console** to see the QL code used to find alerts.
-  For more information about the C/C++ QL library see the `QL library for C# <https://help.semmle.com/qldoc/csharp>`__.
