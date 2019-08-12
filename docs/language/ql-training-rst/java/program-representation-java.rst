======================
Program representation
======================

QL for Java

.. container:: semmle-logo

   Semmle :sup:`TM`

.. rst-class:: agenda

Agenda
======

- Abstract syntax trees
- Database representation
- Program elements
- AST classes

Abstract syntax trees
=====================

The basic representation of an analyzed program is an *abstract syntax tree (AST)*.

.. container:: column-left

   .. code-block:: java
   
     try {
         ...
     } catch (AnException e) {
     }

.. container:: ast-graph
     
      .. graphviz::
         
            digraph {
            graph [ dpi = 1000 ]
            node [shape=polygon,sides=4,color=blue4,style="filled,rounded",   fontname=consolas,fontcolor=white]
            a [label=<TryStmt>]
            b [label=<CatchClause>]
            c [label=<...>,color=white,fontcolor=black]
            d [label=<LocalVariable<BR />DeclExpr>]
            e [label=<...>,color=white,fontcolor=black]
            f [label=<...>,color=white,fontcolor=black]
            g [label=<...>,color=white,fontcolor=black]
   
            a -> {b, c}
            b -> {d, e}
            d -> {f, g}
         }



.. note::

  When writing queries in QL it is important to have in mind the underlying representation of the program which is stored in the database. Typically queries make use of the “AST” representation of the program - a tree structure where program elements are nested within other program elements.

  The “Introducing the Java libraries” help topic contains a more complete overview of important AST classes and the rest of the Java QL libraries: https://help.semmle.com/QL/learn-ql/ql/java/introduce-libraries-java.html 

Database representations of ASTs
================================

AST nodes and other program elements are encoded in the database as *entity values*. Entities are implemented as integers, but in QL they are opaque - all one can do with them is to check their equality.

Each entity belongs to an entity type. Entity types have names starting with “@” and are defined in the database schema (not in QL).

Properties of AST nodes and their relationships to each other are encoded by database relations, which are predicates defined in the database (not in QL).

Entity types are rarely used directly, the usual pattern is to define a QL class that extends the type and exposes properties of its entities through member predicates.

.. note::

  ASTs are a typical example of the kind of data representation one finds in object-oriented programming, with data-carrying nodes that reference each other. At first glance, QL, which can only work with atomic values, does not seem to be well suited for working with this kind of data. However, ultimately all that we require of the nodes in an AST is that they have an identity. The relationships among nodes, usually implemented by reference-valued object fields in other languages, can just as well (and arguably more naturally) be represented as relations over nodes. Attaching data (such as strings or numbers) to nodes can also be represented with relations over nodes and primitive values. All we need is a way for relations to reference nodes. This is achieved in QL (as in other database languages) by means of *entity values* (or entities, for short), which are opaque atomic values, implemented as integers under the hood.

  It is the job of the extractor to create entity values for all AST nodes and populate database relations that encode the relationship between AST nodes and any values associated with them. These relations are *extensional*, that is, explicitly stored in the database, unlike the relations described by QL predicates, which we also refer to as *intensional* relations. Entity values belong to *entity types*, whose name starts with “@” to set them apart from primitive types and classes.

  The interface between entity types and extensional relations on the one hand and QL predicates and classes on the other hand is provided by the *database schema*, which defines the available entity types and the schema of each extensional relation, that is, how many columns the relation has, and which entity type or primitive type the values in each column come from. QL programs can refer to entity types and extensional relations just as they would refer to QL classes and predicates, with the restriction that entity types cannot be directly selected in a “select” clause, since they do not have a well-defined string representation.

  For example, the database schema for Java snapshot databases is here: https://github.com/Semmle/ql/blob/master/java/ql/src/config/semmlecode.dbscheme 


Program elements
================

- The QL class ``Element`` represents program elements with a name.
- This includes: packages (``Package``), compilation units (``CompilationUnit``), types (``Type``), methods (``Method``), constructors (``Constructor``), and variables (``Variable``).
- It is often convenient to refer to an element that might either be a method or a constructor; the class ``Callable``, which is a common superclass of ``Method`` and ``Constructor``, can be used for this purpose.

.. note::

  The “Introducing the Java libraries” help topic contains a more complete overview of important AST classes and the rest of the Java QL libraries: https://help.semmle.com/QL/learn-ql/ql/java/introduce-libraries-java.html 

AST
===

There are two primary AST classes, used within ``Callables``:

   - ``Expr``: expressions such as assignments, variable references, function calls, ...
   - ``Stmt``: statements such as conditionals, loops, try statements, ... 

Operations are provided for exploring the AST:

   - ``Expr.getAChildExpr`` returns a sub-expression of a given expression.
   - ``Stmt.getAChild`` returns a statement or expression that is nested directly inside a given statement.
   - ``Expr.getParent`` and ``Stmt.getParent`` return the parent node of an AST node.

.. note::

  The “Introducing the Java libraries” help topic contains a more complete overview of important AST classes and the rest of the Java QL libraries: https://help.semmle.com/QL/learn-ql/ql/java/introduce-libraries-java.html 

Types
=====

The database also includes information about the types used in a program:

- ``PrimitiveType`` represents a `primitive type <http://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html>`__, that is, one of ``boolean``, ``byte``, ``char``, ``double``, ``float``, ``int``, ``long``, ``short``. QL also classifies ``void`` and ``<nulltype>`` (the type of the ``null`` literal) as primitive types.
- ``RefType`` represents a reference type; it has several subclasses:

  - ``Class`` represents a Java class.
  - ``Interface`` represents a Java interface.
  - ``EnumType`` represents a Java enum type.
  - ``Array`` represents a Java array type.

.. note::

  The “Introducing the Java libraries” help topic contains a more complete overview of important AST classes and the rest of the Java QL libraries: https://help.semmle.com/QL/learn-ql/ql/java/introduce-libraries-java.html 

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

Callables are represented by the ``Callable`` QL class. 

Calls to callables are modeled by the QL class ``Call`` and its subclasses:

- ``Call.getCallee()`` gets the declared target of the call
- ``Call.getAReference()`` gets a call to this function

Typically, callables are identified by name:

- ``string Callable.getName()``
- ``string Callable.getQualifiedName()``

.. rst-class:: java-expression-ast

Example: Java expression AST
============================

.. diagram copied from google slides