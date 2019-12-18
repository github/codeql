Tutorial: Expressions and statements
====================================

Overview
--------

This tutorial develops a query for finding comparisons between integers and long integers in loops that may lead to non-termination due to overflow.

Specifically, consider the following code snippet:

.. code-block:: java

   void foo(long l) {
       for(int i=0; i<l; i++) {
           // do something
       }
   }

If ``l`` is bigger than 2\ :sup:`31`\ - 1 (the largest positive value of type ``int``), then this loop will never terminate: ``i`` will start at zero, being incremented all the way up to 2\ :sup:`31`\ - 1, which is still smaller than ``l``. When it is incremented once more, an arithmetic overflow occurs, and ``i`` becomes -2\ :sup:`31`\, which also is smaller than ``l``! Eventually, ``i`` will reach zero again, and the cycle repeats.

.. pull-quote::   

   More about overflow

   All primitive numeric types have a maximum value, beyond which they will wrap around to their lowest possible value (called an "overflow"). For ``int``, this maximum value is 2\ :sup:`31`\ - 1. Type ``long`` can accommodate larger values up to a maximum of 2\ :sup:`63`\ - 1. In this example, this means that ``l`` can take on a value that is higher than the maximum for type ``int``; ``i`` will never be able to reach this value, instead overflowing and returning to a low value.

We will develop a query that finds code that looks like it might exhibit this kind of behavior. We will be using several of the standard library classes for representing statements and functions, a full list of which can be found in the :doc:`AST class reference <ast-class-reference>`.

Initial query
-------------

We start out by writing a query that finds less-than expressions (CodeQL class ``LTExpr``) where the left operand is of type ``int`` and the right operand is of type ``long``:

.. code-block:: ql

   import java

   from LTExpr expr
   where expr.getLeftOperand().getType().hasName("int") and
       expr.getRightOperand().getType().hasName("long")
   select expr

➤ `See this in the query console <https://lgtm.com/query/672320008/>`__. This query usually finds results on most projects.

Notice that we use the predicate ``getType`` (available on all subclasses of ``Expr``) to determine the type of the operands. Types, in turn, define the ``hasName`` predicate, which allows us to identify the primitive types ``int`` and ``long``. As it stands, this query finds *all* less-than expressions comparing ``int`` and ``long``, but in fact we are only interested in comparisons that are part of a loop condition. Also, we want to filter out comparisons where either operand is constant, since these are less likely to be real bugs. The revised query looks as follows:

.. code-block:: ql

   import java

   from LTExpr expr
   where expr.getLeftOperand().getType().hasName("int") and
       expr.getRightOperand().getType().hasName("long") and
       exists(LoopStmt l | l.getCondition().getAChildExpr*() = expr) and
       not expr.getAnOperand().isCompileTimeConstant()
   select expr

➤ `See this in the query console <https://lgtm.com/query/690010001/>`__. Notice that fewer results are found.

The class ``LoopStmt`` is a common superclass of all loops, including, in particular, ``for`` loops as in our example above. While different kinds of loops have different syntax, they all have a loop condition, which can be accessed through predicate ``getCondition``. We use the reflexive transitive closure operator ``*`` applied to the ``getAChildExpr`` predicate to express the requirement that ``expr`` should be nested inside the loop condition. In particular, it can be the loop condition itself.

The final conjunct in the ``where`` clause takes advantage of the fact that `predicates <https://help.semmle.com/QL/ql-handbook/predicates.html>`__ can return more than one value (they are really relations). In particular, ``getAnOperand`` may return *either* operand of ``expr``, so ``expr.getAnOperand().isCompileTimeConstant()`` holds if at least one of the operands is constant. Negating this condition means that the query will only find expressions where *neither* of the operands is constant.

Generalizing the query
----------------------

Of course, comparisons between ``int`` and ``long`` are not the only problematic case: any less-than comparison between a narrower and a wider type is potentially suspect, and less-than-or-equals, greater-than, and greater-than-or-equals comparisons are just as problematic as less-than comparisons.

In order to compare the ranges of types, we define a predicate that returns the width (in bits) of a given integral type:

.. code-block:: ql

   int width(PrimitiveType pt) {
       (pt.hasName("byte") and result=8) or
       (pt.hasName("short") and result=16) or
       (pt.hasName("char") and result=16) or
       (pt.hasName("int") and result=32) or
       (pt.hasName("long") and result=64)
   }

We now want to generalize our query to apply to any comparison where the width of the type on the smaller end of the comparison is less than the width of the type on the greater end. Let us call such a comparison *overflow prone*, and introduce an abstract class to model it:

.. code-block:: ql

   abstract class OverflowProneComparison extends ComparisonExpr {
       Expr getLesserOperand() { none() }
       Expr getGreaterOperand() { none() }
   }

There are two concrete child classes of this class: one for ``<=`` or ``<`` comparisons, and one for ``>=`` or ``>`` comparisons. In both cases, we implement the constructor in such a way that it only matches the expressions we want:

.. code-block:: ql

   class LTOverflowProneComparison extends OverflowProneComparison {
       LTOverflowProneComparison() {
           (this instanceof LEExpr or this instanceof LTExpr) and
           width(this.getLeftOperand().getType()) < width(this.getRightOperand().getType())
       }
   }

   class GTOverflowProneComparison extends OverflowProneComparison {
       GTOverflowProneComparison() {
           (this instanceof GEExpr or this instanceof GTExpr) and
           width(this.getRightOperand().getType()) < width(this.getLeftOperand().getType())
       }
   }

Now we rewrite our query to make use of these new classes:

.. code-block:: ql

   import Java

   // Insert the class definitions from above

   from OverflowProneComparison expr
   where exists(LoopStmt l | l.getCondition().getAChildExpr*() = expr) and
   not expr.getAnOperand().isCompileTimeConstant()
   select expr

➤ `See the full query in the query console <https://lgtm.com/query/1951710018/lang:java/>`__.

What next?
----------

-  Have a look at some of the other tutorials: :doc:`Tutorial: Types and the class hierarchy <types-class-hierarchy>`, :doc:`Tutorial: Navigating the call graph <call-graph>`, :doc:`Tutorial: Annotations <annotations>`, :doc:`Tutorial: Javadoc <javadoc>`, and :doc:`Tutorial: Working with source locations <source-locations>`.
-  Find out how specific classes in the AST are represented in the standard library for Java: :doc:`AST class reference <ast-class-reference>`.
-  Find out more about QL in the `QL language handbook <https://help.semmle.com/QL/ql-handbook/index.html>`__ and `QL language specification <https://help.semmle.com/QL/ql-spec/language.html>`__.
