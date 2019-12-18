.. _name-resolution:

Name resolution
###############

As in other programming languages, there is a distinction between the names used in QL code, 
and the underlying QL entities they refer to.

It is possible for different entities in QL to have the same name, for example if they are 
defined in separate modules. Therefore, it is important that the QL compiler can resolve the 
name to the correct entity. 

When you write your own QL, you can use different kinds of expressions to refer to entities. 
Those expressions are then resolved to QL entities in the appropriate :ref:`namespace <namespaces>`.

In summary, the kinds of expressions are:
  - **Module expressions**
      - These refer to modules.
      - They can be simple :ref:`names <names>`, :ref:`qualified references <qualified-references>` 
        (in import statements), or :ref:`selections <selections>`.
  - **Type expressions**
      - These refer to types.
      - They can be simple :ref:`names <names>` or :ref:`selections <selections>`.
  - **Predicate expressions**
      - These refer to predicates.
      - They can be simple :ref:`names <names>` or names with arities (for example in an :ref:`alias <aliases>`
        definition), or :ref:`selections <selections>`.

.. _names:

Names
*****

To resolve a simple name (with arity), the compiler looks for that name (and arity)
in the :ref:`namespaces <namespaces>` of the current module.

In an :ref:`import statement <import-statements>`, name resolution is slightly more complicated.
For example, suppose you define a :ref:`query module <query-modules>` ``Example.ql`` with the 
following import statement::

    import javascript

The compiler first checks for a :ref:`library module <library-modules>` ``javascript.qll``, 
using the steps described below for qualified references. If that fails, it checks for an 
:ref:`explicit module <explicit-modules>` named ``javascript`` defined in the 
:ref:`module namespace <namespaces>` of ``Example.ql``.

.. _qualified-references:

Qualified references
********************

A qualified reference is a module expression that uses ``.`` as a file path separator. You can
only use such an expression in :ref:`import statements <import-statements>`, to import a 
library module defined by a relative path.

For example, suppose you define a :ref:`query module <query-modules>` ``Example.ql`` with the 
following import statement::

    import examples.security.MyLibrary

To find the precise location of this library module, the QL compiler processes the import 
statement as follows:

  #. The ``.``\ s in the qualified reference correspond to file path separators, so it first looks 
     up ``examples/security/MyLibrary.qll`` from the directory containing ``Example.ql``. 

  #. If that fails, it looks up ``examples/security/MyLibrary.qll`` relative to the enclosing query 
     directory, if any. 
     This query directory is a directory containing a |queries.xml file|_, and where the contents 
     of that file is compatible with the current database schema.
     (For example, if you are querying a JavaScript database, then the |queries.xml file|_ should 
     contain ``<queries language="javascript"/>``.) 
  
  #. If no file is found using the above two checks, it looks up ``examples/security/MyLibrary.qll``
     relative to each library path entry. The library path depends on the environment where you 
     run your query, and whether you have specified any extra settings.
     
.. |queries.xml file| replace:: ``queries.xml`` file
.. _queries.xml file: https://help.semmle.com/wiki/display/SD/queries.xml+file

If the compiler cannot resolve an import statement, then it gives a compilation error.

This process is described in more detail in the section on `module resolution <https://help.semmle.com/QL/ql-spec/language.html#module-resolution>`_
in the QL language specification.

.. _selections:

Selections
**********

You can use a selection to refer to a module, type, or predicate inside a particular 
module. A selection is of the form::

    <module_expression>::<name>

The compiler resolves the module expression first, and then looks for the name in 
the :ref:`namespaces <namespaces>` for that module.

Example
=======

Consider the following :ref:`library module <library-modules>`:

**CountriesLib.qll**

:: 

    class Countries extends string {
      Countries() {
        this = "Belgium"
        or
        this = "France"
        or
        this = "India"
      }
    }

    module M {
      class EuropeanCountries extends Countries {
        EuropeanCountries() {
          this = "Belgium"
          or
          this = "France"
        }
      }
    }

You could write a query that imports ``CountriesLib`` and then uses ``M::EuropeanCountries``
to refer to the class ``EuropeanCountries``:: 

    import CountriesLib

    from M::EuropeanCountries ec 
    select ec

Alternatively, you could import the contents of ``M`` directly by using the selection
``CountriesLib::M`` in the import statement:: 

    import CountriesLib::M 

    from EuropeanCountries ec 
    select ec

That gives the query access to everything within ``M``, but nothing within ``CountriesLib`` that
isn't also in ``M``.

.. index:: namespace
.. _namespaces:

Namespaces
**********

When writing QL, it's useful to understand how namespaces (also known as 
`environments <https://help.semmle.com/QL/ql-spec/language.html#name-resolution>`_) work.

