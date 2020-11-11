.. _troubleshooting-query-performance:

Troubleshooting query performance
=================================

Improve the performance of your CodeQL queries by following a few simple guidelines.

About query performance
-----------------------

This topic offers some simple tips on how to avoid common problems that can affect the performance of your queries.
Before reading the tips below, it is worth reiterating a few important points about CodeQL and the QL language:

- CodeQL :ref:`predicates <predicates>` and :ref:`classes <classes>` are evaluated to database `tables <https://en.wikipedia.org/wiki/Table_(database)>`__. Large predicates generate large tables with many rows, and are therefore expensive to compute.
- The QL language is implemented using standard database operations and `relational algebra <https://en.wikipedia.org/wiki/Relational_algebra>`__ (such as join, projection, and union). For more information about query languages and databases, see ":ref:`About the QL language <about-the-ql-language>`.
- Queries are evaluated *bottom-up*, which means that a predicate is not evaluated until *all* of the predicates that it depends on are evaluated. For more information on query evaluation, see ":ref:`Evaluation of QL programs <evaluation-of-ql-programs>`." 

Performance tips
----------------

Follow the guidelines below to ensure that you don't get tripped up by the most common CodeQL performance pitfalls.

Eliminate cartesian products
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The performance of a predicate can often be judged by considering roughly how many results it has. 
One way of creating badly performing predicates is by using two variables without relating them in any way, or only relating them using a negation.
This leads to computing the `Cartesian product <https://en.wikipedia.org/wiki/Cartesian_product>`__ between the sets of possible values for each variable, potentially generating a huge table of results.
This can occur if you don't specify restrictions on your variables. 
For instance, consider the following predicate that checks whether a Java method ``m`` may access a field ``f``::

   predicate mayAccess(Method m, Field f) {
     f.getAnAccess().getEnclosingCallable() = m
     or
     not exists(m.getBody())
   }

The predicate holds if ``m`` contains an access to ``f``, but also conservatively assumes that methods without bodies (for example, native methods) may access *any* field.

However, if ``m`` is a native method, the table computed by ``mayAccess`` will contain a row ``m, f`` for *all* fields ``f`` in the codebase, making it potentially very large.

This example shows a similar mistake in a member predicate::

     class Foo extends Class {
       ...
       // BAD! Does not use ‘this’ 
       Method getToString() {
         result.getName() = "ToString"
       }
       ...
     }

Note that while ``getToString()`` does not declare any parameters, it has two implicit parameters, ``result`` and ``this``, which it fails to relate. Therefore, the table computed by ``getToString()`` contains a row for every combination of ``result`` and ``this``. That is, a row for every combination of a method named ``"ToString"`` and an instance of ``Foo``.
To avoid making this mistake, ``this`` should be restricted in the member predicate ``getToString()`` on the class ``Foo``.

Use specific types
~~~~~~~~~~~~~~~~~~

":ref:`Types <types>`" provide an upper bound on the size of a relation. 
This helps the query optimizer be more effective, so it's generally good to use the most specific types possible. For example::

  predicate foo(LoggingCall e)

is preferred over::

  predicate foo(Expr e)

From the type context, the query optimizer deduces that some parts of the program are redundant and removes them, or *specializes* them.

Determine the most specific types of a variable
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are unfamiliar with the library used in a query, you can use CodeQL to determine what types an entity has. There is a predicate called ``getAQlClass()``, which returns the most specific QL types of the entity that it is called on.

For example, if you were working with a Java database, you might use ``getAQlClass()`` on every ``Expr`` in a callable called ``c``:

.. code-block:: ql

   import java

   from Expr e, Callable c
   where
       c.getDeclaringType().hasQualifiedName("my.namespace.name", "MyClass")
       and c.getName() = "c"
       and e.getEnclosingCallable() = c
   select e, e.getAQlClass()

The result of this query is a list of the most specific types of every ``Expr`` in that function. You will see multiple results for expressions that are represented by more than one type, so it will likely return a very large table of results.

Use ``getAQlClass()`` as a debugging tool, but don't include it in the final version of your query, as it slows down performance.

Avoid complex recursion
~~~~~~~~~~~~~~~~~~~~~~~

":ref:`Recursion <recursion>`" is about self-referencing definitions.
It can be extremely powerful as long as it is used appropriately.
On the whole, you should try to make recursive predicates as simple as possible.
That is, you should define a *base case* that allows the predicate to *bottom out*, along with a single *recursive call*::

  int depth(Stmt s) {
    exists(Callable c | c.getBody() = s | result = 0) // base case
    or
    result = depth(s.getParent()) + 1 // recursive call
  }

.. pull-quote:: Note

   The query optimizer has special data structures for dealing with :ref:`transitive closures <transitive-closures>`.
   If possible, use a transitive closure over a simple recursive predicate, as it is likely to be computed faster.

Fold predicates
~~~~~~~~~~~~~~~~~~

Sometimes you can assist the query optimizer by "folding" parts of large predicates out into smaller predicates.

The general principle is to split off chunks of work that are:

- **linear**, so that there is not too much branching.
- **tightly bound**, so that the chunks join with each other on as many variables as possible.


In the following example, we explore some lookups on two ``Element``\ s:

.. code-block:: ql

   predicate similar(Element e1, Element e2) {
     e1.getName() = e2.getName() and
     e1.getFile() = e2.getFile() and
     e1.getLocation().getStartLine() = e2.getLocation().getStartLine()
   }

Going from ``Element -> File`` and ``Element -> Location -> StartLine`` is linear--that is, there is only one ``File``, ``Location``, etc. for each ``Element``. 

However, as written it is difficult for the optimizer to pick out the best ordering. Joining first and then doing the linear lookups later would likely result in poor performance. Generally, we want to do the quick, linear parts first, and then join on the resultant larger tables. We can initiate this kind of ordering by splitting the above predicate as follows:

.. code-block:: ql

   predicate locInfo(Element e, string name, File f, int startLine) {
     name = e.getName() and
     f = e.getFile() and
     startLine = e.getLocation().getStartLine()
   }
   
   predicate sameLoc(Element e1, Element e2) {
     exists(string name, File f, int startLine |
       locInfo(e1, name, f, startLine) and
       locInfo(e2, name, f, startLine)
     )
   }

Now the structure we want is clearer. We've separated out the easy part into its own predicate ``locInfo``, and the main predicate ``sameLoc`` is just a larger join.

Further reading
---------------

.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
