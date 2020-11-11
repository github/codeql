.. _working-with-source-locations:

Working with source locations
=============================

You can use the location of entities within Java code to look for potential errors. Locations allow you to deduce the presence, or absence, of white space which, in some cases, may indicate a problem.

About source locations
----------------------

Java offers a rich set of operators with complex precedence rules, which are sometimes confusing to developers. For instance, the class ``ByteBufferCache`` in the OpenJDK Java compiler (which is a member class of ``com.sun.tools.javac.util.BaseFileManager``) contains this code for allocating a buffer:

.. code-block:: java

   ByteBuffer.allocate(capacity + capacity>>1)

Presumably, the author meant to allocate a buffer that is 1.5 times the size indicated by the variable ``capacity``. In fact, however, operator ``+`` binds tighter than operator ``>>``, so the expression ``capacity + capacity>>1`` is parsed as ``(capacity + capacity)>>1``, which equals ``capacity`` (unless there is an arithmetic overflow).

Note that the source layout gives a fairly clear indication of the intended meaning: there is more white space around ``+`` than around ``>>``, suggesting that the latter is meant to bind more tightly.

We're going to develop a query that finds this kind of suspicious nesting, where the operator of the inner expression has more white space around it than the operator of the outer expression. This pattern may not necessarily indicate a bug, but at the very least it makes the code hard to read and prone to misinterpretation.

White space is not directly represented in the CodeQL database, but we can deduce its presence from the location information associated with program elements and AST nodes. So, before we write our query, we need an understanding of source location management in the standard library for Java.

Location API
------------

For every entity that has a representation in Java source code (including, in particular, program elements and AST nodes), the standard CodeQL library provides these predicates for accessing source location information:

-  ``getLocation`` returns a ``Location`` object describing the start and end position of the entity.
-  ``getFile`` returns a ``File`` object representing the file containing the entity.
-  ``getTotalNumberOfLines`` returns the number of lines the source code of the entity spans.
-  ``getNumberOfCommentLines`` returns the number of comment lines.
-  ``getNumberOfLinesOfCode`` returns the number of non-comment lines.

For example, let's assume this Java class is defined in the compilation unit ``SayHello.java``:

.. code-block:: java

   package pkg;

   class SayHello {
       public static void main(String[] args) {
           System.out.println(
               // Display personalized message
               "Hello, " + args[0];
           );
       }
   }

Invoking ``getFile`` on the expression statement in the body of ``main`` returns a ``File`` object representing the file ``SayHello.java``. The statement spans four lines in total ``(getTotalNumberOfLines``), of which one is a comment line (``getNumberOfCommentLines``), while three lines contain code (``getNumberOfLinesOfCode``).

Class ``Location`` defines member predicates ``getStartLine``, ``getEndLine``, ``getStartColumn`` and ``getEndColumn`` to retrieve the line and column number an entity starts and ends at, respectively. Both lines and columns are counted starting from 1 (not 0), and the end position is inclusive, that is, it is the position of the last character belonging to the source code of the entity.

In our example, the expression statement starts at line 5, column 3 (the first two characters on the line are tabs, which each count as one character), and it ends at line 8, column 4.

Class ``File`` defines these member predicates:

-  ``getAbsolutePath`` returns the fully qualified name of the file.
-  ``getRelativePath`` returns the path of the file relative to the base directory of the source code.
-  ``getExtension`` returns the extension of the file.
-  ``getStem`` returns the base name of the file, without its extension.

In our example, assume file ``A.java`` is located in directory ``/home/testuser/code/pkg``, where ``/home/testuser/code`` is the base directory of the program being analyzed. Then, a ``File`` object for ``A.java`` returns:

-  ``getAbsolutePath`` is ``/home/testuser/code/pkg/A.java``.
-  ``getRelativePath`` is ``pkg/A.java``.
-  ``getExtension`` is ``java``.
-  ``getStem`` is ``A``.

Determining white space around an operator
------------------------------------------

Let's start by considering how to write a predicate that computes the total amount of white space surrounding the operator of a given binary expression. If ``rcol`` is the start column of the expression's right operand and ``lcol`` is the end column of its left operand, then ``rcol - (lcol+1)`` gives us the total number of characters in between the two operands (note that we have to use ``lcol+1`` instead of ``lcol`` because end positions are inclusive).

This number includes the length of the operator itself, which we need to subtract out. For this, we can use predicate ``getOp``, which returns the operator string, surrounded by one white space on either side. Overall, the expression for computing the amount of white space around the operator of a binary expression ``expr`` is:

.. code-block:: ql

   rcol - (lcol+1) - (expr.getOp().length()-2)

Clearly, however, this only works if the entire expression is on a single line, which we can check using predicate ``getTotalNumberOfLines`` introduced above. We are now in a position to define our predicate for computing white space around operators:

