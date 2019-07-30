Semantics of abstract classes
=============================

Concrete classes
----------------

Concrete QL classes, as described in the QL language handbook topic on `Classes <https://help.semmle.com/QL/ql-handbook/types.html#classes>`__, lend themselves well to top-down modeling. We start from general superclasses representing large sets of values, and carve out individual subclasses representing more restricted sets of values.

A classic example where this approach is useful is when modeling ASTs (Abstract Syntax Trees): the node types of an AST form a natural inheritance hierarchy, where, for example, there is a class ``Expr`` representing all expression nodes, with many different subclasses for different categories of expressions. There might be a class ``ArithmeticExpr`` representing arithmetic expressions, which in turn could have subclasses ``AddExpr`` and ``SubExpr``.

Each value in a concrete class satisfies a particular logical property - the *characteristic predicate* (or *character* for short) of that class. This characteristic predicate consists of the conjunction (``and``) of its own body (if any) and the characteristic predicates of its superclasses.

For example, we could derive a subclass ``MainMethod`` from the standard QL class ``Method`` that contains precisely those Java functions called ``"main"``:

.. code-block:: ql

   class MainMethod extends Method {
       MainMethod() {
           hasName("main")
       }
   }

.. pull-quote::

   Note

   -  A class ``A`` *extends* a class ``B`` if and only if ``A`` is a subclass of ``B``.
   -  For a class in QL, the *body* of the characteristic predicate is the logical formula enclosed in curly braces that defines (membership of) the class. In the example, the body of the characteristic predicate of ``MainMethod`` is ``hasName("main")``.

Letting ``cp(C)`` denote the characteristic predicate of class ``C``, it is clear that:

.. code-block:: ql

   cp(MainMethod) = cp(Method) and hasName("main")

That is, entities are *main* methods if and only if they are methods that are also called ``"main"``.

Abstract classes
----------------

In some cases, you might prefer to think of a class as being the union of its subclasses. This can be useful if you want to group multiple existing classes together under a common header and define member predicates on all these classes.

For example, the security queries in LGTM are interested in identifying all expressions that may be interpreted as SQL queries. We could define an abstract class

.. code-block:: ql

   abstract class SqlExpr extends Expr {
       ...
   }

with various subclasses that identify expressions of interest for different database access libraries. For example, there could be a subclass ``class PostgresSqlExpr extends SqlExpr`` whose character specifies that this must be an expression passed to some Postgres API that performs a database query, and similarly for MySQL and other kinds of database management systems.

We can simply use ``SqlExpr`` to refer to all of those different expressions. If we want to add support for another database system later on, we can simply add a new subclass to ``SqlExpr``; there is no need to update the queries that rely on it.

Like a concrete class, an abstract class has one or more superclasses and a characteristic predicate. However, for a value to be in an abstract class, it must not only satisfy the character of the class itself, but it must also satisfy the character of a subclass. In particular, an abstract class without subclasses is empty – since there are no subclasses, there are no values that satisfy the characteristic predicate of one of the subclasses.

Example
~~~~~~~

The following example is taken from the standard QL library for Java:

.. code-block:: ql

   abstract class SwitchCase extends Stmt {
   }

   /** A constant case of a switch statement. */
   class ConstCase extends SwitchCase, @case {
     ConstCase() { exists(Expr e | e.getParent() = this) }

     ...
   }

   /** A default case of a switch statement. */
   class DefaultCase extends SwitchCase, @case {
     DefaultCase() { not exists(Expr e | e.getParent() = this) }

     ...
   }

It models the two different types of ``case`` in a ``switch`` statement: constant cases of the form ``case e`` that have an expression e, and default cases ``default`` that do not.

The characteristic predicate of ``SwitchCase`` here is as follows:

.. code-block:: ql

   cp(SwitchCase) = cp(Stmt) and (
                    cp(@case) and exists(Expr e | e.getParent() = this)
                    or
                    cp(@case) and not exists(Expr e | e.getParent() = this)
                    )

You must take care when you add a new subclass to an existing abstract class. Adding a subclass is not an isolated change, it also extends the abstract class since that is a union of its subclasses.  An extreme example would be extending the ``Call`` class as follows:

.. code-block:: ql

   class CallEx extends Call {
       predicate somethingUseful()
       {
            ...
       }
   } 

In this situation, ``cp(CallEx) = cp(Call)``, and then:

.. code-block:: ql

   cp(Call) = cp(Expr) and (cp(FunctionCall) or ... or cp(DestructorCall) or cp(Call)) = cp(Expr)

So by adding a bad subclass of ``Call``, we have actually extended ``Call`` to include everything in ``Expr``. This is surprising and completely undesirable. Whilst the specific situation of extending an abstract class without providing any further constraints is now checked for by the QL compiler, extending abstract classes in general is still potentially hazardous. You should think carefully about the effects on the abstract parent class when doing so.