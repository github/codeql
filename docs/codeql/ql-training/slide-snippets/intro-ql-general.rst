A few years ago, somewhere between Earth and Mars...
====================================================

Crashing bug found in Curiosity’s landing module through routine testing.

Patching is still possible mid-flight, but what if there are more such issues?

.. container:: image-box

   .. image:: ../_static-training/curiosity2.png
   
.. note::

   When the Curiosity Rover was on its way to Mars in 2012, a flight software developer at NASA JPL discovered a mission-critical bug through manual code review. The problem occurred in Curiosity’s Entry, Descent, and Landing software–the software responsible for the Rover’s descent through the Martian atmosphere and landing it safely on the surface. of Mars.

   The bug, which had gone undetected by traditional solutions, was likely to prevent the capsule’s parachutes from opening, resulting in the Rover crashing onto the red planet’s rocky surface.
   
Zoom in on the code...
======================

(For illustration only, not actually NASA code!)

.. code-block:: cpp
   :emphasize-lines: 1,7

   void fire_thrusters(double vectors[12]) {
     for (int i = 0; i < 12 i++) {
       ... vectors[i] ...
     }
   }
   double thruster[3] = ... ;
   fire_thrusters(thruster);

- In C, array types of parameters degrade to pointer types.
- The size is ignored!
- No protection from passing a mismatched array.

.. note::

  The problem stems from a peculiarity of the C language. 
  You can declare parameters to have array types (with stated sizes), but that means nothing: the parameter type “degrades” to a raw pointer type with no size information.

  The pseudocode in the slide illustrates this. 
  The function is declared to take an array of length 12 (presumably three data points for each thruster). 
  However, there’s no bounds checking, and a developer might call it with an array that’s too short, holding direction information for only one of the thrusters. 
  The function will then read past the end of the array, and unpredictable results occur.

Write a query...
================

...to find all instances of the problem.

Complete text of the analysis (nothing left out!):

.. code-block:: ql

  import cpp

  from Function f, FunctionCall c, int i, int a, int b
  where f = c.getTarget()
    and a = c.getArgument(i).getType().(ArrayType).getArraySize()
    and b = f.getParameter(i).getType().(ArrayType).getArraySize()
    and a < b
  select c.getArgument(i), "Array of size " + a
         + " passed to $@, which expects an array of size " + b + ".",
         f, f.getName()

.. note::
 
  Once the mission critical bug was discovered on Curiosity, JPL contacted Semmle for help discovering whether variants of the problem might exist elsewhere in the Curiosity control software.  In 20 minutes, research engineers from Semmle produced a CodeQL query and shared it with the JPL team. It finds all functions that are passed an array as an argument whose size is smaller than expected.

  (The goal here is not to fully understand the query, but to illustrate the power of the language and its standard libraries.)


Find all instances!
===================

- When applied to the code, the query found the original bug and around 30 others.

- Three of those were in the same entry, descent and landing module.

- All were fixed with a mid-flight patch.

.. note::

  The JPL team ran the query across the full Curiosity control software–it identified the original problem, and more than 30 other variants, of which three were in the critical Entry, Descent, and Landing module. 

  The team addressed all issues, and patched the firmware remotely. Not long after, the Curiosity Rover landed safely on Mars.

.. rst-class:: background2

How it all works
================

Analysis overview
=================

.. rst-class:: analysis

   .. image:: ../_static-training/analysis-overview.png
         
.. note::

  CodeQL analysis works by extracting a queryable database from your project. For compiled languages, the tools observe an ordinary build of the source code. Each time a compiler is invoked to process a source file, a copy of that file is made, and all relevant information about the source code (syntactic data about the abstract syntax tree, semantic data like name binding and type information, data on the operation of the C preprocessor, etc.) is collected. For interpreted languages, the extractor gathers similar information by running directly on the source code. Multi-language code bases are analyzed one language at a time.

  Once the extraction finishes, all this information is collected into a single `CodeQL database <https://codeql.github.com/docs/codeql-overview/about-codeql/#about-codeql-databases>`__, which is then ready to query, possibly on a different machine. A copy of the source files, made at the time the database was created, is also included in the CodeQL database so analysis results can be displayed at the correct location in the code. The database schema is (source) language specific.

  Queries are written in QL and usually depend on one or more of the `standard CodeQL libraries <https://github.com/github/codeql>`__ (and of course you can write your own custom libraries). They are compiled into an efficiently executable format by the QL compiler and then run on a CodeQL database by the QL evaluator, either on a remote worker machine or locally on a developer’s machine.

  Query results can be interpreted and presented in a variety of ways, including displaying them in CodeQL for Visual Studio Code.

Introducing QL
==============

QL is the query language running all CodeQL analysis.

QL is:

- a **logic** language based on first-order logic
- a **declarative** language without side effects
- an **object-oriented** language
- a **query** language working on a read-only CodeQL database
- equipped with rich standard libraries **for program analysis**

.. note::

  QL is the high-level, object-oriented logic language that underpins all CodeQL libraries and analyses. You can learn lots more about QL by visiting the `QL language reference <https://codeql.github.com/docs/ql-language-reference/>`__.
  The key features of QL are:
  
  - All common logic connectives are available, including quantifiers like ``exist``, which can also introduce new variables. 
  - The language is declarative–the user focuses on stating what they would like to find, and leaves the details of how to evaluate the query to the engine. 
  - The object-oriented layer allows us to develop rich standard libraries for program analysis. These model the common AST node types, control flow and name lookup, and define further layers on top–for example control flow or data flow analysis. The `standard CodeQL libraries and queries <https://github.com/github/codeql>`__ ship as source and can be inspected by the user, and new abstractions are readily defined.
  - The database generated by the CodeQL tools is treated as read-only; queries cannot insert new data into it, though they can inspect its contents in various ways.
