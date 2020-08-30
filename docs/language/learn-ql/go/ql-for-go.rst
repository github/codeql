CodeQL for Go
=============

Experiment and learn how to write effective and efficient queries for CodeQL databases generated from Go codebases.

.. toctree::
   :hidden:

   basic-query-go
   introduce-libraries-go
   ast-class-reference
   library-modeling-go

-  :doc:`Basic query for Go code <basic-query-go>`: Learn to write and run a simple CodeQL query using LGTM.

-  :doc:`CodeQL library for Go <introduce-libraries-go>`: When you're analyzing a Go program, you can make use of the large collection of classes in the CodeQL library for Go.

-  :doc:`Abstract syntax tree classes for working with Go programs <ast-class-reference>`: CodeQL has a large selection of classes for representing the abstract syntax tree of Go programs.

-  :doc:`Modeling data flow in Go libraries <library-modeling-go>`: When analyzing a Go program, CodeQL does not examine the source code for external packages. 
   To track the flow of untrusted data through a library, you can create a model of the library.
