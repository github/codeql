.. _codeql-library-for-java:

CodeQL library for Java
=======================

When you're analyzing a Java program, you can make use of the large collection of classes in the CodeQL library for Java.

About the CodeQL library for Java
---------------------------------

There is an extensive library for analyzing CodeQL databases extracted from Java projects. The classes in this library present the data from a database in an object-oriented form and provide abstractions and predicates to help you with common analysis tasks.

The library is implemented as a set of QL modules, that is, files with the extension ``.qll``. The module ``java.qll`` imports all the core Java library modules, so you can include the complete library by beginning your query with:

.. code-block:: ql

   import java

The rest of this article briefly summarizes the most important classes and predicates provided by this library.

.. pull-quote::

   Note

   The example queries in this article illustrate the types of results returned by different library classes. The results themselves are not interesting but can be used as the basis for developing a more complex query. The other articles in this section of the help show how you can take a simple query and fine-tune it to find precisely the results you're interested in.

Summary of the library classes
------------------------------

The most important classes in the standard Java library can be grouped into five main categories:

#. Classes for representing program elements (such as classes and methods)
#. Classes for representing AST nodes (such as statements and expressions)
#. Classes for representing metadata (such as annotations and comments)
#. Classes for computing metrics (such as cyclomatic complexity and coupling)
#. Classes for navigating the program's call graph

We will discuss each of these in turn, briefly describing the most important classes for each category.

Program elements
----------------

These classes represent named program elements: packages (``Package``), compilation units (``CompilationUnit``), types (``Type``), methods (``Method``), constructors (``Constructor``), and variables (``Variable``).

Their common superclass is ``Element``, which provides general member predicates for determining the name of a program element and checking whether two elements are nested inside each other.

It's often convenient to refer to an element that might either be a method or a constructor; the class ``Callable``, which is a common superclass of ``Method`` and ``Constructor``, can be used for this purpose.

Types
~~~~~

Class ``Type`` has a number of subclasses for representing different kinds of types:

-  ``PrimitiveType`` represents a `primitive type <https://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html>`__, that is, one of ``boolean``, ``byte``, ``char``, ``double``, ``float``, ``int``, ``long``, ``short``; QL also classifies ``void`` and ``<nulltype>`` (the type of the ``null`` literal) as primitive types.
-  ``RefType`` represents a reference (that is, non-primitive) type; it in turn has several subclasses:

   -  ``Class`` represents a Java class.
   -  ``Interface`` represents a Java interface.
   -  ``EnumType`` represents a Java ``enum`` type.
   -  ``Array`` represents a Java array type.

For example, the following query finds all variables of type ``int`` in the program:

.. code-block:: ql

   import java

   from Variable v, PrimitiveType pt
   where pt = v.getType() and
       pt.hasName("int")
   select v

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/860076406167044435/>`__. You're likely to get many results when you run this query because most projects contain many variables of type ``int``.

Reference types are also categorized according to their declaration scope:

-  ``TopLevelType`` represents a reference type declared at the top-level of a compilation unit.
-  ``NestedType`` is a type declared inside another type.

For instance, this query finds all top-level types whose name is not the same as that of their compilation unit:

.. code-block:: ql

   import java

   from TopLevelType tl
   where tl.getName() != tl.getCompilationUnit().getName()
   select tl

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/4340983612585284460/>`__. This pattern is seen in many projects. When we ran it on the LGTM.com demo projects, most of the projects had at least one instance of this problem in the source code. There were many more instances in the files referenced by the source code.

Several more specialized classes are available as well:

-  ``TopLevelClass`` represents a class declared at the top-level of a compilation unit.
-  ``NestedClass`` represents `a class declared inside another type <https://docs.oracle.com/javase/tutorial/java/javaOO/nested.html>`__, such as:

   -  A ``LocalClass``, which is `a class declared inside a method or constructor <https://docs.oracle.com/javase/tutorial/java/javaOO/localclasses.html>`__.
   -  An ``AnonymousClass``, which is an `anonymous class <https://docs.oracle.com/javase/tutorial/java/javaOO/anonymousclasses.html>`__.

