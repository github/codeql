CodeQL for JavaScript
=====================

Experiment and learn how to write effective and efficient queries for CodeQL databases generated from JavaScript codebases.

.. toctree::
   :hidden:

   introduce-libraries-js
   introduce-libraries-ts
   dataflow
   flow-labels
   type-tracking
   ast-class-reference
   dataflow-cheat-sheet

-  `Basic JavaScript query <https://lgtm.com/help/lgtm/console/ql-javascript-basic-example>`__: Learn to write and run a simple CodeQL query using LGTM.

-  :doc:`CodeQL library for JavaScript <introduce-libraries-js>`: When you're analyzing a JavaScript program, you can make use of the large collection of classes in the CodeQL library for JavaScript.

-  :doc:`CodeQL library for TypeScript <introduce-libraries-ts>`: When you're analyzing a TypeScript program, you can make use of the large collection of classes in the CodeQL library for TypeScript.

-  :doc:`Analyzing data flow in JavaScript and TypeScript <dataflow>`: This topic describes how data flow analysis is implemented in the CodeQL libraries for JavaScript/TypeScript and includes examples to help you write your own data flow queries.

-  :doc:`Using flow labels for precise data flow analysis <flow-labels>`: You can associate flow labels with each value tracked by the flow analysis to determine whether the flow contains potential vulnerabilities.

-  :doc:`Using type tracking for API modeling <type-tracking>`: You can track data through an API by creating a model using the CodeQL type-tracking library for JavaScript.

-  :doc:`Abstract syntax tree classes for JavaScript and TypeScript <ast-class-reference>`: CodeQL has a large selection of classes for working with JavaScript and TypeScript statements and expressions.

-  :doc:`Data flow cheat sheet for JavaScript <dataflow-cheat-sheet>`: This article describes parts of the JavaScript libraries commonly used for variant analysis and in data flow queries.
