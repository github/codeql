Constraining types
==================

Type constraint methods
-----------------------

.. pull-quote::

   Note

   The examples below use the CodeQL library for Java. All libraries support using these methods to constrain variables, the only difference is in the names of the classes used.

There are several ways of imposing type constraints on variables:

-  Use an ``instanceof`` test, for example:

   .. code-block:: ql

      import java

      from Type t
      where t instanceof Class
      select t

-  Use a cast, for example:

   .. code-block:: ql

      import java

      from Type t
      where t.(Class).getASupertype().hasName("List")
      select t

-  Set the variable equal to another variable with the required type using exists, for example:

   .. code-block:: ql

      import java

      from Type t
      where exists(Class c |
          c = t
          and c.getASupertype().hasName("List")
      )
      select t

-  Pass the variable to a predicate that expects a variable of the required type, for example:

   .. code-block:: ql

      import java

      predicate derivedFromList(Class c) {
          c.getASupertype().hasName("List")
      }

      from Type t
      where derivedFromList(t)
      select t

All of these methods constrain the variable ``t`` to have values of type ``Class``.

Choosing between the methods
----------------------------

These methods have advantages and disadvantages depending on the extent to which you need to work with the variable as the new type:

-  ``instanceof`` only checks that the variable has the required type.
-  A cast gives you one, and only one, access to the variable as the new type.
-  Creating a new variable with ``exists`` or a predicate parameter allows repeated access to the variable as the new type.

   -  Note that due to the ability to overload predicates in a class, predicates that belong to a class must be supplied with arguments of the exact type they specify, and so this technique will not work in that situation.