Finally, the library also has a number of singleton classes that wrap frequently used Java standard library classes: ``TypeObject``, ``TypeCloneable``, ``TypeRuntime``, ``TypeSerializable``, ``TypeString``, ``TypeSystem`` and ``TypeClass``. Each CodeQL class represents the standard Java class suggested by its name.

As an example, we can write a query that finds all nested classes that directly extend ``Object``:

.. code-block:: ql

   import java

   from NestedClass nc
   where nc.getASupertype() instanceof TypeObject
   select nc

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/8482509736206423238/>`__. You're likely to get many results when you run this query because many projects include nested classes that extend ``Object`` directly.

Generics
~~~~~~~~

There are also several subclasses of ``Type`` for dealing with generic types.

A ``GenericType`` is either a ``GenericInterface`` or a ``GenericClass``. It represents a generic type declaration such as interface ``java.util.Map`` from the Java standard library:

.. code-block:: java

   package java.util.;

   public interface Map<K, V> {
       int size();

       // ...
   }

Type parameters, such as ``K`` and ``V`` in this example, are represented by class ``TypeVariable``.

A parameterized instance of a generic type provides a concrete type to instantiate the type parameter with, as in ``Map<String, File>``. Such a type is represented by a ``ParameterizedType``, which is distinct from the ``GenericType`` representing the generic type it was instantiated from. To go from a ``ParameterizedType`` to its corresponding ``GenericType``, you can use predicate ``getSourceDeclaration``.

For instance, we could use the following query to find all parameterized instances of ``java.util.Map``:

.. code-block:: ql

   import java

   from GenericInterface map, ParameterizedType pt
   where map.hasQualifiedName("java.util", "Map") and
       pt.getSourceDeclaration() = map
   select pt

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/7863873821043873550/>`__. None of the LGTM.com demo projects contain parameterized instances of ``java.util.Map`` in their source code, but they all have results in reference files.

In general, generic types may restrict which types a type parameter can be bound to. For instance, a type of maps from strings to numbers could be declared as follows:

.. code-block:: java

   class StringToNumMap<N extends Number> implements Map<String, N> {
       // ...
   }

This means that a parameterized instance of ``StringToNumberMap`` can only instantiate type parameter ``N`` with type ``Number`` or one of its subtypes but not, for example, with ``File``. We say that N is a bounded type parameter, with ``Number`` as its upper bound. In QL, a type variable can be queried for its type bound using predicate ``getATypeBound``. The type bounds themselves are represented by class ``TypeBound``, which has a member predicate ``getType`` to retrieve the type the variable is bounded by.

As an example, the following query finds all type variables with type bound ``Number``:

.. code-block:: ql

   import java

   from TypeVariable tv, TypeBound tb
   where tb = tv.getATypeBound() and
       tb.getType().hasQualifiedName("java.lang", "Number")
   select tv

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/6740696080876162817/>`__. When we ran it on the LGTM.com demo projects, the *neo4j/neo4j*, *hibernate/hibernate-orm* and *apache/hadoop* projects all contained examples of this pattern.

For dealing with legacy code that is unaware of generics, every generic type has a "raw" version without any type parameters. In the CodeQL libraries, raw types are represented using class ``RawType``, which has the expected subclasses ``RawClass`` and ``RawInterface``. Again, there is a predicate ``getSourceDeclaration`` for obtaining the corresponding generic type. As an example, we can find variables of (raw) type ``Map``:

.. code-block:: ql

   import java

   from Variable v, RawType rt
   where rt = v.getType() and
       rt.getSourceDeclaration().hasQualifiedName("java.util", "Map")
   select v

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/4032913402499547882/>`__. Many projects have variables of raw type ``Map``.

For example, in the following code snippet this query would find ``m1``, but not ``m2``:

.. code-block:: java

   Map m1 = new HashMap();
   Map<String, String> m2 = new HashMap<String, String>();

Finally, variables can be declared to be of a `wildcard type <https://docs.oracle.com/javase/tutorial/java/generics/wildcards.html>`__:

.. code-block:: java

   Map<? extends Number, ? super Float> m;

