QL for C/C++
============

Program representation

Agenda
======

- Abstract syntax trees
- Database representation
- Symbol tables
- Variables
- Functions

Abstract syntax trees
=====================

The basic representation of an analyzed program is an *abstract syntax tree (AST)*.

.. code-block:: cpp

  try {
      ...
  } catch (AnException e) {
  }

.. note::

  When writing queries in QL it is important to have in mind the underlying representation of the program which is stored in the database. Typically queries make use of the “AST” representation of the program - a tree structure where program elements are nested within other program elements.

  The “Introducing the C/C++ libraries” help topic contains a more complete overview of important AST classes and the rest of the C++ QL libraries: https://help.semmle.com/QL/learn-ql/ql/cpp/introduce-libraries-cpp.html 

Database representaions of ASTs
===============================

AST nodes and other program elements are encoded in the database as *entity values*. Entities are implemented as integers, but in QL they are opaque; all one can do with them is to check their equality.

Each entity belongs to an entity type. Entity types have names starting with “@” and are defined in the database schema (not in QL).

Properties of AST nodes and their relationships to each other are encoded by database relations, which are predicates defined in the database (not in QL).

Entity types are rarely used directly, the usual pattern is to define a QL class that extends the type and exposes properties of its entities through member predicates.

.. note::

  ASTs are a typical example of the kind of data representation one finds in object-oriented programming, with data-carrying nodes that reference each other. At first glance, QL, which can only work with atomic values, does not seem to be well suited for working with this kind of data. However, ultimately all that we require of the nodes in an AST is that they have an identity. The relationships among nodes, usually implemented by reference-valued object fields in other languages, can just as well (and arguably more naturally) be represented as relations over nodes. Attaching data (such as strings or numbers) to nodes can also be represented with relations over nodes and primitive values. All we need is a way for relations to reference nodes. This is achieved in QL (as in other database languages) by means of entity values (or “entities”, for short), which are opaque atomic values, implemented as integers under the hood.

  It is the job of the extractor to create entity values for all AST nodes and populate database relations that encode the relationship between AST nodes and any values associated with them. These relations are extensional, that is, explicitly stored in the database, unlike the relations described by QL predicates, which we also refer to as intensional relations. Entity values belong to entity types, whose name starts with “@” to set them apart from primitive types and classes.

  The interface between entity types and extensional relations on the one hand and QL predicates and classes on the other hand is provided by the database schema, which defines the available entity types and the schema of each extensional relation, that is, how many columns the relation has, and which entity type or primitive type the values in each column come from. QL programs can refer to entity types and extensional relations just as they would refer to QL classes and predicates, with the restriction that entity types cannot be directly selected in a “select” clause, since they do not have a well-defined string representation.

  For example, the database schema for C++ snapshot databases is here: https://github.com/Semmle/ql/blob/master/cpp/ql/src/semmlecode.cpp.dbscheme 

AST QL classes
==============

Important AST classes include:

- ``Expr``: expressions such as assignments, variable references, function calls, …
- ``Stmt``: statements such as conditionals, loops, try statements, … 
- ``DeclarationEntry``: places where functions, variables or types are declared and/or defined

These three (and all other AST classes) are subclasses of Element.

.. note::

  The “Introducing the C/C++ libraries” help topic contains a more complete overview of important AST classes and the rest of the C++ QL libraries: https://help.semmle.com/QL/learn-ql/ql/cpp/introduce-libraries-cpp.html 

Symbol table
============

The database also includes information about the symbol table associated with a program:

- ``Variable``:  all variables, including local variables, global variables, static variables and member variables

- ``Function``: all functions, including member function

- ``Type``: built-in and user-defined types

.. note::

  The “Introducing the C/C++ libraries” help topic contains a more complete overview of important symbol table classes and the rest of the C++ QL libraries: https://help.semmle.com/QL/learn-ql/ql/cpp/introduce-libraries-cpp.html 

Working with variables
======================

``Variable`` represents program variables, including locally scoped variables (``LocalScopeVariable``), global variables (``GlobalVariable``), and others:

- ``string Variable.getName()``
- ``Type Variable.getType()``

``Access`` represents references to declared entities such as functions (``FunctionAccess``) and variables (``VariableAccess``), including fields (``FieldAccess``).

- ``Declaration Access.getTarget()``

``VariableDeclarationEntry`` represents declarations or definitions of a variable.

- ``Variable VariableDeclarationEntry.getVariable()``

Working with functions
======================

Functions are represented by the Function QL class. Each declaration or definition of a function is represented by a ``FunctionDeclarationEntry``.

Calls to functions are modelled by QL class Call and its subclasses:

- ``Call.getTarget()`` gets the declared target of the call; undefined for calls through function pointers
- ``Function.getACallToThisFunction()`` gets a call to this function

Typically, functions are identified by name:

- ``string Function.getName()``
- ``string Function.getQualifiedName()``

Working with preprocessor logic
===============================

Macros and other preprocessor directives can easily cause confusion when analyzing programs:

- AST structure reflects the program *after* preprocessing.
- Locations refer to the original source text *before* preprocessing.

For example, in:

  .. code-block:: cpp

    #define square(x) x*x
    y = square(y0), z = square(z0)

there are no AST nodes corresponding to ``square(y0)`` or ``square(z0)``, but there are AST nodes corresponding to ``y0*y0`` and ``z0*z0``.

.. note::

  The C preprocessor poses a dilemma: un-preprocessed code cannot, in general, be parsed and analyzed meaningfully, but showing results in preprocessed code is not useful to developers. Our solution is to base the AST representation on preprocessed source (in the same way as compilers do), but associate AST nodes with locations in the original source text.

Working with Macros
===================

  .. code-block:: cpp

    #define square(x) x*x
    y = square(y0), z = square(z0)

is represented in the snapshot database as:

- A Macro entity representing the text of the *head* and *body* of the macro
- Assignment nodes, representing the two assignments after preprocessing

  - Left-hand sides are ``VariableAccess`` nodes of y and z
  - Right-hand sides are ``MulExpr`` nodes representing ``y0*y0`` and ``z0*z0``

- A ``MacroAccess`` entity, which associates the Macro with the ``MulExprs``

Useful predicates on ``Element: isInMacroExpansion()``, ``isAffectedByMacro()``