.. _codeql-for-javascript:

CodeQL for JavaScript and TypeScript
====================================

Experiment and learn how to write effective and efficient queries for CodeQL databases generated from JavaScript and TypeScript codebases.

.. toctree::
   :hidden:

   basic-query-for-javascript-code
   codeql-library-for-javascript
   codeql-library-for-typescript
   analyzing-data-flow-in-javascript-and-typescript
   using-flow-labels-for-precise-data-flow-analysis
   specifying-additional-remote-flow-sources-for-javascript
   using-type-tracking-for-api-modeling
   abstract-syntax-tree-classes-for-working-with-javascript-and-typescript-programs
   data-flow-cheat-sheet-for-javascript
   customizing-library-models-for-javascript
   migrating-javascript-dataflow-queries

-  :doc:`Basic query for JavaScript and TypeScript code <basic-query-for-javascript-code>`: Learn to write and run a simple CodeQL query.

-  :doc:`CodeQL library for JavaScript <codeql-library-for-javascript>`: When you're analyzing a JavaScript program, you can make use of the large collection of classes in the CodeQL library for JavaScript.

-  :doc:`CodeQL library for TypeScript <codeql-library-for-typescript>`: When you're analyzing a TypeScript program, you can make use of the large collection of classes in the CodeQL library for TypeScript.

- `CodeQL CTF: XSS-unsafe jQuery plugins <https://securitylab.github.com/ctf/jquery/>`__: Follow the steps that members of GitHub Security Lab went through to find cross-site scripting vulnerabilities in Bootstrap's jQuery plugins.

-  :doc:`Analyzing data flow in JavaScript and TypeScript <analyzing-data-flow-in-javascript-and-typescript>`: This topic describes how data flow analysis is implemented in the CodeQL libraries for JavaScript/TypeScript and includes examples to help you write your own data flow queries.

-  :doc:`Using flow labels for precise data flow analysis <using-flow-labels-for-precise-data-flow-analysis>`: You can associate flow labels with each value tracked by the flow analysis to determine whether the flow contains potential vulnerabilities.

-  :doc:`Using type tracking for API modeling <using-type-tracking-for-api-modeling>`: You can track data through an API by creating a model using the CodeQL type-tracking library for JavaScript.

-  :doc:`Abstract syntax tree classes for working with JavaScript and TypeScript programs <abstract-syntax-tree-classes-for-working-with-javascript-and-typescript-programs>`: CodeQL has a large selection of classes for representing the abstract syntax tree of JavaScript and TypeScript programs.

-  :doc:`Data flow cheat sheet for JavaScript <data-flow-cheat-sheet-for-javascript>`: This article describes parts of the JavaScript libraries commonly used for variant analysis and in data flow queries.

-  :doc:`Customizing library models for JavaScript <customizing-library-models-for-javascript>`: You can model frameworks and libraries that your codebase depends on using data extensions and publish them as CodeQL model packs.

-  :doc:`Migrating JavaScript dataflow queries <migrating-javascript-dataflow-queries>`: Guide on migrating data flow queries to the new data flow library.
