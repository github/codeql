QL for JavaScript
=================

.. toctree::
   :glob:
   :hidden:

   introduce-libraries-js
   introduce-libraries-ts
   dataflow
   flow-labels
   type-tracking
   ast-class-reference
   dataflow-cheat-sheet

These documents provide an overview of the QL JavaScript and TypeScript standard libraries and show examples of how to use them.

-  `Basic JavaScript QL query <https://lgtm.com/help/lgtm/console/ql-javascript-basic-example>`__ describes how to write and run queries using LGTM.

-  :doc:`Introducing the QL libraries for JavaScript <introduce-libraries-js>`: an overview of the standard libraries used to write queries for JavaScript code. There is an extensive QL library for analyzing JavaScript code. This tutorial briefly summarizes the most important QL classes and predicates provided by this library.

-  :doc:`Introducing the QL libraries for TypeScript <introduce-libraries-ts>`: an overview of the standard libraries used to write queries for TypeScript code.

-  :doc:`Analyzing data flow in JavaScript/TypeScript <dataflow>`: demonstrates how to write queries using the standard QL for JavaScript/TypeScript data flow and taint tracking libraries.

-  :doc:`Advanced data-flow analysis using flow labels <flow-labels>`: shows a more advanced example of data flow analysis using flow labels.

-  :doc:`AST class reference <ast-class-reference>`: an overview of all AST classes in the QL standard library for JavaScript.

-  :doc:`Data flow cheat sheet <dataflow-cheat-sheet>`: bits of QL commonly used for variant analysis and in data flow queries.

Other resources
---------------

-  For examples of how to query common JavaScript elements, see the `JavaScript QL cookbook <https://help.semmle.com/wiki/display/CBJS>`__
-  For the queries used in LGTM, display a `JavaScript query <https://lgtm.com/search?q=language%3Ajavascript&t=rules>`__ and click **Open in query console** to see the QL code used to find alerts.
-  For more information about the JavaScript QL library see the `QL library for JavaScript <https://help.semmle.com/qldoc/javascript/>`__.