As in many other programming languages, a namespace is a mapping from **keys** to
**entities**. A key is a kind of identifier, for example a name, and a QL entity is
a :ref:`module <modules>`, a :ref:`type <types>`, or a :ref:`predicate <predicates>`.

Each module in QL has three namespaces:

    - The **module namespace**, where the keys are module names and the entities are modules.
    - The **type namespace**, where the keys are type names and the entities are types.
    - The **predicate namespace**, where the keys are pairs of predicate names and arities, 
      and the entities are predicates.

It's important to know that there is no relation between names in different namespaces. 
For example, two different modules can define a predicate ``getLocation()`` without confusion. As long as 
it's clear which namespace you are in, the QL compiler resolves the name to the correct predicate.

Global namespaces
=================

The namespaces containing all the built-in entities are called **global namespaces**, 
and are automatically available in any module.
In particular: 

    - The **global module namespace** is empty.
    - The **global type namespace** has entries for the :ref:`primitive types <primitive-types>` ``int``, ``float``, 
      ``string``, ``boolean``, and ``date``, as well as any :ref:`database types <database-types>` defined in the database schema.
    - The **global predicate namespace** includes all the `built-in predicates <https://help.semmle.com/QL/ql-spec/language.html#built-ins>`_,
      as well as any :ref:`database predicates <database-predicates>`.

In practice, this means that you can use the built-in types and predicates directly in a QL module (without
importing any libraries). You can also use any database predicates and types directly—these depend on the
underlying database that you are querying.

Local namespaces
================

In addition to the global module, type, and predicate namespaces, each module defines a number of local 
module, type, and predicate namespaces.

For a module ``M``, it's useful to distinguish between its **declared**, **exported**, and **imported** namespaces. 
(These are described generically, but remember that there is always one for each of modules, types, and predicates.)

    - The **declared** namespaces contain any names that are declared—that is, defined—in ``M``.
    - The **imported** namespaces contain any names exported by the modules that are imported into ``M`` using an 
      :ref:`import statement <import-statements>`.
    - The **exported** namespaces contain any names declared in ``M``, or exported from a module imported into ``M``, 
      except names annotated with ``private``. This includes everything in the imported namespaces that was not introduced
      by a private import.

This is easiest to understand in an example: 

**OneTwoThreeLib.qll**

::

    import MyFavoriteNumbers

    class OneTwoThree extends int {
      OneTwoThree() {
        this = 1 or this = 2 or this = 3
      }
    }

    private module P {
      class OneTwo extends OneTwoThree {
        OneTwo() {
          this = 1 or this = 2
        }
      }
    }

The module ``OneTwoThreeLib`` **imports** anything that is exported by the module ``MyFavoriteNumbers``.

It **declares** the class ``OneTwoThree`` and the module ``P``.

It **exports** the class ``OneTwoThree`` and anything that is exported by ``MyFavoriteNumbers``. 
It does not export ``P``, since it is annotated with ``private``.

Example
=======

The namespaces of a general QL module are a union of the local namespaces, the namespaces of any enclosing modules, 
and the global namespaces. (You can think of global namespaces as the enclosing namespaces of a top-level module.)

Let's see what the module, type, and predicate namespaces look like in a concrete example:

For example, you could define a library module ``Villagers`` containing some of the classes and predicates that 
were defined in the `QL detective tutorials <https://help.semmle.com/QL/learn-ql/beginner/ql-tutorials.html>`_:
    
**Villagers.qll**

::    

    import tutorial
        
    predicate isBald(Person p) {
      not exists(string c | p.getHairColor() = c)
    }
 
    class Child extends Person {
      Child() { 
        this.getAge() < 10 
      }
    }

    module S {
      predicate isSouthern(Person p) {
        p.getLocation() = "south"
      }
      
      class Southerner extends Person {
        Southerner() {
          isSouthern(this)
        }
      }
    }

**Module namespace**

The module namespace of ``Villagers`` has entries for: 
    - The module ``S``.
    - Any modules exported by ``tutorial``.

The module namespace of ``S`` also has entries for the module ``S`` itself, and for any 
modules exported by ``tutorial``.

**Type namespace**

The type namespace of ``Villagers`` has entries for:
    - The class ``Child``.
    - The types exported by the module ``tutorial``.
    - The built-in types, namely ``int``, ``float``, ``string``, ``date``, and ``boolean``.

The type namespace of ``S`` has entries for:
    - All the above types.
    - The class ``Southerner``.

**Predicate namespace**

The predicate namespace of ``Villagers`` has entries for:
    - The predicate ``isBald``, with arity 1.
    - Any predicates (and their arities) exported by ``tutorial``. 
    - The `built-in predicates <https://help.semmle.com/QL/ql-spec/language.html#built-ins>`_.

The predicate namespace of ``S`` has entries for:
    - All the above predicates.
    - The predicate ``isSouthern``, with arity 1.
