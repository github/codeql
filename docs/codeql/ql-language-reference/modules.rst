:tocdepth: 1

.. _modules:

Modules
#######
   
Modules provide a way of organizing QL code by grouping together related types, predicates, and other modules. 

You can import modules into other files, which avoids duplication, and helps 
structure your code into more manageable pieces.

.. _defining-module:

Defining a module
*****************

There are various ways to define modules—here is an example of the simplest way, declaring an
:ref:`explicit module  <explicit-modules>` named ``Example`` containing 
a class ``OneTwoThree``:

.. code-block:: ql

    module Example {
      class OneTwoThree extends int {
        OneTwoThree() {
          this = 1 or this = 2 or this = 3
        }
      }
    } 

The name of a module can be any `identifier <https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#identifiers>`_
that starts with an uppercase or lowercase letter. 

``.ql`` or ``.qll`` files also implicitly define modules.
For more information, see ":ref:`kinds-of-modules`."

You can also annotate a module. For more information, see of ":ref:`annotations-overview`."

Note that you can only annotate :ref:`explicit modules <explicit-modules>`. 
File modules cannot be annotated.

.. _kinds-of-modules:

Kinds of modules
****************

File modules
============

Each query file (extension ``.ql``) and library file (extension ``.qll``) implicitly defines 
a module. The module has the same name as the file, but any spaces in the file name are replaced
by underscores (``_``). The contents of the file form the :ref:`body of the module <module-bodies>`.

.. _library-modules:

Library modules
---------------

A library module is defined by a ``.qll`` file. It can contain any of the 
elements listed in :ref:`module-bodies` below, apart from select clauses.

For example, consider the following QL library:

**OneTwoThreeLib.qll**

.. code-block:: ql

    class OneTwoThree extends int {
      OneTwoThree() {
        this = 1 or this = 2 or this = 3
      }
    }

This file defines a library module named ``OneTwoThreeLib``. The body of this module
defines the class ``OneTwoThree``.

.. _query-modules: 

Query modules
-------------

A query module is defined by a ``.ql`` file. It can contain any of the elements listed 
in :ref:`module-bodies` below. 

Query modules are slightly different from other modules:

- A query module can't be imported.
- A query module must have at least one query in its 
  :ref:`namespace <namespaces>`. This is usually a :ref:`select clause <select-clauses>`, 
  but can also be a :ref:`query predicate <query-predicates>`.

For example:

**OneTwoQuery.ql**

.. code-block:: ql

    import OneTwoThreeLib
    
    from OneTwoThree ott
    where ott = 1 or ott = 2
    select ott

This file defines a query module named ``OneTwoQuery``. The body of this module consists of an
:ref:`import statement <importing-modules>` and a :ref:`select clause <select-clauses>`.

.. _explicit-modules:

Explicit modules
================

You can also define a module within another module. This is an explicit module definition. 

An explicit module is defined with the keyword ``module`` followed by 
the module name, and then the module body enclosed in braces. It can contain any 
of the elements listed in ":ref:`module-bodies`" below, apart from select clauses. 

For example, you could add the following QL snippet to the library file **OneTwoThreeLib.qll** 
defined :ref:`above <library-modules>`:

.. code-block:: ql

    ...
    module M {
      class OneTwo extends OneTwoThree {
        OneTwo() {
          this = 1 or this = 2
        }
      }
    }
    
This defines an explicit module named ``M``. The body of this module defines
the class ``OneTwo``.

.. _parameterized-modules:

Parameterized modules
=====================

Parameterized modules are QL's approach to generic programming.
Similar to explicit modules, parameterized modules are defined within other modules using the keyword ``module``.
In addition to the module name, parameterized modules declare one or more parameters between the name and the module body.

For example, consider the module ``M``, which takes two predicate parameters and defines a new predicate
that applies them one after the other:

.. code-block:: ql

    module M<transformer/1 first, transformer/1 second> {
      bindingset[x]
      int applyBoth(int x) {
        result = second(first(x))
      }
    }

Parameterized modules cannot be directly referenced.
Instead, you instantiate a parameterized module by passing arguments enclosed in angle brackets (``<`` and ``>``) to the module.
Instantiated parameterized modules can be used as a :ref:`module expression <name-resolution>`, identical to explicit module references.

For example, we can instantiate ``M`` with two identical arguments ``increment``, creating a module
containing a predicate that adds 2:

.. code-block:: ql

    bindingset[result] bindingset[x]
    int increment(int x) { result = x + 1 }

    module IncrementTwice = M<increment/1, increment/1>;

    select IncrementTwice::applyBoth(40) // 42

The parameters of a parameterized module are (meta-)typed with :ref:`signatures <signatures>`.

For example, in the previous two snippets, we relied on the predicate signature ``transformer``:

.. code-block:: ql

    bindingset[x]
    signature int transformer(int x);