The wildcards ``? extends Number`` and ``? super Float`` are represented by class ``WildcardTypeAccess``. Like type parameters, wildcards may have type bounds. Unlike type parameters, wildcards can have upper bounds (as in ``? extends Number``), and also lower bounds (as in ``? super Float``). Class ``WildcardTypeAccess`` provides member predicates ``getUpperBound`` and ``getLowerBound`` to retrieve the upper and lower bounds, respectively.

For dealing with generic methods, there are classes ``GenericMethod``, ``ParameterizedMethod`` and ``RawMethod``, which are entirely analogous to the like-named classes for representing generic types.

For more information on working with types, see the :doc:`Types in Java <types-in-java>`.

Variables
~~~~~~~~~

Class ``Variable`` represents a variable `in the Java sense <https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html>`__, which is either a member field of a class (whether static or not), or a local variable, or a parameter. Consequently, there are three subclasses catering to these special cases:

-  ``Field`` represents a Java field.
-  ``LocalVariableDecl`` represents a local variable.
-  ``Parameter`` represents a parameter of a method or constructor.

Abstract syntax tree
--------------------

Classes in this category represent abstract syntax tree (AST) nodes, that is, statements (class ``Stmt``) and expressions (class ``Expr``). For a full list of expression and statement types available in the standard QL library, see ":doc:`Abstract syntax tree classes for working with Java programs <abstract-syntax-tree-classes-for-working-with-java-programs>`."

Both ``Expr`` and ``Stmt`` provide member predicates for exploring the abstract syntax tree of a program:

-  ``Expr.getAChildExpr`` returns a sub-expression of a given expression.
-  ``Stmt.getAChild`` returns a statement or expression that is nested directly inside a given statement.
-  ``Expr.getParent`` and ``Stmt.getParent`` return the parent node of an AST node.

For example, the following query finds all expressions whose parents are ``return`` statements:

.. code-block:: ql

   import java

   from Expr e
   where e.getParent() instanceof ReturnStmt
   select e

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1947757851560375919/>`__. Many projects have examples of ``return`` statements with child expressions.

Therefore, if the program contains a return statement ``return x + y;``, this query will return ``x + y``.

As another example, the following query finds statements whose parent is an ``if`` statement:

.. code-block:: ql

   import java

   from Stmt s
   where s.getParent() instanceof IfStmt
   select s

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1989464153689219612/>`__. Many projects have examples of ``if`` statements with child statements.

This query will find both ``then`` branches and ``else`` branches of all ``if`` statements in the program.

Finally, here is a query that finds method bodies:

.. code-block:: ql

   import java

   from Stmt s
   where s.getParent() instanceof Method
   select s

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1016821702972128245/>`__. Most projects have many method bodies.

As these examples show, the parent node of an expression is not always an expression: it may also be a statement, for example, an ``IfStmt``. Similarly, the parent node of a statement is not always a statement: it may also be a method or a constructor. To capture this, the QL Java library provides two abstract class ``ExprParent`` and ``StmtParent``, the former representing any node that may be the parent node of an expression, and the latter any node that may be the parent node of a statement.

For more information on working with AST classes, see the :doc:`article on overflow-prone comparisons in Java <overflow-prone-comparisons-in-java>`.

Metadata
--------

Java programs have several kinds of metadata, in addition to the program code proper. In particular, there are `annotations <https://docs.oracle.com/javase/tutorial/java/annotations/>`__ and `Javadoc <https://en.wikipedia.org/wiki/Javadoc>`__ comments. Since this metadata is interesting both for enhancing code analysis and as an analysis subject in its own right, the QL library defines classes for accessing it.

For annotations, class ``Annotatable`` is a superclass of all program elements that can be annotated. This includes packages, reference types, fields, methods, constructors, and local variable declarations. For every such element, its predicate ``getAnAnnotation`` allows you to retrieve any annotations the element may have. For example, the following query finds all annotations on constructors:

