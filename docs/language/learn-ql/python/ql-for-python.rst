CodeQL for Python
=================

.. toctree::
   :glob:
   :hidden:

   introduce-libraries-python
   functions
   statements-expressions
   pointsto-type-infer
   control-flow
   taint-tracking

Experiment and learn how to write effective and efficient queries for Python projects.

:doc:`CodeQL libraries for Python <introduce-libraries-python>`
---------------------------------------------------------------
Overview of the standard CodeQL libraries for writing CodeQL queries on Python code.

:doc:`Functions in Python <functions>`
--------------------------------------
Functions are key building blocks of Python code bases. You can find functions and identify calls to them using syntactic classes from the standard CodeQL library.

:doc:`Expressions and statements in Python <statements-expressions>`
--------------------------------------------------------------------
Expressions define a value. Statements represent a command or action. You can explore how they are used in a code base using syntactic classes from the standard CodeQL library.

:doc:`Pointer analysis and type inference in Python <pointsto-type-infer>`
--------------------------------------------------------------------------
At run time, each Python expression has a value with an associated type. You can learn how an expression behaves at run time using type-inference classes from the standard CodeQL library.

:doc:`Analyzing control flow in Python <control-flow>`
------------------------------------------------------
You can write CodeQL queries to explore the control flow graph of a Python program, for example, to discover unreachable code or mutually exclusive blocks of code.

:doc:`Analyzing data flow and tracking tainted data in Python <taint-tracking>`
-------------------------------------------------------------------------------
You can use CodeQL to track the flow of data through a Python program to its use. Tracking user-controlled, or tainted, data is a key technique for security researchers.

