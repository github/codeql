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
An import statement can also be :ref:`annotated <private>` with ``private``.

You can import a module under a different name using the ``as`` keyword, 
for example ``import javascript as js``.

The ``<module_expression>`` itself can be a module name, a selection, or a qualified
reference. For more information, see ":ref:`name-resolution`."

For information about how import statements are looked up, see "`Module resolution <https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#module-resolution>`__"
in the QL language specification. 