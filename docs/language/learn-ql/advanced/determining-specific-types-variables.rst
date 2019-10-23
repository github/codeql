Determining the most specific types of a variable
=================================================

It is sometimes useful to be able to determine what types an entity has -- especially when you are unfamiliar with the library used by a query. To help with this, there is a predicate called ``getAQlClass()``, which returns the most specific QL types of the entity that it is called on.

This can be useful when you are not sure of the most precise class of a value. Discovering a more precise class can allow you to cast to it and use predicates that are not available on the more general class.

Example
-------

If you were working with a Java database, you might use ``getAQlClass()`` on every ``Expr`` in a callable called ``c``:

**Java example**

.. code-block:: ql

   import java

   from Expr e, Callable c
   where
       c.getDeclaringType().hasQualifiedName("my.namespace.name", "MyClass")
       and c.getName() = "c"
       and e.getEnclosingCallable() = c
   select e, e.getAQlClass()

The result of this query is a list of the most specific types of every ``Expr`` in that function. You will see multiple results for some expressions because that expression is represented by more than one type.

For example, ``StringLiteral``\ s like ``"Hello"`` in Java belong to both the ``StringLiteral`` class (a specialization of the ``Literal`` class) and the ``CompileTimeConstantExpr`` class. So any instances of ``StringLiteral``\ s in the results will produce more than one result, one for each of the classes to which they belong.