.. code-block:: ql

   import java

   from Constructor c
   select c.getAnAnnotation()

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/3206112561297137365/>`__. The LGTM.com demo projects all use annotations, you can see examples where they are used to suppress warnings and mark code as deprecated.

These annotations are represented by class ``Annotation``. An annotation is simply an expression whose type is an ``AnnotationType``. For example, you can amend this query so that it only reports deprecated constructors:

.. code-block:: ql

   import java

   from Constructor c, Annotation ann, AnnotationType anntp
   where ann = c.getAnAnnotation() and
       anntp = ann.getType() and
       anntp.hasQualifiedName("java.lang", "Deprecated")
   select ann

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/5393027107459215059/>`__. Only constructors with the ``@Deprecated`` annotation are reported this time.

For more information on working with annotations, see the :doc:`article on annotations <annotations-in-java>`.

For Javadoc, class ``Element`` has a member predicate ``getDoc`` that returns a delegate ``Documentable`` object, which can then be queried for its attached Javadoc comments. For example, the following query finds Javadoc comments on private fields:

.. code-block:: ql

   import java

   from Field f, Javadoc jdoc
   where f.isPrivate() and
       jdoc = f.getDoc().getJavadoc()
   select jdoc

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/6022769142134600659/>`__. You can see this pattern in many projects.

Class ``Javadoc`` represents an entire Javadoc comment as a tree of ``JavadocElement`` nodes, which can be traversed using member predicates ``getAChild`` and ``getParent``. For instance, you could edit the query so that it finds all ``@author`` tags in Javadoc comments on private fields:

.. code-block:: ql

   import java

   from Field f, Javadoc jdoc, AuthorTag at
   where f.isPrivate() and
       jdoc = f.getDoc().getJavadoc() and
       at.getParent+() = jdoc
   select at

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/2510220694395289111/>`__. None of the LGTM.com demo projects uses the ``@author`` tag on private fields.

.. pull-quote::

   Note

   On line 5 we used ``getParent+`` to capture tags that are nested at any depth within the Javadoc comment.

For more information on working with Javadoc, see the :doc:`article on Javadoc <javadoc>`.

Metrics
-------

The standard QL Java library provides extensive support for computing metrics on Java program elements. To avoid overburdening the classes representing those elements with too many member predicates related to metric computations, these predicates are made available on delegate classes instead.

Altogether, there are six such classes: ``MetricElement``, ``MetricPackage``, ``MetricRefType``, ``MetricField``, ``MetricCallable``, and ``MetricStmt``. The corresponding element classes each provide a member predicate ``getMetrics`` that can be used to obtain an instance of the delegate class, on which metric computations can then be performed.

For example, the following query finds methods with a `cyclomatic complexity <https://en.wikipedia.org/wiki/Cyclomatic_complexity>`__ greater than 40:

.. code-block:: ql

   import java

   from Method m, MetricCallable mc
   where mc = m.getMetrics() and
       mc.getCyclomaticComplexity() > 40
   select m

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/6566950741051181919/>`__. Most large projects include some methods with a very high cyclomatic complexity. These methods are likely to be difficult to understand and test.

Call graph
----------

CodeQL databases generated from Java code bases include precomputed information about the program's call graph, that is, which methods or constructors a given call may dispatch to at runtime.

The class ``Callable``, introduced above, includes both methods and constructors. Call expressions are abstracted using class ``Call``, which includes method calls, ``new`` expressions, and explicit constructor calls using ``this`` or ``super``.

We can use predicate ``Call.getCallee`` to find out which method or constructor a specific call expression refers to. For example, the following query finds all calls to methods called ``println``:

.. code-block:: ql

   import java

   from Call c, Method m
   where m = c.getCallee() and
       m.hasName("println")
   select c

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/5861255162551917595/>`__. The LGTM.com demo projects all include many calls to methods of this name.

Conversely, ``Callable.getAReference`` returns a ``Call`` that refers to it. So we can find methods and constructors that are never called using this query:

.. code-block:: ql

   import java

   from Callable c
   where not exists(c.getAReference())
   select c

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/7261739919657747703/>`__. The LGTM.com demo projects all appear to have many methods that are not called directly, but this is unlikely to be the whole story. To explore this area further, see ":doc:`Navigating the call graph <navigating-the-call-graph>`."

For more information about callables and calls, see the :doc:`article on the call graph <navigating-the-call-graph>`.

Further reading
---------------

.. include:: ../../reusables/java-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