.. code-block:: ql

   int operatorWS(BinaryExpr expr) {
       exists(int lcol, int rcol |
           expr.getNumberOfLinesOfCode() = 1 and
           lcol = expr.getLeftOperand().getLocation().getEndColumn() and
           rcol = expr.getRightOperand().getLocation().getStartColumn() and
           result = rcol - (lcol+1) - (expr.getOp().length()-2)
       )
   }

Notice that we use an ``exists`` to introduce our temporary variables ``lcol`` and ``rcol``. You could write the predicate without them by just inlining ``lcol`` and ``rcol`` into their use, at some cost in readability.

Find suspicious nesting
-----------------------

Here's a first version of our query:

.. code-block:: ql

   import java

   // Insert predicate defined above

   from BinaryExpr outer, BinaryExpr inner,
       int wsouter, int wsinner
   where inner = outer.getAChildExpr() and
       wsinner = operatorWS(inner) and wsouter = operatorWS(outer) and
       wsinner > wsouter
   select outer, "Whitespace around nested operators contradicts precedence."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/8141155897270480914/>`__. This query is likely to find results on most projects.

The first conjunct of the ``where`` clause restricts ``inner`` to be an operand of ``outer``, the second conjunct binds ``wsinner`` and ``wsouter``, while the last conjunct selects the suspicious cases.

At first, we might be tempted to write ``inner = outer.getAnOperand()`` in the first conjunct. This, however, wouldn't be quite correct: ``getAnOperand`` strips off any surrounding parentheses from its result, which is often useful, but not what we want here: if there are parentheses around the inner expression, then the programmer probably knew what they were doing, and the query should not flag this expression.

Improving the query
~~~~~~~~~~~~~~~~~~~

If we run this initial query, we might notice some false positives arising from asymmetric white space. For instance, the following expression is flagged as suspicious, although it is unlikely to cause confusion in practice:

.. code-block:: java

   i< start + 100

Note that our predicate ``operatorWS`` computes the **total** amount of white space around the operator, which, in this case, is one for the ``<`` and two for the ``+``. Ideally, we would like to exclude cases where the amount of white space before and after the operator are not the same. Currently, CodeQL databases don't record enough information to figure this out, but as an approximation we could require that the total number of white space characters is even:

.. code-block:: ql

   import java

   // Insert predicate definition from above

   from BinaryExpr outer, BinaryExpr inner,
       int wsouter, int wsinner
   where inner = outer.getAChildExpr() and
       wsinner = operatorWS(inner) and wsouter = operatorWS(outer) and
       wsinner % 2 = 0 and wsouter % 2 = 0 and
       wsinner > wsouter
   select outer, "Whitespace around nested operators contradicts precedence."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/3151720037708691205/>`__. Any results will be refined by our changes to the query.

Another source of false positives are associative operators: in an expression of the form ``x + y+z``, the first plus is syntactically nested inside the second, since + in Java associates to the left; hence the expression is flagged as suspicious. But since + is associative to begin with, it does not matter which way around the operators are nested, so this is a false positive. To exclude these cases, let us define a new class identifying binary expressions with an associative operator:

.. code-block:: ql

   class AssociativeOperator extends BinaryExpr {
       AssociativeOperator() {
           this instanceof AddExpr or
           this instanceof MulExpr or
           this instanceof BitwiseExpr or
           this instanceof AndLogicalExpr or
           this instanceof OrLogicalExpr
       }
   }

Now we can extend our query to discard results where the outer and the inner expression both have the same, associative operator:

.. code-block:: ql

   import java

   // Insert predicate and class definitions from above

   from BinaryExpr inner, BinaryExpr outer, int wsouter, int wsinner
   where inner = outer.getAChildExpr() and
       not (inner.getOp() = outer.getOp() and outer instanceof AssociativeOperator) and
       wsinner = operatorWS(inner) and wsouter = operatorWS(outer) and
       wsinner % 2 = 0 and wsouter % 2 = 0 and
       wsinner > wsouter
   select outer, "Whitespace around nested operators contradicts precedence."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/5714614966569401039/>`__.

Notice that we again use ``getOp``, this time to determine whether two binary expressions have the same operator. Running our improved query now finds the Java standard library bug described in the Overview. It also flags up the following suspicious code in `Hadoop HBase <https://hbase.apache.org/>`__:

.. code-block:: java

   KEY_SLAVE = tmp[ i+1 % 2 ];

Whitespace suggests that the programmer meant to toggle ``i`` between zero and one, but in fact the expression is parsed as ``i + (1%2)``, which is the same as ``i + 1``, so ``i`` is simply incremented.

Further reading
---------------

.. include:: ../../reusables/java-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
