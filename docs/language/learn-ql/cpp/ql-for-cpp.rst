CodeQL for C/C++
================

.. toctree::
   :glob:
   :hidden:

   introduce-libraries-cpp
   function-classes
   expressions-types
   conversions-classes
   dataflow
   private-field-initialization
   zero-space-terminator

These topics provide an overview of the CodeQL libraries for C/C++ and show examples of how to write queries that use them.

-  `Basic C/C++ query <https://lgtm.com/help/lgtm/console/ql-cpp-basic-example>`__ describes how to write and run queries using LGTM.

-  :doc:`Introducing the CodeQL libraries for C/C++ <introduce-libraries-cpp>` introduces the standard libraries used to write queries for C and C++ code.

-  :doc:`Tutorial: Function classes <function-classes>` demonstrates how to write queries using the standard CodeQL library classes for C/C++ functions.

-  :doc:`Tutorial: Expressions, types and statements <expressions-types>` demonstrates how to write queries using the standard CodeQL library classes for C/C++ expressions, types and statements.

-  :doc:`Tutorial: Conversions and classes <conversions-classes>` demonstrates how to write queries using the standard CodeQL library classes for C/C++ conversions and classes.

-  :doc:`Tutorial: Analyzing data flow in C/C++ <dataflow>` demonstrates how to write queries using the standard data flow and taint tracking libraries for C/C++.

-  :doc:`Example: Checking that constructors initialize all private fields <private-field-initialization>` works through the development of a query. It introduces recursive predicates and shows the typical workflow used to refine a query.

-  :doc:`Example: Checking for allocations equal to strlen(string) without space for a null terminator <zero-space-terminator>` shows how a query to detect this particular buffer issue was developed.

Advanced libraries
----------------------------------

.. toctree::
   :hidden:

   guards
   range-analysis
   value-numbering-hash-cons

- :doc:`Using the guards library in C and C++ <guards>` demonstrates how to identify conditional expressions that control the execution of other code and what guarantees they provide.

- :doc:`Using range analysis for C and C++ <range-analysis>` demonstrates how to determine constant upper and lower bounds and possible overflow or underflow of expressions.

- :doc:`Using hash consing and value numbering for C and C++ <value-numbering-hash-cons>` demonstrates how to recognize expressions that are syntactically identical or compute the same value at runtime.


Other resources
---------------

.. TODO: Rename the cookbooks: C/C++ cookbook, or C/C++ CodeQL cookbook, or CodeQL cookbook for C/C++, or...? 

-  For examples of how to query common C/C++ elements, see the `C/C++ cookbook <https://help.semmle.com/wiki/display/CBCPP>`__.
-  For the queries used in LGTM, display a `C/C++ query <https://lgtm.com/search?q=language%3Acpp&t=rules>`__ and click **Open in query console** to see the code used to find alerts.
-  For more information about the library for C/C++ see the `CodeQL library for C/C++ <https://help.semmle.com/qldoc/cpp>`__.
