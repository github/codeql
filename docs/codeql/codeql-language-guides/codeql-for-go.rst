.. _codeql-for-go:

CodeQL for Go
=============

Experiment and learn how to write effective and efficient queries for CodeQL databases generated from Go codebases.

.. toctree::
   :hidden:

   basic-query-for-go-code
   codeql-library-for-go
   abstract-syntax-tree-classes-for-working-with-go-programs
   modeling-data-flow-in-go-libraries

-  :doc:`Basic query for Go code <basic-query-for-go-code>`: Learn to write and run a simple CodeQL query using LGTM.

-  :doc:`CodeQL library for Go <codeql-library-for-go>`: When you're analyzing a Go program, you can make use of the large collection of classes in the CodeQL library for Go.

-  :doc:`Abstract syntax tree classes for working with Go programs <abstract-syntax-tree-classes-for-working-with-go-programs>`: CodeQL has a large selection of classes for representing the abstract syntax tree of Go programs.

-  :doc:`Modeling data flow in Go libraries <modeling-data-flow-in-go-libraries>`: When analyzing a Go program, CodeQL does not examine the source code for external packages. 
   To track the flow of untrusted data through a library, you can create a model of the library.
