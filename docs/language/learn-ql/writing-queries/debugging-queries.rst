Query writing: common performance issues
========================================

This topic offers some simple tips on how to avoid commons problems that can affect the performance of your queries.
Before reading the tips below, it is worth reiterating a few important points about CodeQL and the QL language:

- In CodeQL `predicates <https://help.semmle.com/QL/ql-handbook/predicates.html>`__ and `classes <https://help.semmle.com/QL/ql-handbook/types.html#classes>`__ are all just database `relations <https://en.wikipedia.org/wiki/Relation_(database)>`__---that is, sets of tuples in a table. Large predicates generate tables with large numbers of rows, and are therefore expensive to compute.
- The QL language is implemented using standard database operations and `relational algebra <https://en.wikipedia.org/wiki/Relational_algebra>`__ (such as join, projection, union, etc.). For further information about query languages and databases, see :doc:`About QL <../about-ql>`.
- Queries is evaluated *bottom-up*, which means that a predicate is not evaluated until **all** of the predicates that it depends on are evaluated. For more information on query evaluation, see `Evaluation of QL programs <https://help.semmle.com/QL/ql-handbook/evaluation.html>`__ in the QL handbook. 

Performance tips
----------------

Follow the guidelines below to ensure that you don't get get tripped up by the most common CodeQL performance pitfalls.

Eliminate cartesian products
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The performance of a predicate can often be judged by considering roughly how many results it has. 
One way of creating badly performing predicates is by using two variables without relating them in any way, or only relating them using a negation.
This leads to computing the `Cartesian product <https://en.wikipedia.org/wiki/Cartesian_product>`__ between the sets of possible values for each variable, potentially generating a huge table of results.

This can occur whenever you inadvertently fail to specify restrictions on your variables. 

For instance, in the following case none of the parameters are related in the example predicate ``methodAndAClass``, and therefore the results are unrestricted::

   // BAD! Cross-product
   predicate methodAndAClass(Method m, Class c) {
   	  any()
   }

This example shows a similar mistake in a member predicate::

     class Foo extends Class {
       ...
       // BAD! Does not use ‘this’ 
       Method getToString() {
         result.getName().matches("ToString")
       }
       ...
     }

Here, the class ``Method getToString()`` is equivalent to ``predicate getToString(Class this, Method result)``, in which the parameters are unrestricted.
To avoid making this mistake, ``this`` should be restricted in the member predicate ``getToString()`` on the class ``Foo``.

Finally, consider a predicate of the following form::

  predicate p(T1 x1, T2 x2) { 
      <disjunction 1> or 
      <disjunction 2> or 
      ... 
      }

In this situation, if ``x1`` and ``x2`` are not mentioned in all ``<disjunction i>`` terms, the compiler will produce the Cartesian product between what you wanted and all possible values of the unused parameter.

Use specific types
~~~~~~~~~~~~~~~~~~

`Types <https://help.semmle.com/QL/ql-handbook/types.html>`__ provide an upper bound on the size of a relation. 
This helps the query optimizer be more effective, so it's generally good to use the most specific types possible. For example::

  predicate foo(LoggingCall e)

is preferred over::

  predicate foo(Expr e)

From the type context, the query optimizer deduces that some parts of the program are redundant and removes them, or **specializes** them.

Avoid complex recursion
~~~~~~~~~~~~~~~~~~~~~~~

`Recursion <https://help.semmle.com/QL/ql-handbook/recursion.html>`__ is about self-referencing definitions.
It can be extremely powerful as long as it is used appropriately.
On the whole, you should try to make recursive predicates as simple as possible.
That is, you should define a **base case** that allows the predicate to *bottom out*, along with a single **recursive call**::

  int depth(Stmt s) {
    exists(Callable c | c.getBody() = s | result = 0) // base case
    or
    result = depth(s.getParent()) + 1 // recursive case
  }

.. pull-quote:: Note

   The query optimizer has special data structures for dealing with `transitive closures <https://help.semmle.com/QL/ql-handbook/recursion.html#transitive-closures>`__.
   If possible, use a transitive closure over a simple recursive predicate, as it is likely to be computed faster.

Further information
-------------------

- Find out more about QL in the `QL language handbook <https://help.semmle.com/QL/ql-handbook/index.html>`__ and `QL language specification <https://help.semmle.com/QL/ql-spec/language.html>`__.