The instantiation of parameterized modules is applicative.
That is, if you instantiate a parameterized module twice with identical arguments, the resulting object is the same.
This is particularly relevant for type definitions inside parameterized modules as :ref:`classes <classes>`
or via :ref:`newtype <algebraic-datatypes>`, because the duplication of such type definitions would result in
incompatible types.

The following example instantiates module ``M`` inside calls to predicate ``foo`` twice.
The first call is valid but the second call generates an error.

.. code-block:: ql

    bindingset[this]
    signature class TSig;

    module M<TSig T> {
      newtype A = B() or C()
    }

    string foo(M<int>::A a) { ... }

    select foo(M<int>::B()),  // valid: repeated identical instantiation of M does not duplicate A, B, C
           foo(M<float>::B()) // ERROR: M<float>::B is not compatible with M<int>::A

Module parameters are dependently typed, meaning that signature expressions in parameter definitions can reference
preceding parameters.

For example, we can declare the signature for ``T2`` dependent on ``T1``, enforcing a subtyping relationship
between the two parameters:

.. code-block:: ql

    signature class TSig;

    module Extends<TSig T> { signature class Type extends T; }

    module ParameterizedModule<TSig T1, Extends<T1>::Type T2> { ... }

Dependently typed parameters are particularly useful in combination with
:ref:`parameterized module signatures <parameterized-module-signatures>`.

.. _module-bodies:

Module bodies
*************

The body of a module is the code inside the module definition, for example
the class ``OneTwo`` in the :ref:`explicit module <explicit-modules>` ``M``. 

In general, the body of a module can contain the following constructs:

- :ref:`import-statements`
- :ref:`predicates`
- :ref:`types` (including user-defined :ref:`classes <classes>`)
- :ref:`aliases`
- :ref:`explicit-modules`
- :ref:`select-clauses` (only available in a :ref:`query module <query-modules>`)

.. index:: import
.. _importing-modules:

Importing modules
*****************

The main benefit of storing code in a module is that you can reuse it in other modules. 
To access the contents of an external module, you can import the module using an 
:ref:`import statement <import-statements>`.

When you import a module this brings all the names in its namespace, apart from :ref:`private` names, 
into the :ref:`namespace <namespaces>` of the current module.

.. _import-statements:

Import statements
=================

Import statements are used for importing modules. They are of the form:

.. code-block:: ql

    import <module_expression1> as <name>
    import <module_expression2>

Import statements are usually listed at the beginning of the module. Each
import statement imports one module. You can import multiple modules by 
including multiple import statements (one for each module you want to import).

An import statement can also be :ref:`annotated <annotations-overview>` with
``private`` or ``deprecated``. If an import statement is annotated with
``private`` then the imported names are not reexported. If an imported name is
only reachable through deprecated imports in a given context then usage of the
name in that context will generate deprecation warnings.

You can import a module under a different name using the ``as`` keyword, 
for example ``import javascript as js``.

The ``<module_expression>`` itself can be a module name, a selection, or a qualified
reference. For more information, see ":ref:`name-resolution`."

For information about how import statements are looked up, see "`Module resolution <https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#module-resolution>`__"
in the QL language specification. 

Built-in modules
****************

QL defines a ``QlBuiltins`` module that is always in scope.
Currently, it defines a single parameterized sub-module
``EquivalenceRelation``, that provides an efficient abstraction for working with
(partial) equivalence relations in QL.

Equivalence relations
=====================

The built-in ``EquivalenceRelation`` module is parameterized by a type ``T`` and a
binary base relation ``base`` on ``T``. The symmetric and transitive closure of ``base``
induces a partial equivalence relation on ``T``. If every value of ``T`` appears in
``base``, then the induced relation is an equivalence relation on ``T``.

The ``EquivalenceRelation`` module exports a ``getEquivalenceClass`` predicate that
gets the equivalence class, if any, associated with a given ``T`` element by the
(partial) equivalence relation induced by ``base``.

The following example illustrates an application of the ``EquivalenceRelation``
module to generate a custom equivalence relation:

.. code-block:: ql

  class Node extends int {
    Node() { this in [1 .. 6] }
  }

  predicate base(Node x, Node y) {
    x = 1 and y = 2
    or
    x = 3 and y = 4
  }

  module Equiv = QlBuiltins::EquivalenceRelation<Node, base/2>;

  from int x, int y
  where Equiv::getEquivalenceClass(x) = Equiv::getEquivalenceClass(y)
  select x, y

Since ``base`` does not relate ``5`` or ``6`` to any nodes, the induced
relation is a partial equivalence relation on ``Node`` and does not relate ``5``
or ``6`` to any nodes either.

The above select clause returns the following partial equivalence relation:

+---+---+
| x | y |
+===+===+
| 1 | 1 |
+---+---+
| 1 | 2 |
+---+---+
| 2 | 1 |
+---+---+
| 2 | 2 |
+---+---+
| 3 | 3 |
+---+---+
| 3 | 4 |
+---+---+
| 4 | 3 |
+---+---+
| 4 | 4 |
+---+---+
