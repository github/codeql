======================
Program representation
======================

CodeQL for Java

.. rst-class:: agenda

Agenda
======

- Abstract syntax trees
- Database representation
- Program elements
- AST CodeQL classes

.. insert abstract-syntax-tree.rst

.. include:: ../slide-snippets/abstract-syntax-tree.rst

.. resume slides

Program elements
================

- The CodeQL class ``Element`` represents program elements with a name.
- This includes: packages (``Package``), compilation units (``CompilationUnit``), types (``Type``), methods (``Method``), constructors (``Constructor``), and variables (``Variable``).
- It is often convenient to refer to an element that might either be a method or a constructor; the class ``Callable``, which is a common superclass of ``Method`` and ``Constructor``, can be used for this purpose.


AST
===

There are two primary AST CodeQL classes, used within ``Callables``:

   - ``Expr``: expressions such as assignments, variable references, function calls, ...
   - ``Stmt``: statements such as conditionals, loops, try statements, ... 

Operations are provided for exploring the AST:

   - ``Expr.getAChildExpr`` returns a sub-expression of a given expression.
   - ``Stmt.getAChild`` returns a statement or expression that is nested directly inside a given statement.
   - ``Expr.getParent`` and ``Stmt.getParent`` return the parent node of an AST node.

Types
=====

The database also includes information about the types used in a program:

- ``PrimitiveType`` represents a `primitive type <http://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html>`__, that is, one of ``boolean``, ``byte``, ``char``, ``double``, ``float``, ``int``, ``long``, ``short``. CodeQL also classifies ``void`` and ``<nulltype>`` (the type of the ``null`` literal) as primitive types.
- ``RefType`` represents a reference type; it has several subclasses:

  - ``Class`` represents a Java class.
  - ``Interface`` represents a Java interface.
  - ``EnumType`` represents a Java enum type.
  - ``Array`` represents a Java array type.

Working with variables
======================

``Variable`` represents program variables, including locally scoped variables (``LocalScopeVariable``), fields (``Fields``), and parameters (``Parameters``):

- ``string Variable.getName()``
- ``Type Variable.getType()``

``Access`` represents references to declared entities such as methods (``MethodAccess``) and variables (``VariableAccess``), including fields (``FieldAccess``).

- ``Declaration Access.getTarget()``

``VariableDeclarationEntry`` represents declarations or definitions of a variable.

- ``Variable VariableDeclarationEntry.getVariable()``

Working with callables
======================

Callables are represented by the ``Callable`` CodeQL class. 

Calls to callables are modeled by the CodeQL class ``Call`` and its subclasses:

- ``Call.getCallee()`` gets the declared target of the call
- ``Call.getAReference()`` gets a call to this function

Typically, callables are identified by name:

- ``string Callable.getName()``
- ``string Callable.getQualifiedName()``

.. rst-class:: java-expression-ast

Example: Java expression AST
============================

.. diagram copied from google slides