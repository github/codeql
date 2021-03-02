.. _ql-language-reference:

QL language reference
#####################

Learn all about QL, the powerful query language that underlies the code scanning tool CodeQL.

- :doc:`About the QL language <about-the-ql-language>`: QL is the powerful query language that underlies CodeQL, which is used to analyze code.

- :doc:`Predicates <predicates>`: Predicates are used to describe the logical relations that make up a QL program. 

- :doc:`Queries <queries>`: Queries are the output of a QL program. They evaluate to sets of results.

- :doc:`Types <types>`: QL is a statically typed language, so each variable must have a declared type.

- :doc:`Modules <modules>`: Modules provide a way of organizing QL code by grouping together related types, predicates, and other modules. 

- :doc:`Aliases <aliases>`: An alias is an alternative name for an existing QL entity. 

- :doc:`Variables <variables>`: Variables in QL are used in a similar way to variables in algebra or logic. They represent sets of values, and those values are usually restricted by a formula.

- :doc:`Expressions <expressions>`: An expression evaluates to a set of values and has a type.

- :doc:`Formulas <formulas>`: Formulas define logical relations between the free variables used in expressions.

- :doc:`Annotations <annotations>`: An annotation is a string that you can place directly before the declaration of a QL entity or name.

- :doc:`Recursion <recursion>`: QL provides strong support for recursion. A predicate in QL is said to be recursive if it depends, directly or indirectly, on itself. 

- :doc:`Lexical syntax <lexical-syntax>`: The QL syntax includes different kinds of keywords, identifiers, and comments.

- :doc:`Name resolution <name-resolution>`: The QL compiler resolves names to program elements.

- :doc:`Evaluation of QL programs <evaluation-of-ql-programs>`: A QL program is evaluated in a number of different steps.

- :doc:`QL language specification <ql-language-specification>`: A formal specification for the QL language. It provides a comprehensive reference for terminology, syntax, and other technical details about QL. 

.. toctree::
   :maxdepth: 1
   :hidden:

   about-the-ql-language
   predicates
   queries
   types
   modules
   aliases
   variables
   expressions
   formulas
   annotations
   recursion
   lexical-syntax
   name-resolution
   evaluation-of-ql-programs
   ql-language-specification
