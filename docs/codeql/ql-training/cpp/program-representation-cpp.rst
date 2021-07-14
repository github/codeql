======================
Program representation 
======================

CodeQL for C/C++

.. rst-class:: agenda

Agenda
======

- Abstract syntax trees
- Database representation
- Symbol tables
- Variables
- Functions

.. insert abstract-syntax-tree.rst

.. include:: ../slide-snippets/abstract-syntax-tree.rst

.. resume slides

AST CodeQL classes
==================

Important AST CodeQL classes include:

- ``Expr``: expressions such as assignments, variable references, function calls, ...
- ``Stmt``: statements such as conditionals, loops, try statements, ... 
- ``DeclarationEntry``: places where functions, variables or types are declared and/or defined

These three (and all other AST CodeQL classes) are subclasses of ``Element``.

Symbol table
============

The database also includes information about the symbol table associated with a program:

- ``Variable``:  all variables, including local variables, global variables, static variables and member variables

- ``Function``: all functions, including member function

- ``Type``: built-in and user-defined types

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

Functions are represented by the Function class. Each declaration or definition of a function is represented by a ``FunctionDeclarationEntry``.

Calls to functions are modeled by the CodeQL class ``Call`` and its subclasses:

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

Working with macros
===================

  .. code-block:: cpp

    #define square(x) x*x
    y = square(y0), z = square(z0)

is represented in the CodeQL database as:

- A Macro entity representing the text of the *head* and *body* of the macro
- Assignment nodes, representing the two assignments after preprocessing

  - Left-hand sides are ``VariableAccess`` nodes of y and z
  - Right-hand sides are ``MulExpr`` nodes representing ``y0*y0`` and ``z0*z0``

- A ``MacroAccess`` entity, which associates the Macro with the ``MulExprs``

Useful predicates on ``Element``: ``isInMacroExpansion()``, ``isAffectedByMacro()``

.. note::

  The CodeQL database also contains information about macro definitions, which are represented by class ``Macro``. These macro definitions are related to the AST nodes resulting from their uses by the class ``MacroAccess``.
