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

  When writing queries it is important to have in mind the underlying representation of the program which is stored in the database. Typically queries make use of the “AST” representation of the program - a tree structure where program elements are nested within other program elements.

  The following topics contain overviews of the important AST classes and CodeQL libraries for C/C++, C#, and Java: 
  
  - `CodeQL library for C/C++ <https://codeql.github.com/docs/codeql-language-guides/codeql-library-for-cpp/>`__ 
  - `CodeQL library for C# <https://codeql.github.com/docs/codeql-language-guides/codeql-library-for-csharp/>`__
  - `CodeQL library for Java <https://codeql.github.com/docs/codeql-language-guides/codeql-library-for-java/>`__  


Database representations of ASTs
================================

AST nodes and other program elements are encoded in the database as *entity values*. Entities are implemented as integers, but in QL they are opaque---all one can do with them is to check their equality.

Each entity belongs to an entity type. Entity types have names starting with “@” and are defined in the database schema (not in QL).

Properties of AST nodes and their relationships to each other are encoded by database relations, which are predicates defined in the database (not in QL).

Entity types are rarely used directly, the usual pattern is to define a class that extends the type and exposes properties of its entities through member predicates.

.. note::

  ASTs are a typical example of the kind of data representation one finds in object-oriented programming, with data-carrying nodes that reference each other. At first glance, QL, which can only work with atomic values, does not seem to be well suited for working with this kind of data. However, ultimately all that we require of the nodes in an AST is that they have an identity. The relationships among nodes, usually implemented by reference-valued object fields in other languages, can just as well (and arguably more naturally) be represented as relations over nodes. Attaching data (such as strings or numbers) to nodes can also be represented with relations over nodes and primitive values. All we need is a way for relations to reference nodes. This is achieved in QL (as in other database languages) by means of *entity values* (or entities, for short), which are opaque atomic values, implemented as integers under the hood.

  It is the job of the extractor to create entity values for all AST nodes and populate database relations that encode the relationship between AST nodes and any values associated with them. These relations are *extensional*, that is, explicitly stored in the database, unlike the relations described by predicates, which we also refer to as *intensional* relations. Entity values belong to *entity types*, whose name starts with “@” to set them apart from primitive types and classes.

  The interface between entity types and extensional relations on the one hand and QL predicates and classes on the other hand is provided by the *database schema*, which defines the available entity types and the schema of each extensional relation, that is, how many columns the relation has, and which entity type or primitive type the values in each column come from. QL programs can refer to entity types and extensional relations just as they would refer to QL classes and predicates, with the restriction that entity types cannot be directly selected in a ``select`` clause, since they do not have a well-defined string representation.

  For example, the database schemas for C/++, C#, and Java CodeQL databases are here: 
  
  - https://github.com/github/codeql/blob/main/cpp/ql/lib/semmlecode.cpp.dbscheme 
  - https://github.com/github/codeql/blob/main/csharp/ql/lib/semmlecode.csharp.dbscheme 
  - https://github.com/github/codeql/blob/main/java/ql/lib/config/semmlecode.dbscheme 